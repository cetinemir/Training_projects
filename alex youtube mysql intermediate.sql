# // Alex data analyst bootcamp youtube series video 9 - Joins // 

use parks_and_recreation;

select * from employee_demographics;

select * 
from employee_salary;

-- inner joins 
# inner join is only going to bring over the rows that have values in both columns that we are tying on. For example we are missing 2nd employee in the table. 
select * from employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON employee_demographics.employee_id = employee_salary.employee_id;

# yukarıda as dem ve dem as sal dediğimiz için aşağıdaki gibi de yazabiliriz.

select * from employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

# aşağıdaki kod çalışmayacaktır çünkü sistem hangi tabledaki employee_id yi alacağını bilmeyeceği için.  dem.employee_id veya sal.employee_id yazılması gerekir doğrusu için.
select employee_id, age , occupation
from employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

#doğrusu aşağıda 
select dem.employee_id, age , occupation
from employee_demographics AS dem
INNER JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

--  outer joins
# left join yazdığımızda soldaki olan table'ın hepsini alacak ve sağdaki den aynı olan rowları karşımıza verecek
#right yazdığımız da ise yine aynı şekilde sağdaki table'ın hepsini alacak. 


# aşağıdaki kodda 2. row gözükmeyecek çünkü dem table'ın da yok.
select * 
from employee_demographics AS dem
Left JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

# Bu sefer right yazdığımız için sağdaki sonuçları verecek solda matchlenmeyenlere null koyacak. 
select * 
from employee_demographics AS dem
right JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id;

-- Self join 
#Table'ı kendisine bağlamak için kullanılır.

# +1 eklediğimiz için 1. ve 2. table'lar farklı şekilde matchlenmiş olacaklar.
select *  
from employee_salary As emp1
JOIN employee_salary As emp2 
on emp1.employee_id +1  = emp2.employee_id
; 

# daha toparlı bir görünüm için aşağıdaki kodu kullanabiliriz. Gizli santa oyunu referans alınmıştır. 1. > 2. - 2. > 3. 'ye hediye alacak gibi.
select emp1.employee_id AS emp_santa, 
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_name, 
emp2.first_name AS first_name_emp,
emp2.last_name AS last_name_emp
From employee_salary As emp1
JOIN employee_salary As emp2 
on emp1.employee_id +1  = emp2.employee_id
; 

-- Multi table birleştirme

# employee_demographics table'ın employee_departments ile bağlantısı olmamasına rağmen, employee_salary table'ı üzerinden birbirlerine bağlayabiliyoruz.
select * 
from employee_demographics AS dem
inner JOIN employee_salary AS sal
ON dem.employee_id = sal.employee_id
inner join parks_departments AS pd 
on sal.dept_id = pd.department_id
;

# // Alex data analyst bootcamp youtube series video 10 - Unions // 

-- Unions

select first_name, last_name, 'Old man' As Label
from employee_demographics
where age > 40 and gender = 'Male'
union 
select first_name, last_name,'Old lady' As Label
from employee_demographics
where age > 40 and gender = 'Female'
union
select first_name, last_name, 'Highly Paid employee' As Label
from employee_salary
where salary > 70000 
order by first_name, last_name;

# // Alex data analyst bootcamp youtube series video 11 - string functions // 

-- string functions
# Lenght function özellikle telefon numarası bilgilerinde işe yarıyor

Select first_name, length(first_name)
from employee_demographics
order by 2;

Select length('Skyfall');


-- Upper and lower fuctions. Yazıların büyük capital veya küçük capital ile yazılmalarını değiştirir.

Select first_name, Upper(first_name)
from employee_demographics;

Select first_name, lower(first_name)
from employee_demographics;

-- Trim kelimelerin sol veya sağ tarafındaki boşlukları kesmeye yarar.

select trim('                    sky           ');
select ('                    sky           ');
select ltrim('               sky           ');
select rtrim('               sky           ');

-- Substring


#left and right string kullanımları.
#first name'deki ilk 4 karakteri bize veriyor.
select first_name, left(first_name, 4)
from employee_demographics;

#substring fonkisyon kullanımı.Örnekte verilen 3 ve 2 rakamı, Kelimenin 3. harfinden başlanarak kaç harfi bize vereceği komutlanır.
select first_name,
left(first_name, 4),
right(first_name,4),
substring(first_name,3,2)
from employee_demographics;

select first_name, birth_date,
substring(birth_date,6,2) as birth_month
from employee_demographics 
order by birth_month;

-- Replace fonksiyonu

Select first_name, replace(first_name, 'A','z')
from employee_demographics;

-- Locate fonksiyonu

Select Locate('x','Alexander');

#Örnekte içinde an olan isimleri bize veriyor.
Select first_name, locate('An', first_name)
from employee_demographics;

-- Concatenation(birbirine bağlama, sıralanma, zincir, birleştirme, mevcut iki diziden ikincisini birincinin sonuna ekleyerek tek bir sembol dizisi oluşturan fonksiyon.)

