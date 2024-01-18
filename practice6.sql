/* bai 1: Write a query to retrieve the count of companies that have posted duplicate job listings.*/
select count(*)
from (select company_id, title, description, COUNT(*) 
      from job_listings
      group by company_id, title, description
      having count(*)>1) as duplicate_companies

/* bai 2: write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.*/
(select category, product, total_spend
 from
 (select category, product, sum(spend) as total_spend
 from product_spend
 where extract(year from transaction_date) =2022
 group by category, product) as a
 where category = 'appliance'
 order by category, total_spend desc 
 limit 2 )

UNION ALL

(select category, product, total_spend
 from
 (select category, product, sum(spend) as total_spend
 from product_spend
 where extract(year from transaction_date) =2022
 group by category, product) as a
 where category = 'electronics'
 order by category, total_spend desc 
 limit 2 )

/* bai 3: Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each call made.*/
SELECT count(policy_holder_id) as member_count
from (select policy_holder_id, count(case_id)
      from callers
      group by policy_holder_id
      having count(case_id) >=3) as calls

/* bai 4: Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.*/
select page_id
from pages
where page_id not in (SELECT page_id from page_likes)
order by page_id 

/* bai 5: Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".*/
SELECT extract(month from event_date) as month,
count(distinct user_id) as monthly_active_uers
FROM user_actions 
where user_id in (select user_id
          from user_actions 
          where extract(month from event_date)= 6)
and extract(month from event_date)=7 
and extract(year from event_date)=2022
group by extract(month from event_date)

/* bai 6: find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.*/
select to_char(trans_date,'yyyy-mm') as month, country,
count(id) as trans_count,
sum(case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state ='approved' then amount else 0 end) as approved_total_amount
from Transactions
group by month, country

/* bai 7: Write a solution to select the product id, year, quantity, and price for the first year of every product sold*/
select product_id, year as first_year, quantity, price
from sales
where (product_id, year) in 
(select product_id, min(year) from sales
group by product_id )

/* bai 8: Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.*/
select customer_id
from Customer
group by customer_id
having count(distinct product_key)= (select count(product_key) from Product)

/* bai 9: Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.*/
select employee_id
from Employees
where salary < 30000
and manager_id not in (select employee_id from Employees)
order by employee_id

/* bai 10: */
select count(*)
from (select company_id, title, description, COUNT(*) 
      from job_listings
      group by company_id, title, description
      having count(*)>1) as duplicate_companies

/* bai 11: Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name.*/
select name as results from
(select name, count(*)
from users
join MovieRating on users.user_id= MovieRating.user_id
group by name
order by count(*) desc, name
limit 1)

union all

select title as results from
(select m.title
from MovieRating mr join Movies m on mr.movie_id=m.movie_id
where to_char(created_at,'yyyy-mm')='2020-02'
group by m.title
order by avg(mr.rating) desc, m.title
limit 1)

/* bai 12: Write a solution to find the people who have the most friends and the most friends number.*/
select id, count(id) as num from
(select requester_id as id from RequestAccepted
union all
select accepter_id as id from RequestAccepted)
group by id
order by count(id) desc
limit 1























