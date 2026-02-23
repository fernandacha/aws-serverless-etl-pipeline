-- Dimension: Date
CREATE TABLE dim_date (
  date_key DATE PRIMARY KEY,
  year SMALLINT NOT NULL,
  month SMALLINT NOT NULL,
  day SMALLINT NOT NULL,
  day_of_week SMALLINT NOT NULL,
  month_name VARCHAR(20),
  quarter SMALLINT,
  is_weekend BOOLEAN
);
