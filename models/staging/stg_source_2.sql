WITH raw AS (
  SELECT
    TRIM("Type License") AS license_type,
    TRIM(Company) AS company_name,
    TRIM("Primary Caregiver") AS primary_contact,
    TRIM(Phone) AS phone,
    TRIM(Email) AS email,
    TRIM(Address1) AS address_line1,
    TRIM(Address2) AS address_line2,
    TRIM(City) AS city,
    TRIM(State) AS state,
    TRIM(Zip) AS postal_code,
    TRIM("Subsidy Contract Number") AS subsidy_contract_number,
    CAST("Total Cap" AS INT) AS capacity,
    ...
  FROM {{ ref('source_2') }}
)

SELECT
  license_type,
  company_name,
  primary_contact,
  phone,
  email,
  address_line1,
  address_line2,
  city,
  state,
  postal_code,
  subsidy_contract_number,
  capacity
  -- etc. (include other columns as we need)
FROM raw;
