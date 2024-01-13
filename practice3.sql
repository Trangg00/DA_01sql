/* bai 1: Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.*/

select name from Students
where marks >75
order by right(name,3) asc, id asc

/* bai 2: Write a solution to fix the names so that only the first character is uppercase and the rest are lowercase. Return the result table ordered by user_id.*/

select user_id, upper(left(name,1)) || lower(right(name,length(name)-1)) as name -- hoac lower(substring(name,2))
from users
order by user_id

/* bai 3: calculate the total drug sales for each manufacturer. Round the answer to the nearest million and report your results in descending order of total sales. In case of any duplicates, sort them alphabetically by the manufacturer name.*/
  
SELECT manufacturer, concat('$',round((sum(total_sales)/1000000)),' million')
FROM pharmacy_sales
group by manufacturer
order by round((sum(total_sales)/1000000)) desc, manufacturer desc 

/* bai 4: retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.*/

SELECT product_id, extract(month from submit_date) as mth, round(avg(stars),2) as avg_stars
FROM reviews
GROUP BY product_id, extract(month from submit_date)
order by extract(month from submit_date), product_id

/* bai 5: identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.*/

  SELECT sender_id, count(message_id) as count_messages 
FROM messages
where extract(month from sent_date)=8 and extract(year from sent_date)=2022
group by sender_id
order by count(message_id) desc
limit 2

/* bai 6: find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15*/

select tweet_id
from Tweets
where length(content)>15

/* bai 7: find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.*/ 

select activity_date as day, count(distinct(user_id)) as active_users
from Activity
where activity_date between '2019-06-2828' and '2019-07-27'
group by activity_date
?????

/* bai 8: find the number of employees hired between the months of January and July in the year 2022 inclusive.*/

select count(*)
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date)=2022

/* bai 9: Find the position of the lower case letter 'a' in the first name of the worker 'Amitah'.*/

select position('a' in first_name) 
from worker
where first_name ='Amitah'

/* bai 10: Find the vintage years of all wines from the country of Macedonia. The year can be found in the 'title' column. Output the wine (i.e., the 'title') along with the year. The year should be a numeric or int data type.*/

select substring(title, length(winery)+2,4)
from winemag_p2
where country ='Macedonia'

















