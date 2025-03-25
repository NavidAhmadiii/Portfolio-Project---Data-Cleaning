-- Data Cleaning

select *
from layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any columns


-- 1. Remove Duplicates

create table layoffs_staging
    like layoffs;

select *
from layoffs_staging;

insert layoffs_staging
select *
from layoffs;


select *,
       row_number() over (
           partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;


with duplicate_cte as
         (select *,
                 row_number() over (
                     partition by company, location ,industry,
                         total_laid_off, percentage_laid_off,
                         `date`, stage ,country,
                         funds_raised_millions) as row_num
          from layoffs_staging)

select *
from duplicate_cte
where row_num > 1
;

select *
from layoffs_staging
where company = 'Casper';


with duplicate_cte as
         (select *,
                 row_number() over (
                     partition by company, location ,industry,
                         total_laid_off, percentage_laid_off,
                         `date`, stage ,country,
                         funds_raised_millions) as row_num
          from layoffs_staging)

DELETE
from duplicate_cte
where row_num > 1
;


create table layoffs_staging2
(
    company               text null,
    location              text null,
    industry              text null,
    total_laid_off        text null,
    percentage_laid_off   text null,
    date                  text null,
    stage                 text null,
    country               text null,
    funds_raised_millions text null,
    row_num               int
);

select *
from layoffs_staging2;


insert into layoffs_staging2
select *,
       row_number() over (
           partition by company, location ,industry,
               total_laid_off, percentage_laid_off,
               `date`, stage ,country,
               funds_raised_millions) as row_num
from layoffs_staging;


DELETE
from layoffs_staging2
where row_num > 1;


select *
from layoffs_staging2;


-- 2. Standardize the Data

select company, trim(company)
from layoffs_staging2;


update layoffs_staging2
set company = trim(company);


select *
from layoffs_staging2
where industry like 'Crypto%'
;


update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct industry
from layoffs_staging2
;


select distinct country
from layoffs_staging2
order by 1
;


select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;

select `date`,
       STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs_staging2
;


update layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
where `date` != 'Null'
;

select `date`
from layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = NULL
WHERE `date` = 'NULL'
;

alter table layoffs_staging2
    modify column `date` date
;


-- 3. Null Values or blank values

UPDATE layoffs_staging2
SET company               = CASE WHEN LOWER(TRIM(company)) = 'null' THEN NULL ELSE company END,
    location              = CASE WHEN LOWER(TRIM(location)) = 'null' THEN NULL ELSE location END,
    industry              = CASE WHEN LOWER(TRIM(industry)) = 'null' THEN NULL ELSE industry END,
    total_laid_off        = CASE WHEN LOWER(TRIM(total_laid_off)) = 'null' THEN NULL ELSE total_laid_off END,
    percentage_laid_off   = CASE WHEN LOWER(TRIM(percentage_laid_off)) = 'null' THEN NULL ELSE percentage_laid_off END,
    stage                 = CASE WHEN LOWER(TRIM(stage)) = 'null' THEN NULL ELSE stage END,
    country               = CASE WHEN LOWER(TRIM(country)) = 'null' THEN NULL ELSE country END,
    funds_raised_millions = CASE
                                WHEN LOWER(TRIM(funds_raised_millions)) = 'null' THEN NULL
                                ELSE funds_raised_millions END
;



select *
from layoffs_staging2
where total_laid_off is null
  and percentage_laid_off is null
;


select *
from layoffs_staging2
where industry is null
   or industry = ''
;


select table1.industry, table2.industry
from layoffs_staging2 as table1
join layoffs_staging2 as table2
    on table1.company = table2.company
where (table1.industry is null or table1.industry = '')
and table2.industry is not null
;

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 as table1
join layoffs_staging2 as table2
    on table1.company = table2.company
set table1.industry = table2.industry
where (table1.industry is null or table1.industry = '')
and table2.industry is not null
;


-- 4. Remove Any columns

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null
;

select *
from layoffs_staging2;


alter table layoffs_staging2
drop column row_num
;