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

--EX2

--EX3

--EX4

--EX5

--EX6

--EX7

--EX8

