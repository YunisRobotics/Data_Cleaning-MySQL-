select *
from layoffs;

-- Data cleaning stages
-- 1.Remove Duplicates
-- 2.Standardize the data
-- 3.Null values or blank values can be deleted
-- 4.Remove any columns

UPDATE layoffs
SET date = STR_TO_DATE(date,'%m/%d/%Y');

alter table layoffs
modify column `date` date; 


with duplicate_table as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, funds_raised_millions) as row_num 
from layoffs
)
select *
from duplicate_table
where row_num>1;

CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging;

insert into layoffs_staging
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, funds_raised_millions) as row_num 
from layoffs;

select *
from layoffs_staging;


select *
from layoffs_staging
where funds_raised_millions is null;

delete
from layoffs_staging
where percentage_laid_off is null and total_laid_off is null;

delete
from layoffs_staging
where industry="";


select industry
from layoffs_staging
group by industry
order by industry;

select *
from layoffs_staging
where company="Bally's Interactive";

update layoffs_staging
set industry="Crypto"
where industry like "Crypto%"

