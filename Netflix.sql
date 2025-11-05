-- Creating the schmea for importing the datasets

CREATE TABLE netflix(
show_id VARCHAR(6) PRIMARY KEY,
type VARCHAR(8),
title VARCHAR(110),
director VARCHAR(210),
casts VARCHAR(800),
country VARCHAR(125),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(120),
description VARCHAR(255)
);

--Overview of the Datasets 
SELECT * FROM netflix;

--Shape of the datasets 
SELECT COUNT(show_id) FROM netflix;

SELECT COUNT(*) 
FROM information_schema.columns 
WHERE table_name = 'netflix';

-- 1. Count the No. of TV shows and Movies 
SELECT type,COUNT(*) FROM netflix 
GROUP BY type;

-- 2. Finding the most common rating for movies and tv shows 

SELECT type,rating 
FROM 
(SELECT type,rating,COUNT(*) AS frequency ,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS rankings
FROM netflix 
GROUP BY type,rating
ORDER BY 1,3 DESC) 
WHERE rankings = 1

--3. List all the movies released in a specific year (eg. 2020) 
SELECT * 
FROM netflix
WHERE release_year=2020 AND type='Movie';

-- 4. Find the top 5 countries with the most content on Netflix 
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS countries ,  COUNT(*)
FROM netflix
GROUP BY countries
ORDER BY COUNT(*) DESC 
LIMIT 5;

--5 Identify the longest movie 
SELECT * FROM netflix
WHERE duration=CONCAT(
(SELECT MAX(REPLACE(duration , 'min',''):: INT) FROM netflix
WHERE type='Movie'),' min') ;

-- 6. Find the content added in the last 5 Years
SELECT * FROM netflix 
WHERE TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT * FROM netflix
WHERE  director ILIKE '%rajiv chilaka%';

--8. List all the TV shows with more than 5 Seasons 

SELECT DISTINCT * FROM netflix 
WHERE type='TV Show'
AND 
SPLIT_PART(duration,' ',1)::INT>5

-- 9. Count the Number of content items in each Genre. 

SELECT TRIM(UNNEST(STRING_TO_ARRAY( listed_in,','))) as genre ,COUNT(show_id) FROM netflix
GROUP BY genre;

-- 10. Find each year and the average numbers of content release by India on Netflix , 
-- return top 5 year with Highest avg content release 
-- select date_added from netflix;
SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as years,
--COUNT(show_id) AS Num_releases,
ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country='India')::NUMERIC*100) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY years
ORDER BY 2 DESC

-- 11. List all the movies that are documentaries 

SELECT * FROM netflix 
WHERE listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director 

SELECT * FROM netflix 
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 Years 

SELECT * FROM netflix 
WHERE casts ILIKE '%salman khan%'
AND 
release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India 

SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS actors, COUNT(*) FROM netflix 
WHERE country ILIKE '%India%'
GROUP BY actors 
ORDER BY 2 DESC 
LIMIT 10;


-- 15 Categorize the content based on the presence of the keywords like 'kill' and 'violence' in the description field,
-- label content as 'Bad' otherwise 'Good' . Count how many items fall in each category

SELECT remark , COUNT(*) FROM 
(SELECT *,
CASE 
WHEN description ILIKE '%kill%' OR 
description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good' 
END remark
FROM netflix)
GROUP BY 1 ;

