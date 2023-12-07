-- Ad-hoc tasks
-- 1 Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT
    FORMAT_DATE('%Y-%m', TIMESTAMP(o.created_at)) AS month_year,
    COUNT(DISTINCT o.user_id) AS total_user,
    COUNT(DISTINCT o.order_id) AS total_order
FROM
    bigquery-public-data.thelook_ecommerce.order_items o
JOIN
    bigquery-public-data.thelook_ecommerce.users u ON o.user_id = u.id
WHERE
    o.status = 'Shipped'
    AND o.created_at BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY
    month_year
ORDER BY
    month_year;

-- 2 Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng

WITH MonthlyStats AS (
  SELECT
    FORMAT_DATE('%Y-%m', TIMESTAMP(o.created_at)) AS month_year,
    COUNT(DISTINCT u.id) AS distinct_users,
    SUM(o.sale_price) AS total_order_value,
    COUNT(DISTINCT o.id) AS total_orders
  FROM
    bigquery-public-data.thelook_ecommerce.order_items o
  JOIN
    bigquery-public-data.thelook_ecommerce.users u ON o.user_id = u.id
  WHERE
    o.status = 'Shipped'
    AND TIMESTAMP(o.created_at) BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
  GROUP BY month_year)

SELECT
  month_year,
  distinct_users,
  IF(total_orders > 0, total_order_value / total_orders, 0) AS average_order_value
FROM
  MonthlyStats
ORDER BY
  month_year;

-- 3. Nhóm khách hàng theo độ tuổi

CREATE TEMP TABLE TempYoungestOldest AS (
  WITH YoungestOldestByGender AS (
    SELECT
      gender,
      MIN(age) AS min_age,
      MAX(age) AS max_age
    FROM
      bigquery-public-data.thelook_ecommerce.users u
    WHERE
      DATE(u.created_at) BETWEEN '2019-01-01' AND '2022-04-30'
    GROUP BY gender)

  SELECT
    u.first_name,
    u.last_name,
    u.gender,
    u.age,
    CASE
      WHEN u.age = yobg.min_age THEN 'youngest'
      WHEN u.age = yobg.max_age THEN 'oldest'
      ELSE NULL
    END AS tag
  FROM
    bigquery-public-data.thelook_ecommerce.users u
  JOIN
    YoungestOldestByGender yobg ON u.gender = yobg.gender
  WHERE
    DATE(u.created_at) BETWEEN '2019-01-01' AND '2022-04-30');

SELECT
  gender,
  tag,
  COUNT(*) AS count
FROM
  aerobic-orbit-407411._script21fe95f501d038d480a864072bd186f610324fc1.TempYoungestOldest
GROUP BY
  gender, tag;

-- 4 Top 5 sản phẩm mỗi tháng.

WITH MonthlyProfitRank AS (
  SELECT
    FORMAT_DATE('%Y-%m', TIMESTAMP(o.created_at)) AS month_year,
    oi.product_id,
    p.name AS product_name,
    SUM(oi.sale_price) AS sales,
    SUM(p.cost) AS cost,
    SUM(oi.sale_price - p.cost) AS profit,
    DENSE_RANK() OVER (PARTITION BY FORMAT_DATE('%Y-%m', TIMESTAMP(o.created_at)) ORDER BY SUM(oi.sale_price - p.cost) DESC) AS rank_per_month
  FROM
    bigquery-public-data.thelook_ecommerce.order_items oi
  JOIN
    bigquery-public-data.thelook_ecommerce.orders o ON oi.order_id = o.order_id
  JOIN
    bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
  WHERE
    o.status = 'completed'
    AND TIMESTAMP(o.created_at) BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
  GROUP BY
    month_year, oi.product_id, p.name, o.created_at)

SELECT
  month_year,
  product_id,
  product_name,
  sales,
  cost,
  profit,
  rank_per_month
FROM
  MonthlyProfitRank
WHERE
  rank_per_month <= 5
ORDER BY
  month_year, rank_per_month;

-- 5 Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
WITH RevenueByCategory AS (
  SELECT
    FORMAT_DATE('%Y-%m-%d', DATE(o.created_at)) AS dates,
    p.category AS product_category,
    SUM(oi.sale_price) AS revenue
  FROM
    bigquery-public-data.thelook_ecommerce.order_items oi
  JOIN
    bigquery-public-data.thelook_ecommerce.orders o ON oi.order_id = o.order_id
  JOIN
    bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
  WHERE
    o.status = 'completed'
    AND DATE(o.created_at) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) AND CURRENT_DATE()
  GROUP BY dates, p.category)

SELECT
  dates,
  product_category,
  SUM(revenue) AS revenue
FROM
  RevenueByCategory
GROUP BY
  dates, product_category
ORDER BY dates, product_category;

-- Tạo metric trước khi dựng dashboard

