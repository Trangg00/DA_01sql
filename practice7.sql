/* bai 1: Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.
The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.*/

SELECT extract(year from transaction_date), product_id, 
spend as curr_year_spend, 
lag(spend) over(partition by product_id order by extract(year from transaction_date)) as prev_year_spend,
round((spend - lag(spend) over(partition by product_id order by extract(year from transaction_date)))/lag(spend) over(partition by product_id order by extract(year from transaction_date))*100,2) AS yoy_rate
FROM user_transactions

/* bai 2: Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the monthly_cards_issued table for a given card. Order the results starting from the biggest issued amount.*/

SELECT distinct card_name, 
first_value(issued_amount) over(partition by card_name order by issue_year, issue_month) as issued_amount
FROM monthly_cards_issued
order by issued_amount desc

/* bai 3: Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.*/

select  user_id, spend, transaction_date from 
(SELECT user_id, spend, transaction_date,
row_number() over(partition by user_id order by transaction_date) as stt 
FROM transactions) a  
where a.stt=3

/* bai 4: write a query that retrieve the users along with the number of products they bought.
Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date*/

select a.transaction_date, a.user_id, count(*)  as purchase_count
from
(SELECT *,
rank() over (partition by user_id order by transaction_date desc) as stt
from user_transactions) a 
where a.stt=1
group by a.transaction_date, a.user_id

/* bai 5: Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.*/

select user_id, tweet_date,
case when lag1 =0 and lag2 =0 then round(tweet_count,2)
when lag2 =0 then round((tweet_count+lag1)/2::decimal,2)
else round((lag1+tweet_count+lag2)/3::decimal,2)
end as rolling_avg_3d
FROM(
SELECT user_id, tweet_date, tweet_count, 
lag(tweet_count,1,0) over (partition by user_id order by tweet_date ) as lag1,
lag(tweet_count,2,0) over (partition by user_id order by tweet_date ) as lag2
FROM tweets) as a  
  
/* bai 6: Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.*/
  
select count(*) as payment_count from (
SELECT transaction_id, merchant_id, credit_card_id, amount,transaction_timestamp,
lead(transaction_timestamp) over (partition by merchant_id) as next_transaction,
lead(amount) over (partition by merchant_id order by transaction_timestamp) as next_amount,
lead(transaction_timestamp) over (partition by merchant_id) - transaction_timestamp as diff_time ,
lead(amount) over (partition by merchant_id order by transaction_timestamp) - amount as diff_amount
FROM transactions) as a  
where extract(minute from diff_time) <10
and diff_amount = 0

/* bai 7: write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.*/

select category, product, total_spend from
(select category, product,
sum(spend) as total_spend,
rank() over (partition by category order by sum(spend) desc) as rank
from product_spend
where extract(year from transaction_date)= 2022
group by category, product) as a  
where rank <=2

/* bai 8: Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. Display the top 5 artist names in ascending order, along with their song appearance ranking.*/

select artist_name, artist_rank 
from 
(select artist_name, count(*),
dense_rank() over (order by count(*) desc) as artist_rank
from 
(SELECT a.artist_name, c.rank
FROM artists a inner join songs b on a.artist_id=b.artist_id
join global_song_rank c on b.song_id=c.song_id) as a1
where rank <=10
group by artist_name) as a2
where artist_rank <=5























