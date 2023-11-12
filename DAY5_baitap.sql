--EX1
select distinct city from station where ID%2 = 0;
--EX2
select count(city) - count(distinct city) from station;
--EX3
SELECT CEIL(AVG(salary) - AVG(REPLACE(salary, '0', ''))) AS salary_difference FROM EMPLOYEES;
--EX4
select round(cast(sum(item_count*order_occurrence)/sum(order_occurrence) as decimal),1) as mean from items_per_order;
--EX5
select candidate_id from candidates where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3;
--EX6
select user_id,
date(Max(post_date))-date(Min(post_date)) as days_between
from posts
where post_date>='2021-01-01' and post_date < '2022-01-01'
group by user_id
having count(post_id)>=2
--EX7
select card_name,
max(issued_amount)-min(issued_amount) as difference
from monthly_cards_issued
group by card_name
order by difference desc;
--EX8
SELECT manufacturer,
count(drug) as drug_count,
abs(sum(cogs-total_sales)) as total_loss
FROM pharmacy_sales
group by manufacturer
order by total_loss desc
--EX9
select * from cinema where id%2=1 and description <> 'boring'
order by rating desc
--EX10
select teacher_id,
count (distinct subject_id) as cnt
from teacher
group by teacher_id;
--EX11
select user_id,
count (follower_id) as followers_count
from followers
group by user_id
order by user_id;
--EX12
select class from courses
group by class
having count(student)>=5;