## İki columnu birbirine bağlayıp tek column oluşturmak için sıklıkla kullanılır.
Select first_name, last_name,
concat(first_name,' ',last_name) as full_name 
from employee_demographics;

# // Alex data analyst bootcamp youtube series video 12 - Case statements // 

## Case statement allows u to add logic in your select statement. Sort of like if-else statements.
select first_name, 
last_name,
age,
case
    when age <= 30 then 'young'
    when age between 31 and 50 then 'old'
    when age >= 50 then "On Death's Door"
    end as Age_bracket
from employee_demographics;

## Pay increase örneği
## Pay increase and Bonus
## < 50000 = 5%
## > 50000 = 7%
## Finance = 10% bonus


select first_name, last_name, salary,
case
     when salary < 50000 then salary * 1.05
     when salary > 50000 then salary * 1.07
     end as new_salary, 
case when dept_id = 6 then salary * 1.10 
end as bonus
from employee_salary;


# // Alex data analyst bootcamp youtube series video 13 - Subqueris // 

##Subqueries is a query in another query
## Ya union ile tableları birleştirerek yapabiliriz ya da aşağıdaki örnekteki gibi 3. bir table'dan bilgi alabiliriz.
select *
from employee_demographics
where employee_id IN (select employee_id
					     from employee_salary
						   where dept_id = 1)
;

select first_name, salary, 
(select avg(salary)
from employee_salary)
from employee_salary
;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender;


## backtick kullanımı şart öbür türlü çalışmıyor komut. nedenini bilmiyorum. ( alt + virgül tuşu)
select gender, avg(`max(age)`)
from
(select gender, avg(age), max(age), min(age), count(age)
from employee_demographics 
group by gender) as agg_table
group by gender;

## backtick kullanmamak için aşağıdaki yolu kullanabiliriz
select gender, avg(max_age)
from
(select gender, 
avg(age) as avg_age,
max(age) as max_age,
min(age) as min_age,
count(age)
from employee_demographics 
group by gender) as agg_table
group by gender;


# // Alex data analyst bootcamp youtube series video 14 - Window functions // 


-- Over function
## Group by'daki gibi sadece tek row yerine tüm rowları veriyor ve avg salary'i herkesin ortak avg'ını alıyor male-female yerine ayırmaktansa.

select gender, avg(salary) over()
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

## group by kullanımı

select gender, avg(salary) 
from employee_demographics AS dem
JOIN employee_salary As sal
on dem.employee_id = sal.employee_id
group by gender;

-- Over(Partitoion by)

## Bunun kullanımı tüm datanın avg'ını almaktan ziyade male ve female'lerin ayrı avglarını gösteriyor. 

select gender, avg(salary) over(PARTITION BY gender) 
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

## Kadınların ve erkeklerin toplam ne kadar salary aldığını gösteriyor.
select gender, sum(salary) over(PARTITION BY gender) 
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

-- Rolling total

## Aşağıdaki kodda görülecek üzere 1. rowu 2. rowa ekleyerek total salary'yi görebiliriz. yani kadınlar için 4. rowa geldiğimizde sum(salary) gözükecektir.

select dem.first_name, dem.last_name, gender, salary, sum(salary) over(PARTITION BY gender order by dem.employee_id)  As Rolling_total
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;	

-- Row number

## Diğer table'daki employee_id @2 olan ron'u görüntüleyemiyoruz hala. Row_number kolonundaki sonuçlar unique olabilir bu şekilde.

select dem.employee_id, dem.first_name, dem.last_name, gender, salary,
row_number() over()
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

## Aşağıdaki table'da maaşlarının yüksekliğine göre sıralamamız mümkün

select dem.employee_id, dem.first_name, dem.last_name, gender, salary,
row_number() over(PARTITION BY gender order by salary desc),
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

-- Rank 

## 	Rank, partition by'ın unqiue rowuna ters şekilde. Eğer eşit sonuçlar çıkarsa örneğin 5.5. olarak 2 rowu sıralayacaktır ve takiben 7. olarak devam edecektir.

select dem.employee_id, dem.first_name, dem.last_name, gender, salary,
row_number() over(PARTITION BY gender order by salary desc) as row_num,
rank() over(PARTITION BY gender order by salary desc) as rank_num
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;

-- Dense rank

## Burada ise yukarıdakinin aksine 5.,5.'den sonra 7. yerine 6. olarak devam edecektir.

select dem.employee_id, dem.first_name, dem.last_name, gender, salary,
row_number() over(PARTITION BY gender order by salary desc) as row_num,
rank() over(PARTITION BY gender order by salary desc) as rank_num,
dense_rank() over(PARTITION BY gender order by salary desc) as dense_rank_num
from employee_demographics AS dem
join employee_salary sal
on dem.employee_id = sal.employee_id;


