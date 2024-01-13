/* bai 1: calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views*/

SELECT 
sum(case 
 when device_type ='laptop' then 1
 else 0
 end) as laptop_views,
sum(case
  when device_type in ('tablet','phone') then 1
  else 0
  end) as mobile_views
FROM viewership

/* bai 2: Report for every three line segments whether they can form a triangle.*/

select x,y,z,
case 
    when x+y>z and x+z>y and y+z>x then 'Yes'
    else 'No'
end triangle
from Triangle

/* bai 3: find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.*/

SELECT 
round(sum(CASE
  when call_category = 'n/a' then 1
  when call_category is null then 1
  else 0
  end)/count(*)*100,1) as call_percentage
FROM callers

/* bai 4: Find the names of the customer that are not referred by the customer with id = 2.*/

select name
from Customer
where coalesce(referee_id,0) !=2  -- where referee_id is null or referee_id != 2

/* bai 5: Make a report showing the number of survivors and non-survivors by passenger class.
Classes are categorized based on the pclass value as:
pclass = 1: first_class
pclass = 2: second_classs
pclass = 3: third_class
Output the number of survivors and non-survivors by each class.*/

select survived, 
sum(case
    when pclass = 1 then 1 else 0
    end) as first_class,
sum(case
    when pclass = 2 then 1 else 0
    end) as second_class,
sum( case
    when pclass = 3 then 1 else 0
    end) as third_class
from titanic
group by survived



















