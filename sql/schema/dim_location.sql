-- Dimension: Location
CREATE TABLE dim_location (
  location_id INT PRIMARY KEY,
  borough VARCHAR(50),
  zone VARCHAR(100),
  service_zone VARCHAR(50)
);
