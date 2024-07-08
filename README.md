# SQL-Data-Cleaning
### Project Workflow and Steps:

- **Initial Data Loading:**
  - Load all data from the `LAYOFFS` table.
  - Create a staging table `LAYOFFS_STAGING` that is a copy of the `LAYOFFS` table.
  - Insert the raw data into the `LAYOFFS_STAGING` table.

- **Duplicate Detection and Removal:**
  - Check for duplicate records in the `LAYOFFS_STAGING` table using a Common Table Expression (CTE) with `ROW_NUMBER()`.
  - Create a new table `layoffs_staging2` to store the data with an additional `row_num` column for identifying duplicates.
  - Insert data into `layoffs_staging2` with `ROW_NUMBER()` to identify duplicate rows.
  - Delete duplicate rows from `layoffs_staging2` based on the `row_num` column.

- **Data Standardization:**
  - **Company Column:**
    - Trim whitespace from the `COMPANY` column.
  - **Industry Column:**
    - Standardize variations of the 'Crypto' industry to a single value.
  - **Location Column:**
    - Review and ensure consistency in the `LOCATION` column.
  - **Country Column:**
    - Trim whitespace from the `COUNTRY` column and review consistency.
  - **Date Column:**
    - Convert the `DATE` column from text to a date format using `str_to_date`.
    - Modify the `DATE` column to be of type DATE.

- **Handling NULL and Blank Values:**
  - Identify rows with `NULL` values in `total_laid_off` and `percentage_laid_off`.
  - Identify rows where `INDUSTRY` is `NULL` or blank.
  - Join the table with itself to fill in missing `INDUSTRY` values based on matching `company` and `location`.
  - Update rows to set `INDUSTRY` to `NULL` where it is blank.
  - Fill in `INDUSTRY` for rows where it is missing using values from matching `company` and `location`.

- **Data Analysis and Cleanup:**
  - Analyze the distribution of different industries by counting the number of records for each industry.
  - Delete rows where both `total_laid_off` and `percentage_laid_off` are `NULL`.
  - Final review of rows with missing `INDUSTRY` values.
  - Order the table by `company`.

- **Final Adjustments:**
  - Drop the `ROW_NUM` column from `layoffs_staging2`.
 
- **SQL Concepts/Commands used:**
  - SELECT
  - CREATE TABLE
  - INSERT INTO ... SELECT
  - WITH ... AS (CTE)
  - ROW_NUMBER() OVER (PARTITION BY ...)
  - DELETE
  - TRIM()
  - DISTINCT
  - LIKE
  - UPDATE
  - STR_TO_DATE()
  - ALTER TABLE
  - MODIFY COLUMN
  - JOIN
  - COUNT()
  - GROUP BY
  - ORDER BY

The end result of this project is data which is clean, standardized, and ready for further analysis or reporting.
