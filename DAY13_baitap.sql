--EX4
SELECT page_id
FROM pages
WHERE NOT EXISTS (
  SELECT page_id
  FROM page_likes AS likes
  WHERE likes.page_id = pages.page_id)
--EX5
SELECT  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
        COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS ( SELECT last_month.user_id 
                FROM user_actions AS last_month
                WHERE last_month.user_id = curr_month.user_id
                AND EXTRACT(MONTH FROM last_month.event_date) =
                    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month'))
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);
--EX6
select DATE_FORMAT(trans_date, "%Y-%m") as month, 
    country, 
    count(id) as trans_count,
    sum(case when state = 'approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount  
from Transactions
group by month, country;
--EX7
SELECT product_id, year AS first_year, quantity, price
FROM Sales
WHERE (product_id, year) in ( SELECT product_id, MIN(year) 
                              FROM Sales
                              GROUP BY product_id)
--EX8
SELECT customer_id
FROM customer c
GROUP BY customer_id
HAVING count(distinct product_key)=(SELECT count(distinct product_key) FROM product)
--EX9
SELECT employee_id 
FROM employees
WHERE salary < 30000 AND manager_id NOT IN (SELECT employee_id FROM employees) 
ORDER BY employee_id;
--EX10: CTE: Xác định các công ty có danh sách việc làm trùng lặp
WITH job_count_cte AS ( SELECT company_id, title, description, 
                        COUNT(job_id) AS job_count
                        FROM job_listings
                        GROUP BY company_id, title, description)
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM job_count_cte
WHERE job_count > 1;
