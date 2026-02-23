-- Dimension: Location
-- Purpose: Stores geographic metadata for pickup/dropoff locations.
-- Note: Populated from the TLC Taxi Zone lookup file.

CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  borough VARCHAR(50),
  zone VARCHAR(100),
  service_zone VARCHAR(50)
);
