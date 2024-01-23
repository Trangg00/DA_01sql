--1. Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER)--

alter table sales_dataset_rfm_prj
alter column quantityordered type numeric using (trim(quantityordered)::numeric);
alter table sales_dataset_rfm_prj
alter column priceeach type numeric using (trim(priceeach)::numeric);
alter table sales_dataset_rfm_prj
alter column orderdate type timestamp 

--2. Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.



/* 3. Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. */

alter table sales_dataset_rfm_prj
add column contactfirstname varchar(50)
update sales_dataset_rfm_prj
set contactfirstname = left(contactfullname, position('-'in contactfullname)-1)
  update sales_dataset_rfm_prj
set contactfirstname = upper(left(contactfullname, 1)) || substring(contactfullname from 2 for position('-'in contactfullname)-2)

alter table sales_dataset_rfm_prj
add column contactlastname varchar(50)
update sales_dataset_rfm_prj
set contactlastname = substring(contactfullname from position('-'in contactfullname)+1)

/* 4. Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */

alter table sales_dataset_rfm_prj
add column qtr_id int
update sales_dataset_rfm_prj
set qtr_id in (select case when extract(month from orderdate) in (1,2,3) then 1
					when extract(month from orderdate) in (4,5,6) then 2
					when extract(month from orderdate) in (7,8,9) then 3
					else 4 end
					from sales_dataset_rfm_prj)







