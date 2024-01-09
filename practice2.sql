/* bai 1: Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.*/
select distinct city from Station
where id %2 =0

/* bai 2: Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.*/
select count(city)-count(distinct city)
from station

/* bai 3: Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.*/
select ceil(avg(salary)-avg(replace(salary,0,''))) 
from employees

/* bai 4: You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (item_count table) and the corresponding number of orders for each item count (order_occurrences table)*/
select --chuyển số nguyên về số thập phân--
round (cast(sum(item_count * order_occurrences)/sum(order_occurrences) as decimal),1) as mean 
from items_per_order

/* bai 5: Write a query to list the candidates who are proficient in Python, Tableau, and PostgreSQL. Sort the output by candidate ID in ascending order.*/
SELECT candidate_id
from candidates
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill) =3
order by candidate_id

/* bai 6: Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021 */
SELECT user_id, 
max(date(post_date))-min(date(post_date)) as days_between
from posts
where post_date between '01-01-2021' and '01-01-2022'
group by user_id
having count (*) >=2
-- HOẶC: 
SELECT 
	user_id, 
    MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021 
GROUP BY user_id
HAVING COUNT(post_id)>1;

/* bai 7: outputs the name of each credit card and the difference in the number of issued cards between the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.*/
select card_name, max(issued_amount)-min(issued_amount) as difference
from monthly_cards_issued
group by card_name
order by difference desc

/* bai 8: Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health and calculate the total amount of losses incurred.
Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. Display the results sorted in descending order with the highest losses displayed at the top.*/
  --cogs: cost of goods sold
select manufacturer, count(drug) as drug_count, abs(sum(cogs-total_sales)) as total_loss
from pharmacy_sales
where total_sales < cogs
group by manufacturer
order by total_loss desc
  
/* bai 9: Write a solution to report the movies with an odd-numbered ID and a description that is not "boring".
Return the result table ordered by rating in descending order.*/
select * from Cinema
where id %2 !=0 and description not like 'boring'
order by rating desc

/* bai 10: Write a solution to calculate the number of unique subjects each teacher teaches in the university.*/
select teacher_id, count(distinct(subject_id)) as cnt 
from Teacher
group by teacher_id
  
/* bai 11: Write a solution that will, for each user, return the number of followers.
Return the result table ordered by user_id in ascending order.*/
select user_id, count(*) as followers_count
from Followers
group by user_id
order by user_id

/* bai 12: Write a solution to find all the classes that have at least five students.
Return the result table in any order.*/
select class from Courses
group by class
having count(*) >=5






