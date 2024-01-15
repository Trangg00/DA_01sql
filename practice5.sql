/* bai 1: query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.*/

select country.continent, floor(avg(city.population))
from country inner join city on country.code=city.countrycode
group by country.continent

/* bai 2: Write a query to find the activation rate. Round the percentage to 2 decimal places.*/

SELECT round(count(texts.email_id)/count(distinct emails.email_id),2) as confirm_rate
FROM texts inner join emails on emails.email_id=texts.email_id
where texts.signup_action = 'Confirmed'

/* bai 3: Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.*/

SELECT 
  age.age_bucket, 
  round(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'send')/
      SUM(activities.time_spent),2) AS send_perc, 
  ROUND(100.0 * 
    SUM(activities.time_spent) FILTER (WHERE activities.activity_type = 'open')/
      SUM(activities.time_spent),2) AS open_perc
FROM activities
INNER JOIN age_breakdown AS age 
  ON activities.user_id = age.user_id 
WHERE activities.activity_type IN ('send', 'open') 
GROUP BY age.age_bucket;
