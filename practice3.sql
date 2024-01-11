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

/* bai 4: 
