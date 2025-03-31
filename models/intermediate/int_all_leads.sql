WITH sf_leads AS (
    SELECT
      lead_id,
      phone,
      email,
      street,
      city,
      state,
      postal_code,
      status,
      'salesforce' AS source_name,
      created_date
    FROM {{ ref('stg_salesforce_leads') }}
),

source_1 AS (
    SELECT
      NULL::INT AS lead_id,
      phone,
      NULL AS email,  -- not in source_1
      raw_address AS address,
      state,
      NULL AS postal_code,  -- could parse from raw_address if time
      license_status AS status,
      'source_1' AS source_name,
      NULL AS created_date  -- not in source_1
    FROM {{ ref('stg_source_1') }}
),

source_2 AS (
    SELECT
      NULL::INT AS lead_id,
      phone,
      email,
      CONCAT(address_line1, ' ', address_line2) AS address,
      city,
      state,
      postal_code,
      NULL AS status,
      'source_2' AS source_name,
      NULL AS created_date
    FROM {{ ref('stg_source_2') }}
),

source_3 AS (
    SELECT
      NULL::INT AS lead_id,
      phone,
      email,
      address,
      city,
      state,
      postal_code,
      facility_status AS status,
      'source_3' AS source_name,
      NULL AS created_date
    FROM {{ ref('stg_source_3') }}
),

all_union AS (
    SELECT * FROM sf_leads
    UNION ALL
    SELECT * FROM source_1
    UNION ALL
    SELECT * FROM source_2
    UNION ALL
    SELECT * FROM source_3
),

/* 
   Example: Here we deduplicate by phone if possible, else we deduplicate by
   (city, state, address). The approach below uses a ROW_NUMBER
   partition to pick the "best" row, giving preference to known 
   lead_id or non-null created_date. 
*/
ranked AS (
    SELECT
      *,
      ROW_NUMBER() OVER (
        PARTITION BY phone, city, state, postal_code
        ORDER BY 
          CASE WHEN lead_id IS NOT NULL THEN 1 ELSE 2 END,
          CASE WHEN created_date IS NOT NULL THEN 1 ELSE 2 END
      ) AS rn
    FROM all_union
)

SELECT
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
FROM ranked
WHERE rn = 1;
