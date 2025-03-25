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