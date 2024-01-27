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
b.product_id, a.name, a.cost,
sum(b.sale_price) as sales, 
(sum(b.sale_price)-a.cost) as profit,
dense_rank() over(order by (sum(b.sale_price)-a.cost) desc) as rank_per_month
from bigquery-public-data.thelook_ecommerce.products as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.id = b.product_id 
group by 1,2,3,4) as c
where rank_per_month <=5

/* 5. Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022) */

select  
delivered_at "2022-04-15 0:00:00" as original_date,
  DATETIME_ADD(delivered_at "2022-04-15 0:00:00", INTERVAL 3 month) as later




















