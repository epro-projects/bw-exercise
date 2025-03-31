WITH raw AS (
  SELECT
    TRIM(Name) AS facility_name,
    TRIM("Credential Type") AS credential_type,
    TRIM("Credential Number") AS credential_number,
    TRIM(Status) AS license_status,
    TRIM("Expiration Date") AS license_expiration_date,
    TRIM("Disciplinary Action") AS disciplinary_action,
    TRIM(Address) AS raw_address,
    TRIM(State) AS state,
    TRIM(County) AS county,
    TRIM(Phone) AS phone,
    TRIM("Primary Contact Name") AS contact_name,
    TRIM("Primary Contact Role") AS contact_role
  FROM {{ ref('source_1') }}
)

SELECT
  facility_name,
  credential_type,
  credential_number,
  license_status,
  license_expiration_date,
  disciplinary_action,
  raw_address,
  state,
  county,
  phone,
  contact_name,
  contact_role
FROM raw;
