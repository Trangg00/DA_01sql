/* 1. Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022) */

select format_date('%Y-%m', date (delivered_at)) as month_year,
count(user_id) as total_user,
count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' and (format_date('%Y-%m', date (delivered_at)) between '2019-01' and '2022-04' )
group by month_year

/* 2. thống kê giá trị đơn hàng trung bình và tônge số người dùng khác nhau mỗi tháng (1/2019-4/2022) */

select FORMAT_DATE('%Y-%m', DATE (delivered_at)) AS month_year,
count(distinct user_id) as distinct_users,
sum(sale_price)/count(order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete' and (FORMAT_DATE('%Y-%m', DATE (delivered_at)) between '2019-01' and '2022-04' )
group by month_year
order by month_year asc

/* 3. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022) */

select min(age) as youngest, count(*) from
(select first_name, last_name,age, gender
from bigquery-public-data.thelook_ecommerce.users  
where format_date('%Y-%m', date (created_at)) between '2019-01' and '2022-04') 
union all
select max(age) as oldest, count(*) from 
(select first_name, last_name, age, gender
from bigquery-public-data.thelook_ecommerce.users
where format_date('%Y-%m', date (created_at)) between '2019-01' and '2022-04')

/* 4. Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm).*/

select * from (
select format_date('%Y-%m', date(b.delivered_at)) as month_year,
b.product_id, a.name,
sum(a.cost) as cost,
sum(b.sale_price) as sales, 
(sum(b.sale_price)-sum(a.cost)) as profit,
dense_rank() over( order by (sum(b.sale_price)-sum(a.cost)) desc) as rank_per_month
from bigquery-public-data.thelook_ecommerce.products as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.id = b.product_id
group by 1,2,3 ) as c
where rank_per_month <=5
  order by rank_per_month

/* 5. Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022) */

select b.category as product_categories, format_date('%Y-%m-%d', date(a.delivered_at)) as dates,
sum(a.sale_price) over(partition by b.category, format_date('%Y-%m-%d', date(a.delivered_at))) as revenue
from bigquery-public-data.thelook_ecommerce.order_items a join bigquery-public-data.thelook_ecommerce.products b 
on a.product_id =b.id 
where a.status = 'Complete' and (format_date('%Y-%m-%d', date(a.delivered_at)) between '2022-01-15' and '2022-04-15')
  

------------------------------------------------------------------------------------------------------------------------------------------------

/* BẢNG DỮ LIỆU*/

  select distinct * from (
select *, 
concat(round(100.00 * (tpv - prev_tpv) / prev_tpv,4),'%') as revenue_growth 
from (
select *, 
lag(tpv) over (order by month) as prev_tpv 
from (
select 
format_date('%Y-%m', date (b.delivered_at)) as month,
sum(b.sale_price) as tpv
from bigquery-public-data.thelook_ecommerce.products as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.product_id 
where status = 'Complete'
group by 1)) as bang1

join 
(
select 
format_date('%Y-%m', date (b.delivered_at)) as month,
format_date('%Y', date (b.delivered_at)) as year,
a.category as product_category, 
sum(a.cost) over (order by format_date('%Y-%m', date (b.delivered_at))) as total_cost,
count(b.order_id) over ( order by format_date('%Y-%m', date (b.delivered_at))) as tpo,
sum(b.sale_price) over (order by format_date('%Y-%m', date (b.delivered_at))) - sum(a.cost) over ( order by format_date('%Y-%m', date (b.delivered_at))) as total_profit,
round(100.00*(sum(b.sale_price) over ( order by format_date('%Y-%m', date (b.delivered_at))) - sum(a.cost) over (order by format_date('%Y-%m', date (b.delivered_at)))) / sum(a.cost) over ( order by format_date('%Y-%m', date (b.delivered_at))),4) as profit_to_cost_ratio
from bigquery-public-data.thelook_ecommerce.products as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.product_id 
where b.status = 'Complete'
) as bang2
on bang1.month=bang2.month

join (
select *, 
concat(round(100.00 * (orders - prev_orders) / prev_orders,4),'%') as order_growth 
from (
select *, 
lag(orders) over (order by month) as prev_orders
from (
select format_date('%Y-%m', date (delivered_at)) as month,
count(order_id) as orders
from bigquery-public-data.thelook_ecommerce.order_items
where status = 'Complete'
group by 1))) as bang3
on bang2.month=bang3.month )















