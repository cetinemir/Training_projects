# Alex Youtube series video 19 <Data cleaning>
-- Data cleaning
-- data source https://www.kaggle.com/datasets/swaptr/layoffs-2022
  
## data'yı insert ederken date ayarını kontrol etmekte fayda var.

select *
from layoffs;

## Procedure of data cleaining
-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove any columns


## 4. madde için özellikle raw data'dan silme işlemi veya ekleme yaparken çok dikkatli olmalıyız. Datayı değiştirmeden önce bir yere recover edebileceğimiz kaynak açmak önemli. !!!!!

create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;



-- 1. removing duplicates

## / Step 1 / Aşağıda duplicateleri bulmak için row_num kolonunu ekliyoruz. Çoğu row is unique çıkacak yani 1. Eğer 1'den fazla iseler bunlar duplicate demektirler.
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

## / Step 2 / Duplicate rowları filterlamak için aşağıdaki kodu yazıyoruz. 2 veya üzerin olanlar çıkacaktır.
with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

## Aşağıdaki örnekte veriler oldukça birbirine benzesede duplicate değiller. Alex bu videoda bu örneğe baktığında farkediyor ki partition by kısmına tüm columnları eklememiz gerekiyor. 
## Yani duplicate örneklerini fiziksel olarak kontrol etmek oldukça önemli. 

select *
from layoffs_staging
where company ='oda';


## CTE'deyken data silinmesine izin vermiyor bu yüzden farklı yol izlemeliyiz.

with duplicate_cte as 
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1;

##2. Bir staging table'ı yaratacağız ve yarattığımız table'dan 2.leri silip gerçek table olarak save edeceğiz. 
## sol taraftan  layoffs_staging > copy to clipboard > create statement


## / Step 3 / Aşağıdaki kodun orjinaline sonuna kendi eklediğimiz num_row column'unu ekliyoruz manuel olarak.

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
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


## / Step 4 / Üst kodu yazdıüımızda table'ın işi boştu bu yüzden table'ımız doldurmamız gerekiyor. 

select *
from layoffs_staging2;

INSERT INTO layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging;

## / Step 5 /Yeni yarattığımız table'da duplicatleları filtreliyoruz. Öncellikle identify edip manuel olarak her şeyin doğru olduğunu kontrol ediyoruz. 

select *
from layoffs_staging2
where row_num > 1;

## / Step 6 / Her şey okey gözüktüğünde filtrelenen rowları siliyoruz. 

delete 
from layoffs_staging2
where row_num > 1;

#Duplicate işini bitirdiğimize göre artık row_num kolonunu silmemiz gerekiyor. Gereksiz yere processes time query time'ı arttırmak istemeyiz.

-- 2. Standardizing Data
## Finding issues in data and fixing it.
## Columnlara tek tek bakıp gözüken sorun var mı diye bakıyoruz. 

-- / Step 1 / Company kolonunda gördüğümüz sorun Boşlukları silme

## Aşağıda boşluk ile başlayan satırları düzeltiyoruz. Artık direkt karakter ile başlayacak rowlar boşluk yerine. 

select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

-- / Step 2 / Industry kolonundaki sorunlar. Blank ve adlandırma konusunda aynı şeylerin farklı isimlerle girilmesi. 

## aşağıdaki kod ile kolay bir şekilde göz atabiliriz sorunlara
select distinct(industry)
from layoffs_staging2
order by 1;

## Fark ettiğimiz farklı crypto girişlerini kontrol ediyoruz.
select *
from layoffs_staging2
where industry LIKE 'Crypto%';

## Fark ettiğimiz 3 crypto girişini aşağıdaki kod ile teke indiriyoruz.

Update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

## kontrol etmek için. ve görüyoruz ki teke inmiş.

select distinct(industry)
from layoffs_staging2
order by 1;

## / Step 3 / Location üzerindeki sorunlara bakmak için. Bir sorun gözükmedi

select distinct(location)
from layoffs_staging2
order by 1;

## / Step 4  / Country kolonunda usa ve usa. olarak 2 row var bunları birleştirmemiz gerekiyor.

##Sorunlara göz atmak için 

select distinct(country)
from layoffs_staging2
order by 1;

## Bulunan Usa'ları düzeltiyoruz. 
-- Trailing(izleyen)  

select distinct country, trim(trailing '.' from country)
from layoffs_staging2;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';

##/ Step 5 / Date kolonu. İstediğimiz date formatını ayarladık. Ve data tipini text'ten date'e çevirdik.

##Date'in data type text olarak gözüküyor bu iyi değil. 

--   STR_to_date 

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

## kontrol 

select `date`
from layoffs_staging2;

## Alter table raw data'da asla data tipini değiştirme.

Alter table layoffs_staging2
modify column `date` Date;


-- 3. Null values or Blank values

-- / Step 1 / total_laid_off kolonu. Genel tabloda en çok null gözükenlerden biri olduğu için buradan başladık.

select * 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

## Total_laid_off ve percentage_laid_off ikisi birden null olursa muhtemelen hiç bir işimize yaramayacaklardır. Bu data'dan dataya değişebilir.
## Eğer işimize yaramyacaklarını düşünüyorsak bunları silebiliriz ancak oldukça kendimizden emin olmalıyız.

-- / step 2 / 

## kontrol
select *
from layoffs_staging2
where industry is null
or industry = '';


## Airbnb'nin diğer rowlarına baktığımızda travel olduğunu görüyoruz. Yani bu bilgiyi boşluk olan yerlerde de kullanabiliriz. 

select *
from layoffs_staging2
where company = 'Airbnb';


## Aynı isimde firmalalar başka lokasyonlarda olabilir bu yüzden lokasyonu da check etmek için kullanıyoruz.

## Eğer t1industry kolonu blank ise t2industury kolonundaki blank olmayan rowlar t1industry'ya kopyalanacak.
select t1.industry, t2.industry
from layoffs_staging2 t1 
join layoffs_staging2 t2
    on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

## yukarıda önce gördüğümüz durumu değiştirmek için kullanılan kod. 

update layoffs_staging2 t1 
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

## yukarıdaki kod istediğimiz sonucu vermedi şimdilik. bunun nedeni null yerine blank olarak geçtikleri için olabilir. bu yüzden null'u blanklere çeviriyoruz.

update layoffs_staging2
set industry = null 
where industry = '';

## artık blanklere ihtiyacımız olmadığı için önceki koddaki blank kısmını siliyoruz.

update layoffs_staging2 t1 
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

## kontrol üzerine artık travel iki rowa da yazılmış durumda.

select *
from layoffs_staging2
where company = 'Airbnb';

## overall kontrol üzerine ball's de hala null görüyoruz. 

select *
from layoffs_staging2
where industry is null
or industry = '';

## bally'i özel kontrol ediyoruz. Sadece tek rowu olduğu için ve hangi industry olduğunu bilmediğimiz için null'u ekleyemedik. 

select *
from layoffs_staging2
where company like 'bally%';


## total laid off ve percentage laid off 2si birden null olan rowlara dönersek.

select *
from layoffs_staging2
where total_laid_off is null
and  percentage_laid_off is null;

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- / step 3 / Gereksiz colum silme 

Alter table layoffs_staging2
drop column row_num;

##kontrol
select *
from layoffs_staging2;


## recap

##removed duplicates
##standardize the data
##checked null and blank values
##removed coloumns

