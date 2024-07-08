SELECT *
FROM LAYOFFS;

-- Create a copy of the Data 
CREATE TABLE LAYOFFS_STAGING
LIKE LAYOFFS;

-- Inserting the raw data into the copy table 
INSERT INTO layoffs_staging
SELECT *
FROM LAYOFFS;

SELECT * 
FROM layoffs_staging;

-- Checking for Duplicates
WITH DUPLICATE_CTE AS (
SELECT *, 
ROW_NUMBER() OVER (partition by COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF, `DATE`, STAGE, COUNTRY, funds_raised_millions) AS ROW_NUM
FROM layoffs_staging
)
SELECT *
FROM DUPLICATE_CTE
WHERE ROW_NUM >1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER (partition by COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF,PERCENTAGE_LAID_OFF, `DATE`, STAGE, COUNTRY, funds_raised_millions) AS ROW_NUM
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE ROW_NUM > 1;

DELETE 
FROM LAYOFFS_STAGING2
WHERE ROW_NUM>1;

-- Standardizing the Data
-- -- 1. 'Company' Column 
SELECT COMPANY, TRIM(COMPANY) AS FORMATTED_TEXT
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET COMPANY = TRIM(COMPANY);

SELECT company, LENGTH(COMPANY)
FROM layoffs_staging2;

-- -- 'Industry Column'
SELECT DISTINCT INDUSTRY
FROM layoffs_staging2
ORDER BY INDUSTRY;

SELECT *
FROM layoffs_staging2
WHERE INDUSTRY LIKE 'CRYPTO%';

UPDATE layoffs_staging2
SET INDUSTRY = 'Crypto'
WHERE INDUSTRY LIKE '%CRYPTO%';

-- -- 3. 'Location Column' (No problems here)
SELECT *
FROM layoffs_staging2;

SELECT DISTINCT LOCATION
FROM layoffs_staging2
order by location;

-- -- 'Country Column'
SELECT distinct COUNTRY, TRIM(COUNTRY)
FROM layoffs_staging2
ORDER BY COUNTRY;  

SELECT *
FROM layoffs_staging2
WHERE COUNTRY LIKE 'UNITED STATES.';

SELECT distinct COUNTRY, TRIM(TRAILING '.' FROM COUNTRY)
FROM layoffs_staging2
ORDER BY COUNTRY;

UPDATE layoffs_staging2
SET COUNTRY = TRIM(TRAILING '.' FROM COUNTRY)
WHERE COUNTRY LIKE 'UNITED STATES%';

SELECT DISTINCT COUNTRY
FROM layoffs_staging2
ORDER BY COUNTRY;

-- -- 'Date Column'
SELECT `DATE`, str_to_date(DATE,'%m/%d/%Y') as CONVERTED_DATE
FROM layoffs_staging2; 

UPDATE layoffs_staging2
SET `DATE` = str_to_date(DATE, '%m/%d/%Y');

SELECT `DATE`
FROM layoffs_staging2;

-- Even though it has the date format, it is still of type text

ALTER TABLE layoffs_staging2
MODIFY COLUMN `DATE` DATE;

SELECT *
FROM layoffs_staging2;


-- NULL and Blank Values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL; 

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE INDUSTRY IS NULL OR INDUSTRY = '';

SELECT *
FROM layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2 
	ON T1.company = T2.company 
    AND T1.location = T2.location
WHERE T1.industry IS NULL OR T1.industry = ''
AND T2.industry IS NOT NULL;

SELECT T1.industry, T2.industry
FROM layoffs_staging2 AS T1
JOIN layoffs_staging2 AS T2 
	ON T1.company = T2.company 
    AND T1.location = T2.location
WHERE T1.industry IS NULL OR T1.industry = ''
AND T2.industry IS NOT NULL;


UPDATE layoffs_staging2
SET INDUSTRY = NULL
WHERE INDUSTRY = '';

UPDATE layoffs_staging2 AS T1
	JOIN layoffs_staging2 AS T2 
    ON T1.COMPANY = T2.COMPANY
SET T1.INDUSTRY = T2.INDUSTRY
WHERE T1.industry IS NULL 
AND T2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE COMPANY = 'AIRBNB';

SELECT INDUSTRY, COUNT(*) AS TOTAL_COUNT
FROM layoffs_staging2
GROUP BY industry
order by TOTAL_COUNT DESC;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR INDUSTRY = '';

SELECT *
FROM layoffs_staging2
ORDER BY company;





SELECT *
FROM layoffs_staging2
WHERE company = 'AIRBNB';

ALTER TABLE layoffs_staging2
DROP COLUMN ROW_NUM;

SELECT *
FROM layoffs_staging2;





