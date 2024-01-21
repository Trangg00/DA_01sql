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























