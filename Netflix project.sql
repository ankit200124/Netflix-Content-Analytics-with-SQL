--Netflix Project
create table netflix(
show_id Varchar(6),
type varchar(10),
title varchar(140),
director varchar(210),
casts varchar(1000),
country	varchar(150),
date_added varchar(50),
release_year int,
rating	varchar(10),
duration varchar(50),
listed_in varchar(100),
description varchar(260)
);
select * from netflix;

drop table if exists netflix;


select count(*) as total_content
from netflix;

select distinct type
from netflix;

select * from netflix

-- 1 Count the number of Movies vs TV Shows
 select type, count(*) as total_content
 from netflix
 group by type


--2. Find the most common rating for movies and TV shows
select type,rating from
(
select type,rating,count(*), rank() over(partition by type order by count(*)desc) as ranking
from netflix
group by 1,2 ) as t1
where ranking =1

--3. List all movies released in a specific year (e.g., 2020)\
 select* from netflix
 where
 type ='Movie'
 and
 release_year = 2020



--4. Find the top 5 countries with the most content on Netflix
 select 
   unnest(string_to_array(country,',')) as new_country ,
   count(show_id) as total_content
 from netflix
 group by 1
order by 2 desc
limit 5

--5. Identify the longest movie

select* from netflix
where 
type= 'Movie'
and
duration = (select max(duration)from netflix)


--6. Find content added in the last 5 years


SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

 
--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director ilike '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons

select *
from netflix
where 
   type = 'TV Show'
   and
   SPLIT_PART(duration, ' ',1)::numeric > 5 


9. Count the number of content items in each genre

select 
	   unnest(String_to_array(listed_in,',')) as genre,
	   count(show_id) as total_content
	   from netflix
	   group by 1



--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
	(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100,2)
		
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5




--11. List all movies that are documentaries

select * from netflix
where
listed_in ilike '%documentaries%'



--12. Find all content without a director


select * from netflix
where
director IS NULL



---13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where
casts ilike '%salman khan%'
and
release_year > Extract(year from current_date) - 10


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 

unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10



--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.--
with new_table
as(
select * ,
case
when description Ilike '%kill%' or
description Ilike '%violence%' then 'BAD_CONTENT'
else 'GOOD_CONTENT'
end category 
from netflix
)
select category ,
count(*) as total_content
from new_table
group by 1