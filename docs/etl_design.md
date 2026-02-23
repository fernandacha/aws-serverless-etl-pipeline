# ETL Design

## Source Layer
- NYC TLC Yellow Taxi Parquet file (May 2025)

## Staging Layer
- Raw parquet ingested
- Column normalization (snake_case)
- Type casting
- Null handling

## Transformation Layer
- Derive date attributes from pickup datetime
- Map vendor_id → dim_vendor
- Map payment_type → dim_payment_type
- Map rate_code_id → dim_rate_code
- Prepare location joins via TLC zone lookup file

## Warehouse Layer
- Load dimension tables first
- Load fact_trips referencing surrogate keys

## Incremental Strategy
- Partition by pickup_date
- Append-only strategy for new monthly files
