# Solving 15 Business Problems using Postgresql on Netflix

![Netflix Logo](https://github.com/najirh/netflix_sql_project/raw/main/logo.png)

<h3><b><i>OverView</i></b></h3>
||||||||||||||||||||||||||||||||||||||||||||||||||||
<p>
  This Repository involves comprehensive Data Analysis and solving Real- world Business problems using Postgresql . 
  It's an Intermediate level Project for polishing the both Analytical and Technical Skills in Entertainment Domain.
  The Following Readme file contains the questions with sql solution and conclusions to particular problems.
</p>

<h3><i>Objectives</i></h3>
||||||||||||||||||||||||||||||||||||||||||||||||||||
<p>
1. Analyze the distribution of content types (movies vs TV shows).<br>
2. Identify the most common ratings for movies and TV shows.<br>
3. List and analyze content based on release years, countries, and durations.<br>
4. Explore and categorize content based on specific criteria and keywords.<br>
</p>

<h3><i>Dataset Schema Design</i></h3>
||||||||||||||||||||||||||||||||||||||||||||||||||||
<br>

```sql
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
```

<h3><i>Business Problems </i></h3>

<h4> 1. Count the No. of TV shows and Movies </h4>

```sql
SELECT type,COUNT(*) FROM netflix 
GROUP BY type;
```

<h4>2. Finding the most common rating for movies and tv shows  </h4>

```sql
SELECT type,rating 
FROM 
(SELECT type,rating,COUNT(*) AS frequency ,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) AS rankings
FROM netflix 
GROUP BY type,rating
ORDER BY 1,3 DESC) 
WHERE rankings = 1
```

<h4> 3. List all the movies released in a specific year (eg. 2020)  </h4>

```sql
SELECT * 
FROM netflix
WHERE release_year=2020 AND type='Movie';
```

<h4> 4. Find the top 5 countries with the most content on Netflix  </h4>

```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS countries ,  COUNT(*)
FROM netflix
GROUP BY countries
ORDER BY COUNT(*) DESC 
LIMIT 5;
```

<h4>5 Identify the longest movie  </h4>

```sql
SELECT * FROM netflix
WHERE duration=CONCAT(
(SELECT MAX(REPLACE(duration , 'min',''):: INT) FROM netflix
WHERE type='Movie'),' min') ;
```

<h4> 6. Find the content added in the last 5 Years </h4>

```sql
SELECT * FROM netflix 
WHERE TO_DATE(date_added,'Month DD,YYYY')>=CURRENT_DATE - INTERVAL '5 years';
```

<h4> 7. Find all the movies/TV shows by director 'Rajiv Chilaka' </h4>

```sql
SELECT * FROM netflix
WHERE  director ILIKE '%rajiv chilaka%';

```

<h4>8. List all the TV shows with more than 5 Seasons  </h4>

```sql
SELECT DISTINCT * FROM netflix 
WHERE type='TV Show'
AND 
SPLIT_PART(duration,' ',1)::INT>5
```

<h4> 9. Count the Number of content items in each Genre.  </h4>

```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY( listed_in,','))) as genre ,COUNT(show_id) FROM netflix
GROUP BY genre;
```

<h4> 10. Find each year and the average numbers of content release by India on Netflix return top 5 year with Highest avg content release from netflix; </h4>

```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as years,
--COUNT(show_id) AS Num_releases,
ROUND(COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country='India')::NUMERIC*100) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY years
ORDER BY 2 DESC
```

<h4> 11. List all the movies that are documentaries  </h4>

```sql
SELECT * FROM netflix 
WHERE listed_in ILIKE '%Documentaries%';
```

<h4> 12. Find all content without a director  </h4>

```sql
ELECT * FROM netflix 
WHERE director IS NULL;
```


<h4> 13. Find how many movies actor 'Salman Khan' appeared in last 10 Years </h4>

```sql

SELECT * FROM netflix 
WHERE casts ILIKE '%salman khan%'
AND 
release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;
```

<h4> 14. Find the top 10 actors who have appeared in the highest number of movies produced in India  </h4>

```sql
SELECT TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS actors, COUNT(*) FROM netflix 
WHERE country ILIKE '%India%'
GROUP BY actors 
ORDER BY 2 DESC 
LIMIT 10;
```

<h4> 15 Categorize content based on the presence of  keywords like 'kill' & 'violence' in the description, label content as 'Bad' otherwise 'Good' . Count how many items fall in each category
 </h4>

```sql
SELECT remark , COUNT(*) FROM 
(SELECT *,
CASE 
WHEN description ILIKE '%kill%' OR 
description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good' 
END remark
FROM netflix)
GROUP BY 1 ;
```

<h3><i>Author</i></h3>
<b>Name :- Aryan Singh</b>
<b> Linkedin :- https://www.linkedin.com/in/aryan-singh-b91248331/</b>
<b> Kaggle :- https://www.kaggle.com/datawitharyan</b>
