-- Dimension: Payment Type
CREATE TABLE dim_payment_type (
  payment_type_id SMALLINT PRIMARY KEY,
  payment_description VARCHAR(50) NOT NULL
);
