--EX1
SELECT CO.CONTINENT, FLOOR(AVG(CI.POPULATION)) FROM COUNTRY CO
INNER JOIN CITY CI ON CO.CODE = CI.COUNTRYCODE
GROUP BY CO.CONTINENT;
--EX2
SELECT 
  ROUND(COUNT(texts.email_id)::DECIMAL
    /COUNT(DISTINCT emails.email_id),2) AS activation_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed';
--EX3
SELECT 
  age.age_bucket, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send')/
      SUM(activities.time_spent),2) AS send_perc, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open')/
      SUM(activities.time_spent),2) AS open_perc
FROM activities
INNER JOIN age_breakdown AS age 
ON activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket;
--EX4
SELECT cc.customer_id from customer_contracts as cc 
LEFT JOIN products as p  
on cc.product_id = p.product_id
group by cc.customer_id
having COUNT(DISTINCT(p.product_category)) = (select COUNT(Distinct(product_category)) from products)
--EX5
SELECT
    emp1.employee_id,
    emp1.name,
    COUNT(emp2.employee_id) AS reports_count,
    ROUND(AVG(emp2.age)) AS average_age
FROM Employees emp1
INNER JOIN Employees emp2 ON emp1.employee_id = emp2.reports_to
GROUP BY emp1.employee_id
ORDER BY emp1.employee_id;
--EX6
SELECT p.product_name AS product_name, sum(o.unit) AS unit 
FROM Products p
LEFT OUTER JOIN Orders o USING (product_id)
WHERE YEAR(o.order_date)='2020' AND MONTH(o.order_date)='02'
GROUP BY p.product_id
HAVING SUM(o.unit)>=100;
--EX7
SELECT pages.page_id
FROM pages
LEFT OUTER JOIN page_likes AS likes
  ON pages.page_id = likes.page_id
WHERE likes.page_id IS NULL;
--Mid-course test
--EX1
select distinct replacement_cost from film
order by replacement_cost;
--EX2
select 
case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end as category,
count (*) as so_luong
from film
group by category;
--EX3
select a.title, a.length, c.name
from film as a
inner join film_category as b
on a.film_id = b.film_id
inner join category as c
on b.category_id = c.category_id
where name='Drama' or name='Sports'
order by length desc;
--EX4
select c.name,
count (title) as so_luong from film as a
inner join film_category as b
on a.film_id = b.film_id
inner join category as c
on b.category_id = c.category_id
group by c.name
order by so_luong desc;
--EX5
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(b.film_id) AS so_luong_phim_tham_gia
FROM actor a
JOIN film_actor b ON a.actor_id = b.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY so_luong_phim_tham_gia DESC;
--EX6
SELECT 
    a.address_id, a.address
FROM address a
LEFT JOIN customer c ON a.address_id = c.address_id
WHERE c.address_id IS NULL;
--EX7
SELECT 
    c.city_id, c.city,
    SUM(p.amount) AS doanh_thu
FROM city c
JOIN address a ON c.city_id = a.city_id
JOIN customer cu ON a.address_id = cu.address_id
JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY c.city_id, c.city
ORDER BY doanh_thu DESC;
--EX8
SELECT 
    CONCAT(c.city, ', ', co.country) AS city_country,
    SUM(p.amount) AS doanh_thu
FROM city c
JOIN country co ON c.country_id = co.country_id
JOIN address a ON c.city_id = a.city_id
JOIN customer cu ON a.address_id = cu.address_id
JOIN payment p ON cu.customer_id = p.customer_id
GROUP BY city_country
ORDER BY doanh_thu;

