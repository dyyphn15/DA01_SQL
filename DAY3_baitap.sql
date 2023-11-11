--Ex1
select name from city where population > 120000 and countrycode = 'USA';
--Ex2
select * from city where countrycode = 'JPN';
--Ex3
select city, state from station;
--Ex4
select distinct city from station where left(city,1) in ('A','E','I','O','U');
--Ex5
select distinct city from station where right(city,1) in ('A','E','I','O','U')
--Ex6
select distinct city from station where lower(substr(city,1,1)) not in ('a','e','i','o','u');
--Ex7
select name from employee order by name asc;
--Ex8
select name from employee where salary > 2000 and months < 10;
--Ex9
select product_id from Products where low_fats='Y' and recyclable='Y';
--Ex10
select name from customer where referee_id != 2 or referee_id is null;
--Ex11
select name,population,area from World where area >= 3000000 or population >=25000000
--Ex12
select distinct author_id as id from Views where author_id = viewer_id 
order by id;
--Ex13
select part, assembly_step from parts_assembly where finish_date is NULL;
--Ex14
select * from lyft_drivers where yearly_salary <= 30000 or yearly_salary >= 70000;
--Ex15
select * from uber_advertising where money_spent > 100000 and year = 2019;
