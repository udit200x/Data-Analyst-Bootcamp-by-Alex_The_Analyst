-- EDA Project

SELECT *
FROM layoffs_staging2; 

SELECT *   ##ORDERING COMPANIES WITH A lay off percentage of 100 based on their funding
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

select company, sum(total_laid_off) #ORDERING COMPANIES BASED ON THE sum total of their total laid off employees
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc;

SELECT MIN(`date`),MAX(`date`)     ##selecting the highest date and the lowest date of the companies at which the most layoffs happened
FROM layoffs_staging2;

select industry, sum(total_laid_off)  #selecting the industry with the highest number of layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 desc;

SELECT `date`, SUM(total_laid_off) #selecting the exact date at which the highest number of employees got laid off
FROM layoffs_staging2	
GROUP  BY `date`
ORDER BY 2 DESC;


SELECT year(`date`), SUM(total_laid_off)
FROM layoffs_staging2	
GROUP  BY year(`date`)
ORDER BY 1 DESC;

WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off ## REVISION OF SUBSTRING WHICH IS AN  AGGREGATE FUNCTION 
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, total_laid_off,   ##SORTING THE COMPANIES FROM WHICH THE COMPANIES GOT LAID OFF BASED ON THE YEAR AND THE MONTH AND SUM OF TOTAL LAID OFF, ROLLING TOTAL KEEPS ON INCREASING MONTH BY MONTH, THINK IT LIKE THAT
SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;


Select company,YEAR(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY  3 desc;

WITH Company_Year (company,years,total_laid_off) as ##FIRST CTE WHERE I ARRANGE THE COMPANY DATA BASED ON THE YEAR WHICH HAD THE HIGHEST LAYOFFS
(
Select company,YEAR(`date`),sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY  3 desc
) , Company_Year_Rank as ## SECOND CTE WHICH CALLS OFF FROM THE FIRST CTE AND RANKS THE HIGHEST LAID OFF COMPANY IN EACH YEAR
(
SELECT *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
FROM Company_Year
WHERE years is not null
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <=5;

