-- Fact: Trips
CREATE TABLE fact_trips (
  trip_id BIGSERIAL PRIMARY KEY,

  pickup_datetime TIMESTAMP NOT NULL,
  dropoff_datetime TIMESTAMP NOT NULL,

  passenger_count SMALLINT,
  trip_distance DOUBLE PRECISION,

  fare_amount DOUBLE PRECISION,
  extra DOUBLE PRECISION,
  mta_tax DOUBLE PRECISION,
  tip_amount DOUBLE PRECISION,
  tolls_amount DOUBLE PRECISION,
  improvement_surcharge DOUBLE PRECISION,
  congestion_surcharge DOUBLE PRECISION,
  airport_fee DOUBLE PRECISION,
  cbd_congestion_fee DOUBLE PRECISION,
  total_amount DOUBLE PRECISION,

  vendor_id INT,
  rate_code_id SMALLINT,
  payment_type_id SMALLINT,
  store_and_fwd_flag VARCHAR(1),

  pickup_location_id INT,
  dropoff_location_id INT,

  FOREIGN KEY (vendor_id) REFERENCES dim_vendor(vendor_id),
  FOREIGN KEY (rate_code_id) REFERENCES dim_rate_code(rate_code_id),
  FOREIGN KEY (payment_type_id) REFERENCES dim_payment_type(payment_type_id),
  FOREIGN KEY (pickup_location_id) REFERENCES dim_location(location_id),
  FOREIGN KEY (dropoff_location_id) REFERENCES dim_location(location_id)
);
