![netflix logo](https://github.com/user-attachments/assets/da908f70-d3d6-4e53-874a-1e642c5157d6)


# Netflix-Content-Analytics-with-SQL
A comprehensive SQL-driven analysis of Netflix’s content catalog, focusing on uncovering trends and patterns across movies and TV shows. The project demonstrates practical business problem-solving using advanced querying techniques and data visualization.

# Objectives
The project aims to examine key aspects of Netflix content such as types (movies vs. shows), release timing, regional distribution, rating trends, genre popularity, and content tagging strategies—ultimately to inform content strategy and programming.

# Dataset
Data is sourced from a public Netflix dataset with thousands of records detailing show metadata including type, rating, release year, genres, and more. The dataset is structured using PostgreSQL-compatible schema definitions.

# Schema
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

# Business Problems and Solutions

### 1 Count the Number of Movies vs TV Shows
   ```
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;
```

2. Find the Most Common Rating for Movies and TV Shows
SELECT type, rating
FROM (
  SELECT type, rating, COUNT(*),
         RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY 1, 2
) AS t1
WHERE ranking = 1;

3. List all Movies released in the year 2020

SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;

4. Find the top 5 countries with the most content on Netflix

SELECT 
  UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

5. Identify the longest Movie on Netflix

SELECT * 
FROM netflix
WHERE type = 'Movie'
  AND duration = (SELECT MAX(duration) FROM netflix);

6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

7.  Find all content directed by Rajiv Chilaka

SELECT * 
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

8. List all TV Shows with more than 5 seasons

SELECT * 
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::NUMERIC > 5;

9. Count the number of content items in each genre

SELECT 
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
  COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

10. Find top 5 years with highest average content release in India

SELECT 
  country,
  release_year,
  COUNT(show_id) AS total_release,
  ROUND(
    COUNT(show_id)::NUMERIC /
    (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::NUMERIC * 100, 2
  ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, 2
ORDER BY avg_release DESC
LIMIT 5;

11. List all Movies that are Documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

12. Find all content without a director

SELECT * 
FROM netflix
WHERE director IS NULL;

13. Find how many Movies Salman Khan appeared in the last 10 years

SELECT * 
FROM netflix
WHERE casts ILIKE '%salman khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. Find the top 10 actors with the most appearances in Indian content

SELECT 
  UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
  COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

15. Categorize content as ‘Bad’ if description contains 'kill' or 'violence', else ‘Good’

WITH new_table AS (
  SELECT *, 
         CASE
           WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' 
           THEN 'BAD_CONTENT'
           ELSE 'GOOD_CONTENT'
         END AS category
  FROM netflix
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY 1;

# Findings & Outcome
Using structured SQL queries, the project answers 15 key business questions that reflect how Netflix's content is distributed and consumed. It reveals patterns like the dominance of movies over TV shows, the most common age ratings, countries with the highest content availability, and trends in genre and actor appearances. It also demonstrates how to work with missing data, use advanced SQL functions like CTEs and window functions, and apply string manipulation for better classification and segmentation.

# Conclusion
This project showcases practical SQL skills applied to a real-world dataset. It helped strengthen understanding of filtering, aggregation, subqueries, and data classification techniques. The insights extracted from the Netflix dataset can support better decision-making in content planning, audience targeting, and regional strategies.



