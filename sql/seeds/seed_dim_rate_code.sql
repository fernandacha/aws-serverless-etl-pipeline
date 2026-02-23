-- seed_dim_rate_code
-- Seeds RatecodeID mappings as defined by NYC TLC data dictionary. :contentReference[oaicite:6]{index=6}

INSERT INTO dim_rate_code (rate_code_id, rate_code_description) VALUES
  (1, 'Standard rate'),
  (2, 'JFK'),
  (3, 'Newark'),
  (4, 'Nassau or Westchester'),
  (5, 'Negotiated fare'),
  (6, 'Group ride'),
  (99, 'Null/unknown')
ON CONFLICT (rate_code_id) DO UPDATE
SET rate_code_description = EXCLUDED.rate_code_description;
