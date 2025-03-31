# Brightwheel Exercise

## 1. Overview

This repository demonstrates how to ingest and unify four different data sources into a single leads table for analytical and CRM purposes. I have:

1. **Salesforce Leads** (daily)
2. **Source 1** (monthly file)
3. **Source 2** (monthly file)
4. **Source 3** (monthly file)

The final output is a **single data model**—one row per lead—that can quickly answer business questions like:

- Are there net-new leads or duplicates across sources?
- Which source provides the best-performing leads?
- How many leads are in “Working” vs. “Assigned” status?
- When was each lead loaded into Salesforce?

This exercise was completed under a 2-hour constraint, so certain trade-offs and simplifications were made, as described below.

---

## 2. Trade-offs and Future Enhancements

### 2.1 Trade-offs Made Under Time Constraints

- **Minimal Deduplication Logic**: I used a simple `phone + address` deduplication approach. In a production system, I might normalize phone numbers and addresses more thoroughly or implement fuzzy matching.
- **Partial Parsing of Address**: Source 1 lumps address into a single field. I left it largely unparsed (raw text) due to limited time.
- **Limited Testing**: I added basic dbt tests for `not_null` and `unique` constraints. In a real production scenario, I’d test more thoroughly for accepted values, relationships, etc.
- **Single “Union” Strategy**: I performed a full-refresh union for monthly files. With more time, I’d likely implement incremental loading or an SCD approach.

### 2.2 What I Would Do With More Time

1. **Enhanced QA & Observability**  
   - Integrate Great Expectations or more dbt tests to ensure phone formats, email formats, address parsing, and valid lead statuses.
2. **Address Normalization**  
   - Use a library or geocoding service to parse full addresses (street, city, state, zip) for robust deduplication.
3. **Incremental Loads**  
   - Implement an incremental logic so I don’t rebuild all data each time. I’d keep track of new/updated records only.
4. **Schema Drift Handling**  
   - Create a more dynamic pipeline that can handle monthly file schema changes automatically, logging or quarantining mismatched columns.
5. **Surrogate Keys & SCD**  
   - If lead statuses or addresses change, I might store historical snapshots (Type 2 Slowly Changing Dimensions).
6. **Performance Optimizations**  
   - Partitioning or clustering large tables, ensuring join keys are Ill indexed for data warehouses with large volumes.

---

## 3. Short Write-up for Long-Term ETL Strategy

- **Orchestration**: Use Airflow or dbt Cloud scheduling to reliably ingest monthly files, store them in a data lake/warehouse, and run transformations automatically.
- **Metadata & Observability**: Add data quality checks (row counts, duplicates, null rates) and alerting when anomalies appear.
- **Reverse ETL**: Push curated leads back into Salesforce or other CRMs for sales teams.
- **New Source Onboarding**: Create templates for new monthly files so I can quickly spin up staging models without rewriting large chunks of code.

---

## 4. How I Explored the Data

1. **Schema Review**: I looked at each CSV/Excel file to identify the key columns (e.g., phone, address, lead name).
2. **Sampling**: I checked a few rows per file to see how addresses and phone numbers Ire formatted.
3. **Deduplication Logic**: Identified `phone` as the best unique identifier, with `address` as a secondary fallback.
4. **Comparisons**: Validated that some leads from Salesforce also appear in monthly files (based on phone or email).

---

## 5. Testing, QA, and Data Validation

- **dbt Tests**: 
  - `unique` checks for columns like `lead_id` (Salesforce) or the final `lead_key` in `dim_leads`.
  - `not_null` checks on critical columns such as phone and lead_id where applicable.
- **Manual Spot Checks**: 
  - Verified that if a lead’s phone number shows up in multiple sources, the final “union + dedupe” logic only outputs one row.
- **Data Validation**:
  - Confirmed row counts make sense (final table ≤ total input rows, minus duplicates).
  - Confirmed status values align with known categories (“Working,” “Assigned,” “Unqualified,” etc.).

---

## 6. Anything Else Worth Mentioning

- **Project Organization**:
  - I used a typical dbt layered approach (staging → intermediate → marts) to keep transformations modular and maintainable.
- **Productionizing**:
  - In a real environment, I’d incorporate version control, CI/CD checks (so tests run on pull requests), and schedule daily/monthly runs.
- **Future Integrations**:
  - Potential to enrich leads from external APIs (e.g., address standardization, geocoding, or public daycare licensing registries).

---

## 7. Repository Contents

1. **`dbt_project.yml`**  
   Configures how dbt interprets folders and runs models.
2. **`models/staging/*`**  
   Minimal transformations for each raw file (Salesforce, Source 1, Source 2, Source 3).
3. **`models/intermediate/*`**  
   Combines sources, deduplicates leads, applies data cleaning.
4. **`models/marts/*`**  
   Final curated dimension/fact tables, especially `dim_leads`.
5. **`README.md`**  
   This document, describing the approach, testing strategy, trade-offs, and future enhancements.

---

## 8. Conclusion

This exercise shows how to quickly stand up a dbt-based pipeline that unifies multiple lead sources. While simplified due to time constraints, it demonstrates key **Analytics Engineering** principles:

- **Layered** data transformation
- **Deduplication** strategy
- **Basic testing & QA** approach
- **Scalability** for adding new monthly files over time

**Thank you for reviewing my output for this project!** If you have questions or want to see further expansions, feel free to reach out.
