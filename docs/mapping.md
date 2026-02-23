# ETL Source-to-Target Mapping (NYC TLC Yellow Taxi)

This document maps source fields from the NYC TLC Yellow Taxi trip records (Parquet) into the dimensional warehouse model used in this project.

## Source Dataset
- NYC TLC Yellow Taxi Trip Records (Yellow Taxi)
- Format: Parquet
- Example month: 2025-05

## Mapping Conventions
- Source column names follow TLC naming (e.g., `VendorID`, `tpep_pickup_datetime`).
- Target columns follow warehouse-friendly snake_case (e.g., `vendor_id`, `pickup_datetime`).
- Dimensions are loaded before facts.
- `dim_date` is derived from pickup/dropoff timestamps.
- Code-to-description dimensions (`dim_vendor`, `dim_payment_type`, `dim_rate_code`) are seeded from the TLC data dictionary.

## Trip Fact Mapping (`fact_trips`)

| Source Column | Target Column | Target Table | Transformation / Rule |
|---|---|---|---|
| `tpep_pickup_datetime` | `pickup_datetime` | `fact_trips` | Rename + cast to TIMESTAMP |
| `tpep_dropoff_datetime` | `dropoff_datetime` | `fact_trips` | Rename + cast to TIMESTAMP |
| `passenger_count` | `passenger_count` | `fact_trips` | Cast to SMALLINT; nulls allowed |
| `trip_distance` | `trip_distance` | `fact_trips` | Cast to DOUBLE PRECISION |
| `fare_amount` | `fare_amount` | `fact_trips` | Cast to DOUBLE PRECISION |
| `extra` | `extra` | `fact_trips` | Cast to DOUBLE PRECISION |
| `mta_tax` | `mta_tax` | `fact_trips` | Cast to DOUBLE PRECISION |
| `tip_amount` | `tip_amount` | `fact_trips` | Cast to DOUBLE PRECISION |
| `tolls_amount` | `tolls_amount` | `fact_trips` | Cast to DOUBLE PRECISION |
| `improvement_surcharge` | `improvement_surcharge` | `fact_trips` | Cast to DOUBLE PRECISION |
| `congestion_surcharge` | `congestion_surcharge` | `fact_trips` | Cast to DOUBLE PRECISION |
| `Airport_fee` | `airport_fee` | `fact_trips` | Rename + cast to DOUBLE PRECISION |
| `cbd_congestion_fee` | `cbd_congestion_fee` | `fact_trips` | Cast to DOUBLE PRECISION |
| `total_amount` | `total_amount` | `fact_trips` | Cast to DOUBLE PRECISION |
| `store_and_fwd_flag` | `store_and_fwd_flag` | `fact_trips` | Normalize to 'Y'/'N' (string length 1); allow null |
| `VendorID` | `vendor_id` | `fact_trips` | Rename + cast to INT; must exist in `dim_vendor` (seeded) |
| `RatecodeID` | `rate_code_id` | `fact_trips` | Rename + cast to SMALLINT; must exist in `dim_rate_code` (seeded) |
| `payment_type` | `payment_type_id` | `fact_trips` | Rename + cast to SMALLINT; must exist in `dim_payment_type` (seeded) |
| `PULocationID` | `pickup_location_id` | `fact_trips` | Rename + cast to INT; join to `dim_location` via TLC zone lookup |
| `DOLocationID` | `dropoff_location_id` | `fact_trips` | Rename + cast to INT; join to `dim_location` via TLC zone lookup |

## Date Dimension Derivation (`dim_date`)

`dim_date` is derived (not directly sourced) from the trip timestamps.

### Source Fields
- `tpep_pickup_datetime` (primary)
- `tpep_dropoff_datetime` (optional future enhancement for dropoff-date analytics)

### Derived Columns
| Derived From | Target Column | Target Table | Transformation / Rule |
|---|---|---|---|
| `DATE(tpep_pickup_datetime)` | `date_key` | `dim_date` | Date portion of pickup timestamp |
| `date_key` | `year` | `dim_date` | Extract year from date_key |
| `date_key` | `month` | `dim_date` | Extract month from date_key |
| `date_key` | `day` | `dim_date` | Extract day from date_key |
| `date_key` | `day_of_week` | `dim_date` | Extract day-of-week (define convention in transform step) |
| `date_key` | `month_name` | `dim_date` | Derived month name (e.g., 'May') |
| `date_key` | `quarter` | `dim_date` | Derived quarter (1-4) |
| `date_key` | `is_weekend` | `dim_date` | True if day_of_week is Saturday/Sunday |

## Code/Lookup Dimensions (Seeded)

These dimensions are loaded from the official TLC data dictionary (seed scripts included in this repo):

- `dim_vendor` (from `VendorID`)
- `dim_payment_type` (from `payment_type`)
- `dim_rate_code` (from `RatecodeID`)

## Location Dimension (`dim_location`)

`dim_location` is populated using the TLC Taxi Zone Lookup file (separate dataset).

| Source Column | Target Column | Target Table | Transformation / Rule |
|---|---|---|---|
| Zone lookup `LocationID` | `location_id` | `dim_location` | Primary key for location |
| Zone lookup `Borough` | `borough` | `dim_location` | Standardize casing |
| Zone lookup `Zone` | `zone` | `dim_location` | Standardize casing |
| Zone lookup `service_zone` | `service_zone` | `dim_location` | Standardize casing |

## Data Quality Rules (Initial)

These rules are applied during transformation and/or load:
- `pickup_datetime` and `dropoff_datetime` must not be null
- Negative monetary values should be flagged (not dropped by default)
- Trips with `trip_distance < 0` should be flagged
- Unknown codes should map to existing dimension values (e.g., rate code 99)

## Incremental Load Strategy (Design)

- Partition by `pickup_date` (derived from `pickup_datetime`)
- Append-only for new monthly files
- Reprocessing strategy: allow idempotent loads per month partition (future enhancement)
