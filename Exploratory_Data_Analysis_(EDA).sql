# Exploratory Data Analysis (EDA)

-- Here we are just going to explore the data and find trends or patterns or anything interesting like outliers

-- normally when you start the EDA process you have some idea of what you're looking for

-- with this info we are just going to look around and see what we find!


select *
from layoffs_staging2
;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;


select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc
;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;


select min(`date`), max(`date`)
from layoffs_staging2
;



select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
;



select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc
;



select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc
;


select substring(`date`, 1, 7) as `MONTH`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 asc
;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


with Company_Year (Company, Years, Total_Laid_Off) as
         (select company, year(`date`), sum(total_laid_off)
          from layoffs_staging2
          group by company, year(`date`)),
     Comapny_Year_Rank AS (select *, dense_rank() over (partition by Years order by Total_Laid_Off desc) as Ranking
                           from Company_Year
                           where Years is not null)

select *
from Comapny_Year_Rank
where Ranking <= 5

;




