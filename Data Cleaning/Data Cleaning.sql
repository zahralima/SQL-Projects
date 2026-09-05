SHOW GLOBAL VARIABLES LIKE 'local_infile';
USE world_layoffs;
CREATE TABLE layoffs (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off VARCHAR(50),
    percentage_laid_off VARCHAR(50),
    `date` VARCHAR(50),
    stage VARCHAR(100),
    country VARCHAR(255),
    funds_raised_millions VARCHAR(50)
);
LOAD DATA LOCAL INFILE '/Users/zahralima/Downloads/layoffs.1.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*)
FROM layoffs;


 -- Data cleaning
 -- 1. Remove Duplicates
 -- 2. Standardize the data
 -- 3. Null values or balnk values
 -- 4. Remove any columns 
 
 
 -- First create a duplicated table to work on
 
 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
 SELECT *
 FROM layoffs_staging;
 
 INSERT layoffs_staging
 SELECT *
 FROM layoffs;
 
 SELECT *
 FROM layoffs_staging;
 
 
 -- 1. Clearning data
 -- Removing duplicates
 
 -- No column with unique data
 -- Identify duplicates first

 SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_million) AS row_num
 FROM layoffs_staging;
 
 SELECT *
 FROM  layoffs_staging;

SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
 FROM layoffs_staging;
 
 WITH duplicate_cte AS
 (SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_cte
 WHERE row_num > 1;
 
 
 SELECT * 
 FROM layoffs_staging 
 WHERE company = 'Elemy';
 
WITH duplicate_cte AS
(
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, industry, total_laid_off,
        percentage_laid_off, `date`, stage, country,
        funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE company = 'Elemy';



 WITH duplicate_cte AS
 (SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
 FROM layoffs_staging
 )
 SELECT *
 FROM duplicate_cte
 WHERE row_num > 1;
 
 SELECT *
 FROM layoffs_staging
 WHERE company = 'Casper';
 
 
 CREATE TABLE `layoffs_staging2` (
  `company` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `total_laid_off` varchar(50) DEFAULT NULL,
  `percentage_laid_off` varchar(50) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `stage` varchar(100) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `funds_raised_millions` varchar(50) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) As row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizeing data
SELECT * 
FROM layoffs_staging2;

SELECT company, (TRIM(company)) 
FROM layoffs_staging2;

UPDATE layoffs_staging
SET company = TRIM(company);

SELECT * 
FROM layoffs_staging2;

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT industry
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT industry
FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country like 'United State%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT `date`
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT `date`
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

-- populate the data

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
     AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
     AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;



UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';



UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
     ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;


DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;
