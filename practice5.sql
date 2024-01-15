/* bai 1: query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.*/

select country.continent, floor(avg(city.population))
from country inner join city on country.code=city.countrycode
group by country.continent

/* bai 2: Write a query to find the activation rate. Round the percentage to 2 decimal places.*/

SELECT
round(sum(case when texts.signup_action ='Confirmed' then 1 else 0 end)*1.0/count(texts.signup_action),2) as confirm_rate
from texts inner join emails on texts.email_id=emails.email_id
where emails.email_id is not null

  --tai sao lai dung sum thay vi count? tai sao phai *1.0--

/* bai 3: Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.*/

select age_breakdown.age_bucket,
round(sum(case when activities.activity_type ='send' then activities.time_spent end)/sum(case when activities.activity_type <>'chat' then activities.time_spent end)*100.0,2) as send_perc,
round(sum(case when activities.activity_type ='open' then activities.time_spent end)/sum(case when activities.activity_type <>'chat' then activities.time_spent end)*100.0,2) as open_perc
from activities
inner join age_breakdown on activities.user_id= age_breakdown.user_id
group by age_breakdown.age_bucket

/* bai 4: A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each product category.Write a query that effectively identifies the company ID of such Supercloud customers.*/

SELECT customer_contracts.customer_id
FROM customer_contracts inner join products on customer_contracts.product_id=products.product_id
where products.product_name like '%Azure%' 
group by customer_contracts.customer_id
having count(*) = (select count(distinct product_category) from products )

/* bai 5: Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.*/

select e1.employee_id, e1.name, 
count(e2.reports_to) as reports_count, 
round(avg(e2.age)) as average_age
from employees as e1
join employees as e2 on e1.employee_id=e2.reports_to
where e2.reports_to is not null
group by e1.employee_id, e1.name
having count(e2.reports_to) >=1
order by e1.employee_id

/* bai 6: Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.*/

select products.product_name, sum(orders.unit) as unit
from products inner join orders on products.product_id=orders.product_id
where extract(year from orders.order_date)=2020 and extract(month from orders.order_date)=2
group by products.product_name
having sum(orders.unit) >=100 

/* bai 7: Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.*/

SELECT pages.page_id
FROM pages left join page_likes on pages.page_id=page_likes.page_id
where page_likes.page_id is null
order by pages.page_id 

  --MID COURSE TEST --
  
/* b1. tao danh sach tat ca chi phi thay the khac nhau cua cac film
      chi phi thay the thap nhat ? */

select distinct (replacement_cost)
from film
order by replacement_cost

/* b2. cung cap cai nhin tong quan ve so luong phim co chi phi thay the trong cac pham vi:
1. low: 9.99 - 19.99
2. medium: 20.00 - 24.99
3. high: 25.00 - 29.00
co bao nhieu phim co chi phi thay the thuoc nhom low? */
  
select count(*),
case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end pham_vi
from film
group by case
	when replacement_cost between 9.99 and 19.99 then 'low'
	when replacement_cost between 20.00 and 24.99 then 'medium'
	when replacement_cost between 25.00 and 29.99 then 'high'
end 

/* b3. tao danh sach cac film_title duoc sap xep theo do dai giam dan. loc ket qua cac phim trong danh muc 'drama' hoac 'sports.
phim dai nhat thuoc the loai nao, dai bao nhieu? */

select film.title, film.length, category.name
from film inner join film_category on film.film_id=film_category.film_id
inner join category on film_category.category_id=category.category_id
where category.name in ('Drama','Sports')
order by film.length desc

/* b4. dua ra cai nhin tong quan ve so luong phim (title) trong moi danh muc (category).
the loai danh muc nao la pho bien nhat? */

select category.name, count(film.title)
from film join film_category on film.film_id=film_category. film_id
join category on film_category.category_id=category.category_id
group by category.name
order by count(film.title) desc

/* b5. dua ra cai nhin tong quan ve ho va ten cua cac dien vien cung nhu so luong phim ho tham gia.
dien vien dong nhieu phim nhat? */

select actor.first_name, actor.last_name, count(film_actor.film_id) as count_movie
from actor join film_actor on actor.actor_id=film_actor.actor_id
group by actor.first_name, actor.last_name
order by count(film_actor.film_id) desc

/* b6. tim cac dia chi khong lien quan den bat ky khach hang nao.
co bao nhieu dia chi nhu vay? */

select count(address.address)
from address left join customer on address.address_id=customer.address_id
where customer.first_name is null

/* b7. danh sach cac thanh pho va doanh thu tuong ung.
thanh pho nao dat doanh thu cao nhat? */

select city.city, sum(payment.amount)
from city join address on city.city_id=address.city_id
join customer on address.address_id=customer.address_id
join payment on customer.customer_id=payment.customer_id
group by city.city
order by sum(payment.amount) desc

/* b8. tao danh sach tra ra 2 cot du lieu:
cot 1: thong tin thanh pho vaf dat nuoc
cot 2: doanh thu tuong ung
thanh pho nao dat doanh thu cao nhat? */

select city.city, country.country, sum(payment.amount)
from country join city on city.country_id=country.country_id
join address on city.city_id=address.city_id
join customer on address.address_id=customer.address_id
join payment on customer.customer_id=payment.customer_id
group by city.city, country.country
order by sum(payment.amount) desc









































