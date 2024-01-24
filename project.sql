--1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)--

alter table sales_dataset_rfm_prj
alter column quantityordered type numeric using (trim(quantityordered)::numeric);
alter table sales_dataset_rfm_prj
alter column priceeach type numeric using (trim(priceeach)::numeric);
alter table sales_dataset_rfm_prj
alter column orderdate type timestamp 

--2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.

select * from sales_dataset_rfm_prj
where ordernumber is null or ordernumber =' ' ;

alter table sales_dataset_rfm_prj
alter column quantityordered type varchar(50)
select * from sales_dataset_rfm_prj
where quantityordered is null or quantityordered = ' ';

select * from sales_dataset_rfm_prj
where priceeach is null or priceeach = ' ' ;
select * from sales_dataset_rfm_prj
where orderlinenumber is null or orderlinenumber = ' ' ;
select * from sales_dataset_rfm_prj
where orderlinenumber is null or orderlinenumber = ' ' ;


/* 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. */
--firstname
alter table sales_dataset_rfm_prj
add column contactfirstname varchar(50)
update sales_dataset_rfm_prj
set contactfirstname = left(contactfullname, position('-'in contactfullname)-1)
  update sales_dataset_rfm_prj
set contactfirstname = upper(left(contactfullname, 1)) || substring(contactfullname from 2 for position('-'in contactfullname)-2)

--lastname
	
alter table sales_dataset_rfm_prj
add column contactlastname varchar(50)
update sales_dataset_rfm_prj
set contactlastname = substring(contactfullname from position('-'in contactfullname)+1)
	update sales_dataset_rfm_prj
set contactlastname = upper(left(substring(contactfullname from position('-'in contactfullname)+1),1)) ||substring(contactfullname from position('-'in contactfullname)+2)

/* 4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */

--quý
alter table sales_dataset_rfm_prj
add column qtr_id int
update sales_dataset_rfm_prj
set qtr_id =  case when extract(month from orderdate) in (1,2,3) then 1
					when extract(month from orderdate) in (4,5,6) then 2
					when extract(month from orderdate) in (7,8,9) then 3
					else 4 end 

-- tháng
alter table sales_dataset_rfm_prj
add column month_id int
update sales_dataset_rfm_prj
set month_id = extract(month from orderdate)

-- năm
alter table sales_dataset_rfm_prj
add column year_id int
update sales_dataset_rfm_prj
set year_id = extract(year from orderdate)

/* 5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)*/

-- cach 1: delete outlier
with twt as(
select q1-1.5*iqr as min_val,
q3+1.5*iqr as max_val
from(
select
percentile_cont(0.25) within group (order by quantityordered) as q1,
percentile_cont(0.75) within group (order by quantityordered) as q3,
percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as iqr
from sales_dataset_rfm_prj) as a)

select * from sales_dataset_rfm_prj
where quantityordered < (select min_val from twt)
or quantityordered > (select max_val from twt)

	delete from sales_dataset_rfm_prj
where quantityordered in (select quantityordered from twt)
-- cach 2: outlier = avg
with cte as 
(select ordernumber, quantityordered,
(select avg(quantityordered) from sales_dataset_rfm_prj as avg),
(select stddev(quantityordered) from sales_dataset_rfm_prj as stddev)
from sales_dataset_rfm_prj)
,twt_outlier as(
select ordernumber, quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >3)

update sales_dataset_rfm_prj
set quantityordered = (select avg(quantityordered) from sales_dataset_rfm_prj)
where quantityordered in (select quantityordered from twt_outlier) 






