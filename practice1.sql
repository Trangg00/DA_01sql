/* bài 1: Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.*/
select name from city
where countrycode = 'USA' and population > 120000
  
/* bài 2: Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.*/
select * from city
where countrycode = 'JPN'

/* bài 3: Query a list of CITY and STATE from the STATION table.*/
select city, state from station

/* bài 4: Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.*/
select distinct city from station
where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%'

/* bài 5: Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.*/
select distinct city from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'

/* bài 6: Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.*/
select distinct city from station
where city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%'

/* bài 7: Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.*/
select name from Employee
order by name 

/* bài 8: Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. Sort your result by ascending employee_id.*/
select name from Employee
where salary > 2000 and months < 10
order by employee_id asc

/* bài 9: Write a solution to find the ids of products that are both low fat and recyclable.*/
select  product_id from Products
where low_fats = 'Y' and recyclable = 'Y'

/* bài 10: Find the names of the customer that are not referred by the customer with id = 2.*/
select name from Customer
where referee_id != 2 or referee_id is null

/* bài 11: */
select name, population, area from World
where area >=3000000 or population >= 25000000

/* bài 12: Write a solution to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.*/
select distinct author_id as id from Views
where author_id = viewer_id 
order by author_id

/* bài 13: Write a query to determine which parts have begun the assembly process but are not yet finished.*/
SELECT part, assembly_step FROM parts_assembly
where finish_date is null

/* bài 14: Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD*/
select * from lyft_drivers
where yearly_salary <=30000 or yearly_salary >=70000

/* bài 15: Find the advertising channel where Uber spent more than 100k USD in 2019*/
select advertising_channel from uber_advertising
where money_spent > 100000 and year = 2019


