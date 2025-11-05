# Solving 15 Business Problems using Postgresql on Netflix

![Netflix Logo](https://github.com/najirh/netflix_sql_project/raw/main/logo.png)

<h3><b><i>OverView</i></b></h3>
||||||||||||||||||||||||||
<p>
  This Repository involves comprehensive Data Analysis and solving Real- world Business problems using Postgresql . 
  It's an Intermediate level Project for polishing the both Analytical and Technical Skills in Entertainment Domain.
  The Following Readme file contains the questions with sql solution and conclusions to particular problems.
</p>

<h3><i>Objectives</i></h3>
||||||||||||||||||||||||||
<p>
1. Analyze the distribution of content types (movies vs TV shows).
2. Identify the most common ratings for movies and TV shows.
3. List and analyze content based on release years, countries, and durations.
4. Explore and categorize content based on specific criteria and keywords.
</p>

<h3><i>Dataset Schema Design</i></h3>
||||||||||||||||||||||||||

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


