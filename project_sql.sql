-- Data Cleaning 

SELECT * 
FROM layoffs;

CREATE TABLE layoffs_staging ##always create a neat seperate table from the raw data to avoid any errors (good practice)
LIKE layoffs;

SELECT *   
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

with duplicate_cte as ## making a CTE so that I can store the duplicate values and omit them.
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT*
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `industry` text DEFAULT NULL,
  `total_laid_off` int(11) DEFAULT NULL,
  `percentage_laid_off` text DEFAULT NULL,
  `date` text DEFAULT NULL,
  `stage` text DEFAULT NULL,
  `country` text DEFAULT NULL,
  `funds_raised_millions` int(11) DEFAULT NULL,
   `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,
percentage_laid_off,'date',stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num>1;

DELETE ## same follows for deleting , a new table 'layoffs_staging2' was made to ensure the raw data is preserved at all times for reference at any given moment.
FROM layoffs_staging2
WHERE row_num>1;

select *
from layoffs_staging2;

-- DATA Cleaning upto here
######################################################################
-- Standardizing data

select company,trim(company)
from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

select distinct(industry)
from layoffs_staging2s
order by 1;

select *
from layoffs_staging2
WHERE industry like 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

select distinct(industry)
from layoffs_staging2
order by 1;

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 ## TRIM(TRAILING '.' FROM country) - This is the way to properly do it.
SET country = 'United States'
WHERE country LIKE '%.';

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y') ##CONVERT DATE FROM TEXT TO TIME SERIES
;

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2 #CHANGE THE DATA TYPE OF THE DATE COLUMN TO DATE
MODIFY COLUMN `date` DATE;

-- Standardizing Data ends here
################################################################################
-- OMITTING THE NULL VALUES

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ' ';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry is NULL OR t1.industry = ' ')
AND t2.industry is NOT NULL;

-- UPDATE CAN BE USED TO CHANGE VALUES (JOIN NEEDS A ON PARAMETER TO UNDERSTAND WHICH COLUMNS TO JOIN FROM THE TABLES) ## IMPORTANT REVISION

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;

--
-- DELETING NULL VALUES ENDS HERE
################################################################################################
-- DROPPING COLUMNS
 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
-- DROPPING COLUMNS ENDS HERE
################################################################################################

SELECT * 
FROM layoffs_staging2;