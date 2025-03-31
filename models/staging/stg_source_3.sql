WITH raw AS (
  SELECT
    TRIM(Operation) AS operation_id,
    TRIM("Operation Name") AS operation_name,
    TRIM(Address) AS address,
    TRIM(City) AS city,
    TRIM(State) AS state,
    TRIM(Zip) AS postal_code,
    TRIM(County) AS county,
    TRIM(Phone) AS phone,
    TRIM(Type) AS facility_type,
    TRIM(Status) AS facility_status,
    TRIM("Issue Date") AS issue_date,
    CAST(Capacity AS INT) AS capacity,
    TRIM("Email Address") AS email,
    TRIM("Facility ID") AS facility_id
  FROM {{ ref('source_3') }}
)

SELECT
  operation_id,
  operation_name,
  address,
  city,
  state,
  postal_code,
  county,
  phone,
  facility_type,
  facility_status,
  issue_date,
  capacity,
  email,
  facility_id
FROM raw;
