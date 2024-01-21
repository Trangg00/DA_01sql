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

/* bai 6: 








































