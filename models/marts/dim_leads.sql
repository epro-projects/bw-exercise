SELECT
  COALESCE(
    CAST(lead_id AS VARCHAR),
    CONCAT(phone,'|',COALESCE(postal_code,''))  -- fallback key if lead_id is null
  ) AS lead_key,

  lead_id,
  phone,
  email,
  address,
  city,
  state,
  postal_code,
  status,
  source_name,
  created_date
FROM {{ ref('int_all_leads') }}
