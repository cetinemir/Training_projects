# // Alex data analyst bootcamp youtube series video 4 - Select Statement // 
SELECT *
from employee_demographics;

SELECT first_name,
last_name, 
birth_date,
age,
(age + 10) * 10 
from employee_demographics;
# Comment böyle yazılıyor. 

Select distinct first_name, gender
From employee_demographics;

Select distinct gender
From employee_demographics;

# Unique bilgileri veriyor "distinct" mesela sadece male ve female. Eğer "first_name, gender" olarak alırsak, tüm unique isimleri alıp female male sonucu çıkar. 

# //  Alex data analyst bootcamp youtube series video 5 - Where clause  // 
# Where is used to help filter actualy columns. 

select * 
from employee_salary
Where salary >= 50000
;
select * 
from employee_salary
Where salary > 50000
;

select * 
from employee_salary
Where salary <= 50000
;

select * 
from employee_demographics
where gender = 'Female';

#!= not equals anlamına geliyor.
select * 
from employee_demographics
where gender != 'Female'
;

select * 
from employee_demographics
where birth_date > '1985-01-01'
;

# // And or Not Logical Operators.
# And kullanıldığında değerler kesinllikle doğru olmalı. 
select * 
from employee_demographics
where birth_date > '1985-01-01'
and gender = 'male'
;

# Or kullanıldığında Satırlardan birisi doğru olması gerekir.
select * 
from employee_demographics
where birth_date > '1985-01-01'
or gender = 'male'
;

select * 
from employee_demographics
where birth_date > '1985-01-01'
or not gender = 'male'
;

#PEMDAS devereye giriyor. İlk parantezin içi işleme alınıyor ve diğer işlemden ayıklanıyor.
select * 
from employee_demographics
where (first_name = 'leslie' and age = 44) or age > 55
;
# //  Like Statement. Normalde where clauselarda Jerry isminin aynı şekilde yazılması gerekir. Like statement'ı jer yazdığımda Jerry veya diğer Jer ile devam eden isimleri verir.
# % sembolü kelimenin önüne gelirse önceki karakterleri, sonuna gelirse sonundaki karakterleri verir.
select * 
from employee_demographics
where first_name Like  '%er%'
;

# içinde a bulunan tüm isimleri verir.
select * 
from employee_demographics
where first_name LIKE '%a%'
;

# A ile başlayan tüm isimleri verir..
select * 
from employee_demographics
where first_name LIKE 'a%'
;

# "__" kısmı a'dan sonra sadece 2 karakter gelebileceğini gösterir. sonuç: 1 row
select * 
from employee_demographics
where first_name LIKE 'a__'
;

# A'dan sonra 2 karakter gelip ondan sonra kullanılan sonuçları verir. sonuç : 3 row
select * 
from employee_demographics
where first_name LIKE 'a__%'
;

#1989 yılından sonra doğanların listesini verir. 
select * 
from employee_demographics
where birth_date LIKE '1989%'
;

# // Alex data analyst bootcamp youtube series video 6 - Group by + order // 

#12 kişilik listeden sadece 2 row sonuç çıkartır. "Female" ve "male".
Select gender 
From employee_demographics
Group by gender
;

# Select ve group by eşleşmeli. mesela aşağıdaki kod çalışmaz. Aggregate olmaları gerekiyor.
#Select first_name
#from employee_demographics
#group by gender;

#Aşağıdaki kodda aggregate olan sonuçlar gösterilir daha sonra AVG işlemi uygulanır.
select gender, AVG(AGE)
from employee_demographics
group by gender
;

# Kadınların ve Erkeklerin ortalama maaşını gösterir.
select gender, AVG(salary)
from employee_salary, employee_demographics
group by gender
;

#"salary" eklediğimiz için sonuçlarda 2 tane office manager çıktı. Çünkü 2 farklı salary unique olarak karşımıza çıkıyor. "salary" olmasaydı tek row çıkacaktı.
Select occupation, salary
from employee_salary
group by occupation, salary
;

# // Max ve Min kullanımı.
select gender, avg(age), Max(age), min(age)
from employee_demographics
group by gender
;

# // Count kullanımı. aşağıdaki kodda 4 female 7 female olduğunu söylüyor.
select gender, avg(age), Max(age), min(age), count(age)
from employee_demographics
group by gender
;

# // Order by Kullanımı. Rowların ya yükselen ya da azalan şekilde sıralanmasını sağlar

#Smallest to Highest kullanımı. Veya A to Z.
select *
from employee_demographics
order by first_name;

# Defualt şekilde olan smallest to highest sonucu verir. 
select *
from employee_demographics
order by first_name asc;

#Tam tersine Highest to smallest veya Z to A sonucunu verir.
select *
from employee_demographics
order by first_name desc;

#İlk olarak Gender'ı A to Z olarak alır. Daha sonra Age arasında Smallest to Higest olarak alır. 
Select*
From employee_demographics
order by gender, age
;

# Burada Yaş En yüksekten en aza gider.
Select*
From employee_demographics
order by gender, age desc
;

# Burada column name'ler yanlış sırada girildiği için female ve male unique olarak algılanmaz dolasıyla ilk Yaş işleme alınır. Ancak aynı yaşlardan sonra gender grubuna alır.
Select*
From employee_demographics
order by age, gender
;


# Column isimlerini illa girmemize gerek yok ancak hızlı yapmak adına columnların sıralamaları yazabilir.  Yukarıdaki kod ile aşağıdaki kod aynı.
Select*
From employee_demographics
order by 5, 4
;

# //  Alex data analyst bootcamp youtube series video 7 - Having vs Where // 

#Group by olmadığı yerde "where" avg(age) >40 istediğimiz sonucu verebilirdi ancak group by işlemi ilk yapılması gerekiyor. Bunun için group by'dan sonra having kullanıyoruz.
Select gender, avg(age)
from employee_demographics
group by gender
having avg(age) > 40
;

#Burada 2 tane office manager var ama ikisinin ortalamasını alıp yazıyor. 
Select occupation, avg(salary)
from employee_salary
group by occupation
;

#Having functionu sadece aggregate functionlardan sonra çalışır. Bu kodda 75000 dolar üzeri salary alan managerları filtreledik.
Select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000
;


# //  Alex data analyst bootcamp youtube series video 8 - Limit and Aliasing // 

#Limit fonksiyonu en üst sonucu göstermek için kullanılır. aşağıdaki kodda en üst 3 kodu istemişiz serverdan. 
Select *
from employee_demographics
limit 3
;

#Order by kullanımı ile işimize çok yarayabilir. En yaşlı 3 elemanı görüntüleyeceğiz.
Select *
from employee_demographics
order by age desc
limit 3
;

# "limit 2,1 " şekilde kullanımı 2. rowu alır ve 1 sonraki rowu bize gösterir. Yani en yaşlı 3. olarak Leslie.
Select *
from employee_demographics
order by age desc
limit 2,1 
;

#// Aliasing. Column veya jointslerin ismini değiştirmeye yarar.

# "AS" kullanımı isim değiştirmeye yarar. "as" kullanımına illa gerek yok. Çıkardığımızda da aynı şekilde çalışır okumak için önemli. 
select gender, avg(age) AS avg_age
# veya select gender, avg(age) avg_age
from employee_demographics
group by gender
Having avg(age) > 40
;

