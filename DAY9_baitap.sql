--EX1
SELECT 
  COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone'))  AS mobile_views 
FROM viewership;
--EX2
select 
x,y,z,
case when (x+y) > z and (x+z) > y and (y+z) > x 
then 'Yes' 
else 'No' 
end as triangle
from Triangle;
--EX3
SELECT
  ROUND(100.0 * 
    SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a'
      THEN 1
      ELSE 0
      END) /COUNT(*), 1) AS call_percentage
FROM callers;
--EX4
SELECT name
FROM Customer
WHERE COALESCE(referee_id,0) <> 2;
--EX5
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;
