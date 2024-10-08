## Elektrik kesildiğin için Alex data analyst bootcamp youtube series video 15-16 kayıtları silindi.

# // Alex data analyst bootcamp youtube series video 17  - Stored Procedures // 

-- Stored Procedures 
## Stored Procedures are way to save ur code and use it over and over again. Komplex queries için oldukça ideal.
## Save edilen queries solda stored procedures sekmesinde gözükür.

-- Create procedure 
Create procedure large_salaries()
select * 
from employee_salary
where salary >= 50000
;

-- Call large_salaries()

call large_salaries();
call parks_and_recreation.large_salaries();

-- Delimeter $$

DELIMITER $$
Create procedure large_salaries3()
BEGIN
select * 
from employee_salary
where salary >= 50000;
select *
from employee_salary
where salary >= 10000;
end $$
DELIMITER ;

## we get 2 seperate results

call large_salaries3();


## aşağıda 1 numaralı employee'nin salary'sini görmek için alias gibi bir query oluşturduk. ve Call yaptığımız şey kolayca istediğimizi şeyi veriyor.

DELIMITER $$
Create procedure large_salaries4(employee_id_param int)
BEGIN
select salary
from employee_salary
where employee_id = employee_id_param 
;
end $$
DELIMITER ;


# // Alex data analyst bootcamp youtube series video 18  - triggers and events // 

## Salary table'ına yeni birini eklediğimizde otomatik bir şekilde bu kişiyi demographics table'ını ekleyeceğiz.

-- Create trigger
## data created'dan sonra after geliyor. eğer data silinecekse before insert on'u kullanabiliriz.

-- for each row tüm rowlara uygulanır
-- new/old sadece yeni eklenen rowlar için. veya old silinenler için.

## aşağıdaki kodu sol taraftaki employee_salary > triggers kısmında görüntüleyebiliriz.  

Delimiter $$
create TRIGGER employee_insert1
     After insert on employee_salary
     for each row 
BEGIN
insert into employee_demographics (employee_id, first_name, last_name)
values (new.employee_id, new.first_name, new.last_name);
end $$
Delimiter ;

Insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values (13, 'jean rokoko', 'sapien', 'football player', 1000000, null);

## hem salary hem demographics'e eklenmiş oldu sadece salary'ye ekleyerek.
select *
from employee_salary;

select * 
from employee_demographics;

-- Events

## 60 yaşındaki jerry'yi 60 yaşından büyük olduğu için silmiş olduk.

Select * 
from employee_demographics;

Delimiter $$
Create Event delete_retirees
on schedule every 30 second
do 
begin 
      delete 
      from employee_demographics
      where age >= 60;
end $$
Delimiter ;

## üstekki eventi yaratamadıysanız aşağıdaki işlemi yapıp value'nin on olduğundan emin olun. 
## eğer table'dan silme işlemine yetkiniz yoksa Edit>preferences>sql editor uncheck safe delete. 
show variables like 'event%';








     
     
    
