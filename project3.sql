--1) Doanh thu theo từng ProductLine, Year  và DealSize?

select distinct productline, year_id, dealsize,
sum(sales) over (partition by productline, year_id, dealsize) as revenue
from sales_dataset_rfm_prj

-- 2) Đâu là tháng có bán tốt nhất mỗi năm?

select distinct month_id, ordernumber, 
sum(sales) over (partition by month_id) as revenue
from sales_dataset_rfm_prj
order by sum(sales) over (partition by month_id) desc

--3) Product line nào được bán nhiều ở tháng 11?

select distinct month_id, productline,
sum(sales) over (partition by productline) as revenue
from sales_dataset_rfm_prj
where month_id= 11
order by revenue desc

--4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 

select * from (
select productline, year_id, sum(sales) as revenue,
rank () over(partition by year_id order by sum(sales) desc) as rank
from sales_dataset_rfm_prj
where country = 'UK'
group by productline, year_id) a
where a.rank =1

--5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)

with customer_rfm as (
select customer_id,
current_date - max(order_date) as r,
count(distinct orde_id) as f,
sum(sales) as m
from customer a join sales b on a.customer_id = b.customer_id
group by a.customer_id)
, rfm_score as (
select customer_id,
ntile(5) over (order by r desc) as r_score,
ntile(5) over (order by f) as f_score,
ntile(5) over (order by m) as m_score
from customer_rfm)
, rfm as (
select customer_id, 
cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as rfm_score
from rfm_score)

select a.customer_id, b.segment 
from rfm a join segment_score b on a.rfm_score = b.scores





































