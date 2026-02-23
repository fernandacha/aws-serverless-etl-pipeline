-- Dimension: Date
-- Purpose: Date dimension derived from pickup/dropoff timestamps.
-- Provides common reporting attributes (month, quarter, weekend flag) for time-based aggregations.

CREATE TABLE IF NOT EXISTS dim_date (
  date_key DATE PRIMARY KEY,
  year SMALLINT NOT NULL,
  month SMALLINT NOT NULL,
  day SMALLINT NOT NULL,
  day_of_week SMALLINT NOT NULL,
  month_name VARCHAR(20),
  quarter SMALLINT,
  is_weekend BOOLEAN
);
