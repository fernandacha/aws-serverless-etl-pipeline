-- Dimension: Payment Type
-- Purpose: Normalizes payment type codes into readable descriptions for analytics.
-- Source: NYC TLC Yellow Taxi Trip Records data dictionary.

CREATE TABLE IF NOT EXISTS dim_payment_type (
  payment_type_id SMALLINT PRIMARY KEY,
  payment_description VARCHAR(50) NOT NULL
);
