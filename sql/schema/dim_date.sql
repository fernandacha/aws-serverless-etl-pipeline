-- Dimension: Date
CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    day_of_week INT
);
