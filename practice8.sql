/* bai 1: If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.*/

select
round(sum(case when order_date = customer_pref_delivery_date then 1
else 0 end)*100/ count(distinct customer_id)::decimal,2) as immediate_percentage
from delivery
where (customer_id, order_date) in 
( select customer_id, min(order_date)
from delivery
group by customer_id
)
--HOẶC
select
round(sum(case when order_date = customer_pref_delivery_date then 1
else 0 end)*100/ count(distinct customer_id)::decimal,2) as immediate_percentage
from 
(select customer_id, order_date, customer_pref_delivery_date,
rank() over(partition by customer_id order by order_date) as rank
from delivery
) a
where a.rank=1

/* bai 2: Write a solution to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.*/
???
select round(count(distinct player_id)/(select count(distinct player_id) from Activity) ::decimal,2) as fraction
from
(select player_id, event_date,
lead(event_date) over(partition by player_id) as next_day,
lead(event_date) over(partition by player_id) - event_date as diff
from Activity) a
where diff = 1

/* bai 3: Write a solution to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.*/

select 
case when id %2 !=0 and id = (select count(*) from Seat) then id
when id %2 =0 then id-1
else id+1
end id,
student
from Seat
order by id

/* bai 4: You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order.*/
???
  select visited_on,
amount+a1+a2+a3+a4+a5+a6 as amount,
round(amount/7,2) as average_amount
from (
select visited_on, amount,
lag(amount,1) over (partition by visited_on) as a1,
lag(amount,2) over (partition by visited_on) as a2,
lag(amount,3) over (partition by visited_on) as a3,
lag(amount,4) over (partition by visited_on) as a4,
lag(amount,5) over (partition by visited_on) as a5,
lag(amount,6) over (partition by visited_on) as a6,
rank() over(order by visited_on) as first_date
from Customer) a
where a.first_date >=7

/* bai 5: Write a solution to report the sum of all total investment values in 2016 tiv_2016, for all policyholders who:
have the same tiv_2015 value as one or more other policyholders, and
are not located in the same city as any other policyholder (i.e., the (lat, lon) attribute pairs must be unique).
Round tiv_2016 to two decimal places. */

select round(sum(tiv_2016), 2) as tiv_2016 
from Insurance
where (tiv_2015) in 
    (select tiv_2015 from Insurance 
    group by tiv_2015 
    having count(*) > 1)
    and (lat, lon) in 
    (select lat, lon from Insurance 
    group by lat, lon 
    having count(*) = 1)

/* bai 6: A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.*/

select Department, Employee, Salary
from
(select d.name as Department, e.name as Employee, e.salary as Salary,
dense_rank() over (partition by d.name order by e.salary desc) as stt
from Employee e join Department d on e.departmentId=d.id) a
where a.stt <=3

/* bai 7: There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.
Write a solution to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit*/

select person_name
from 
(select turn, person_id, person_name, weight,
sum(weight) over (order by turn) as total_weight
from Queue) a
where total_weight <=1000 
order by total_weight desc
limit 1

/* bai 8: Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.*/

select product_id, 
first_value(new_price) over (partition by product_id order by change_date desc) as price
from Products
where change_date <='2019-08-16'
union
select product_id, 10 as price
from Products
group by product_id
having min(change_date) >'2019-08-16'































































