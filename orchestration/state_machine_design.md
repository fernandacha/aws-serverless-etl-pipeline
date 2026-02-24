# Orchestration Design (Step Functions Style)

This document describes the orchestration flow for the NYC TLC Yellow Taxi ETL pipeline.  
The target implementation is AWS Step Functions, but the design is tool-agnostic and can be adapted to Airflow or other orchestrators.

## Goals
- Reliable, repeatable monthly loads (Parquet source)
- Clear separation of extract, transform, and load phases
- Idempotent behavior at the partition level (month / pickup_date)
- Built-in data quality validation and alerting
- Observability for failures and SLA monitoring

## Inputs
- `run_id` (string): unique execution identifier
- `source_month` (string): `2025-05`
- `source_file_path` (string): `data/raw/yellow_tripdata_2025-05.parquet`
- `zone_lookup_path` (string): TLC taxi zone lookup file path (for `dim_location`)
- `load_mode` (string): `full` | `incremental` (default: `incremental`)

## Outputs
- Warehouse tables populated:
  - `dim_vendor`, `dim_payment_type`, `dim_rate_code` (seeded)
  - `dim_location` (from zone lookup)
  - `dim_date` (derived)
  - `fact_trips` (loaded after dimensions)
- Execution report:
  - row counts in/out per step
  - rejected/flagged record counts
  - timing and status per step

## High-Level State Machine

1. **InitializeRun**
2. **ValidateInputs**
3. **LoadSeedDimensions**
4. **LoadLocationDimension**
5. **ExtractTrips**
6. **TransformTrips**
7. **BuildDateDimension**
8. **LoadFactTrips**
9. **RunDataQualityChecks**
10. **PublishMetricsAndNotify**
11. **Success / Fail**

## State Details

### 1) InitializeRun
**Purpose:** Set defaults, create run context, start timer.  
**Outputs:** `run_id`, `start_time`, normalized parameters.

### 2) ValidateInputs
**Purpose:** Ensure required files/inputs exist and are readable.  
**Checks:**
- source file path exists
- zone lookup path exists
- `source_month` matches file naming convention
- `load_mode` is valid

**On failure:** Stop execution and notify.

### 3) LoadSeedDimensions
**Purpose:** Ensure code/lookup dimensions exist and are populated.  
**Actions:**
- Execute seed SQL for:
  - `dim_vendor`
  - `dim_payment_type`
  - `dim_rate_code`

**Idempotency:** `INSERT ... ON CONFLICT DO UPDATE` (safe re-run).

### 4) LoadLocationDimension
**Purpose:** Populate `dim_location` from TLC taxi zone lookup file.  
**Actions:**
- Read zone lookup
- Standardize casing and null handling
- Upsert into `dim_location`

**Idempotency:** Upsert by `location_id`.

### 5) ExtractTrips
**Purpose:** Read source Parquet and select required columns.  
**Actions:**
- Read Parquet
- Select columns listed in `docs/mapping.md`
- Apply initial type casting

**Outputs:**
- staging dataset (in-memory or intermediate file)
- row count extracted

### 6) TransformTrips
**Purpose:** Apply transformation rules required for warehouse loading.  
**Actions:**
- Normalize column names to snake_case
- Cast numeric fields (fare, taxes, fees)
- Normalize `store_and_fwd_flag` to 'Y'/'N'/NULL
- Derive `pickup_date` = DATE(pickup_datetime)

**Partitioning Strategy (design):**
- Partition by `pickup_date` (or `source_month`)
- Enables incremental loads and reprocessing of a month partition

**Outputs:**
- transformed dataset
- row count transformed
- invalid/flagged counts

### 7) BuildDateDimension
**Purpose:** Create rows for `dim_date` based on transformed trips.  
**Actions:**
- Extract distinct `pickup_date`
- Derive:
  - year, month, day, day_of_week
  - month_name, quarter, is_weekend
- Upsert into `dim_date`

**Idempotency:** Upsert by `date_key`.

### 8) LoadFactTrips
**Purpose:** Load transformed trips into `fact_trips`.  
**Actions:**
- Enforce dimension integrity:
  - vendor_id must exist in `dim_vendor`
  - payment_type_id must exist in `dim_payment_type`
  - rate_code_id must exist in `dim_rate_code`
  - pickup/dropoff locations must exist in `dim_location`
- Load to `fact_trips`

**Idempotency (design):**
- For monthly partition loads, delete-and-reload for `source_month` (or pickup_date range), then insert
- Alternative: use a natural key hash + upsert (future enhancement)

### 9) RunDataQualityChecks
**Purpose:** Validate data completeness and correctness after load.  
**Examples:**
- `pickup_datetime` and `dropoff_datetime` not null
- `trip_distance >= 0`
- `total_amount` not null
- Unexpected spikes/drops in row counts compared to prior month (optional)

**On failure:**
- Mark run as failed
- Notify with details and metrics
- (Optional) rollback partition if supported

### 10) PublishMetricsAndNotify
**Purpose:** Emit run metrics and notify stakeholders.  
**Metrics:**
- records extracted/transformed/loaded
- rejected/flagged counts
- execution time per step

**Notifications:**
- success notification (summary)
- failure notification (error + step + run_id)

## Error Handling Strategy
- Fail fast on input validation errors
- Retry transient steps (read failures, temporary DB issues)
- Do not retry deterministic transformation errors without code change
- Include run context in all logs/alerts (`run_id`, `source_month`)

## Observability
- Log key metrics at each state
- Track row counts and execution durations
- Persist run summary (optional future enhancement)

## Future Enhancements
- Add CI validations (SQL formatting, basic tests)
- Add automated anomaly detection (row count / revenue checks)
- Add dbt transformation layer for marts
- Add streaming ingestion option (Kafka/Kinesis) as extension
