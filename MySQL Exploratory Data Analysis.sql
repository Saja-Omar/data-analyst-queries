select * from layoffs_staging_new ; 

select max(total_laid_off  ),max(percentage_laid_off)
from layoffs_staging_new ;

select * from layoffs_staging_new 
where percentage_laid_off=1
order by total_laid_off desc 
;

select * from layoffs_staging_new 
where percentage_laid_off=1
order by funds_raised_millions desc 
;

select company , sum(total_laid_off)
from layoffs_staging_new group by company
order by 2 desc ; 

select min(`date`),max(`date`) from layoffs_staging_new;

select industry , sum(total_laid_off)
from layoffs_staging_new group by industry
order by 2 desc ; 

select country , sum(total_laid_off)
from layoffs_staging_new group by country
order by 2 desc ; 

select year(`date`) , sum(total_laid_off)
from layoffs_staging_new group by  year(`date`)
order by 1 desc ; 

select year(`date`) , sum(total_laid_off)
from layoffs_staging_new group by  year(`date`)
order by 2 desc ; 

select stage, sum(total_laid_off)
from layoffs_staging_new group by  stage
order by 1 desc ; 

select * from layoffs_staging_new ; 

select date_format(`date`,'%Y/%m') as month_year,sum(total_laid_off)
from layoffs_staging_new
group by  date_format(`date`,'%Y/%m')
having month_year is not null
order by 1 ;

WITH DATE_CTE AS (
select date_format(`date`,'%Y/%m') as month_year,sum(total_laid_off) as total
from layoffs_staging_new
group by  date_format(`date`,'%Y/%m')
having month_year is not null
order by 1 

)
select month_year,total, sum(total) over(order by month_year)from DATE_CTE ; 




-- anothder option 
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging_new
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging_new
where SUBSTRING(date,1,7) is not null
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates,total_laid_off, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;



select company ,year(`date`), sum(total_laid_off)
from layoffs_staging_new group by company , year(`date`)
order by 3 ; 

WITH company_year AS (
    SELECT 
        company, 
        YEAR(`date`) AS years,
        SUM(total_laid_off) AS total
    FROM 
        layoffs_staging_new 
    WHERE 
        YEAR(`date`) IS NOT NULL
    GROUP BY 
        company, 
        YEAR(`date`)
),
company_year_rank AS (
 SELECT company, 
years ,
total , 
DENSE_RANK() over(partition by years order by total desc)AS ranking 
    FROM 
        company_year

)SELECT * from company_year_rank
where ranking <=5;


