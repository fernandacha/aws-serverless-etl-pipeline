-- Dimension: Rate Code
-- Purpose: Normalizes RatecodeID into a dimension to avoid magic numbers in reporting.
-- Source: NYC TLC Yellow Taxi Trip Records data dictionary.

CREATE TABLE IF NOT EXISTS dim_rate_code (
  rate_code_id SMALLINT PRIMARY KEY,
  rate_code_description VARCHAR(100) NOT NULL
);
