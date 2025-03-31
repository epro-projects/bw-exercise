WITH raw AS (
  SELECT
    CAST(id AS INT) AS lead_id,
    is_deleted,
    COALESCE(NULLIF(TRIM(last_name), ''), 'Unknown') AS last_name,
    TRIM(first_name) AS first_name,
    TRIM(title) AS title,
    TRIM(company) AS company,
    TRIM(street) AS street,
    TRIM(city) AS city,
    TRIM(state) AS state,
    TRIM(postal_code) AS postal_code,
    TRIM(country) AS country,
    TRIM(phone) AS phone,
    TRIM(mobile_phone) AS mobile_phone,
    TRIM(email) AS email,
    TRIM(website) AS website,
    TRIM(lead_source) AS lead_source,
    TRIM(status) AS status,
    is_converted,
    created_date,
    last_modified_date,
    last_activity_date,
    last_viewed_date,
    last_referenced_date,
    outreach_stage_c,
    current_enrollment_c,
    capacity_c,
    lead_source_last_updated_c,
    brightwheel_school_uuid_c
  FROM {{ ref('salesforce_leads') }} 
)

SELECT
  lead_id,
  is_deleted,
  last_name,
  first_name,
  title,
  company,
  street,
  city,
  state,
  postal_code,
  country,
  phone,
  mobile_phone,
  email,
  website,
  lead_source,
  status,
  is_converted,
  created_date,
  last_modified_date,
  last_activity_date,
  last_viewed_date,
  last_referenced_date,
  outreach_stage_c,
  current_enrollment_c,
  capacity_c,
  lead_source_last_updated_c,
  brightwheel_school_uuid_c
FROM raw;
