--EX1
select name from students
where marks > 75
order by right (name,3),ID
--EX2
select user_id,
concat(upper (left(name,1)),lower (right(name, length(name)-1))) as name
from users
--EX3
select manufacturer,
'$' || Round(sum(total_sales)/1000000,0) || ' ' || 'million'
from pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer
--EX4
Select 
extract(month from submit_date) as mth,
product_id,
round(avg(stars),2) as avg_stars
from reviews
group by mth, product_id
order by mth, product_id
--EX5
Select sender_id, count(message_id) as message_count
from message
where extract(month from sent_date)=8
and extract(year from sent_date)=2020
group by sender_id
order by message_count desc
limit 2
--EX6
select tweet_id  from Tweets where length(content) >15
--EX7
SELECT activity_date as day, COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27',   INTERVAL 29 DAY) AND '2019-07-27'
GROUP BY activity_date;
--EX8
select count(employee_id) as number_employee
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022
--EX9
Select position('a' in first_name) as pst
from worker
where first_name='Amitah'
--EX10
select substring(title, length(winery)+2,4)
from winemag_p2
where country='Macelonia'
