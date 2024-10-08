# Alex Youtube series video 20 <Exploratory Data >

## just looking into the data to find something to makes sense. 

select * 
from layoffs_staging2;

## 1 = %100 means entire company is laid off.
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off = 1;

select * 
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select * 
from layoffs_staging2;


## biggest tech companies have the most laid off. 
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

## 2020 was min, 2023 was max. 
select min(`date`), max(`date`) 
from layoffs_staging2;

##biggest hit is consumer and retail. 
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;


## usa by far have the biggest laid off.
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Year 

## 2022 have the most laid off people howver 2023 have only data for q1 and yet it's almost reached 2022 numbers.

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


## post ipo is the stage which got most laid off. Includes tech giants like amazon google and etc.
 
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;




select substring(`date`, 1, 7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc;

## 2022 ağustos'undan beri lay offların nasıl arttığını görebiliriz. 
with rolling_total as 
(
select substring(`date`, 1, 7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off, sum(total_off) over (order by `month`) as rolling_total
from rolling_total;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc;


##İlk cte querymizde yılları gördük 2. cte'de yıllara göre sıraladık. 
with company_year (company, years, total_laid_off, industry) as 
(
select company, year(`date`), sum(total_laid_off), industry
from layoffs_staging2
group by company, year(`date`), industry
order by 3 desc
), 
company_year_rank as 
(select *, dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
) 
select *
from company_year_rank
where ranking <= 5
;



























