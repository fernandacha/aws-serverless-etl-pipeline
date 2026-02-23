-- Dimension: Vendor
-- Purpose: Stores vendor metadata for taxi trip records.
-- Source: NYC TLC Yellow Taxi Trip Records data dictionary.

CREATE TABLE dim_vendor (
  vendor_id INT PRIMARY KEY,
  vendor_name VARCHAR(100) NOT NULL
);
