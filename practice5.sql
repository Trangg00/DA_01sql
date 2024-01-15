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













































