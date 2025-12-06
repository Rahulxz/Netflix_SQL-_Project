# Netflix_SQL-_Project
## Problem Statement

Netflix hosts thousands of movies and TV shows from different countries, genres, and time periods.
However, the raw dataset contains:

**Unstructured columns** (e.g., multiple countries/genres in a single field)

**Inconsistent date formats**

**Mixed data types** (e.g., "90 min", "2 Seasons")

**Missing and ambiguous values**

**Text fields requiring cleaning and classification**

## Objective

The goal of this project is to use SQL to clean, transform, and analyze the Netflix dataset to answer key business questions, including:

1.What is the distribution between Movies vs. TV Shows?

2.What ratings are most common for each type of content?

3.Which countries contribute the most content?

4.What are the longest movies and highest-season TV shows?

5.How has Netflix’s content library grown in the last 5 years?

6.Which actors and directors appear most frequently?

7.How can we categorize content based on keywords like violence or kill?

8.What genres dominate the platform?

This project demonstrates how SQL can be used to generate valuable insights from real-world messy data.

 ## Dataset Description

The dataset stored in the netflix table includes the following key fields:


Netflix Solution

**show_id –** Unique identifier

**type –** Movie or TV Show

**title –** Name of the content

**director / casts –** People involved

**country –** Production country

**date_added –** When it was added to Netflix

**release_year –** Year of release

**rating –** Content rating (PG, TV-MA, etc.)

**duration –** Movie runtime or number of seasons

**listed_in –** Genres

**description –** Content summary

## 🛠️ Technologies Used

PostgreSQL

SQL Functions:

Window Functions (ROW_NUMBER)

String Functions (REPLACE, SPLIT_PART, string_to_array, unnest)

Date Functions (TO_DATE, EXTRACT)

Aggregation & Grouping

Common Table Expressions (CTEs)

## 📌 Key Analyses Performed

1️⃣ Movie vs TV Show Distribution

Compare total volumes by content type.
``` sql
select distinct type,count(type) as total from netflix group by type;
```
2️⃣ Most Common Rating per Content Type

Use window functions to identify top ratings.
```sql
select type,rating from(select type,rating,row_number()over(partition by type order by count(*) desc)as rn from netflix group by 1,2) as t where rn=1;
```

3️⃣ Movies Released in a Specific Year

Filter records for year-wise analysis.
```sql
select title from netflix where type='Movie' and release_year=2020;
```

4️⃣ Top 5 Countries with the Most Content

Normalize the country field using unnest(string_to_array(...)).
```sql
select distinct trim(unnest(string_to_array(country,',')))as countries,count(show_id)as total_count
from netflix 
group by countries
order by total_count desc
limit 5;
```

5️⃣ Longest Movie on Netflix

Extract numeric duration using REPLACE() and find the maximum.
```sql
SELECT *
FROM netflix
WHERE CAST(REPLACE(duration, 'min', '') AS INTEGER) = (
      SELECT MAX(CAST(REPLACE(duration, 'min', '') AS INTEGER))
      FROM netflix where type='Movie'
) and type='Movie';
```

6️⃣ Content Added in the Last 5 Years

Convert string dates using to_date() and filter recent content.
```sql
select * from netflix
where to_date(date_added,'Month DD,YYYY')>=current_date-interval '5years';
```

7️⃣ Content Directed by ‘Rajiv Chilaka’

String search on director column.
```sql
Select * from netflix where director ilike'%Rajiv Chilaka%';
```

8️⃣ TV Shows with More Than 5 Seasons

Extract season count and filter shows.
Method 1:
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show' AND CAST(REPLACE(REPLACE(duration, 'Seasons', ''), 'Season', '') AS INTEGER) > 5;
```
method 2:
```sql
select * from netflix where type='TV Show' and split_part(duration,' ',1)::numeric>5;
```

9️⃣ Content Distribution by Genre

Split multi-genre fields and count each occurrence.
```sql
select distinct trim(unnest(string_to_array(listed_in,',')))as genre,count(*)as total 
from netflix
group by genre
order by total desc;
```

🔟 Year-wise Growth of Indian Content

Measure content growth and compute percentage contributions.
```sql
select extract(year from to_date(date_added,'Month DD,YYYY'))as year,
count(*),round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100,0)as Average_per_year
from netflix
where country='India'
group by 1
order by average_per_year desc;
```

1️⃣1️⃣ Documentary Movies

Filter titles tagged as documentaries.
```sql
select * from netflix where listed_in like'%Documentaries%' and type='Movie';
```

1️⃣2️⃣ Content Missing Director Information

Identify incomplete metadata.
```sql
select * from netflix where (director is null) or (director=' ')or director='N/A';
```

1️⃣3️⃣ Salman Khan Movies in the Last 10 Years

Use ILIKE for actor search and filter recent years.
```sql
select * from netflix where casts ilike'%Salman Khan%' and release_year>=extract(Year from current_date)-10;
```

1️⃣4️⃣ Top 10 Actors in India-Produced Movies

Unnest cast names and count occurrences.
```sql
select distinct(trim(unnest(string_to_array(casts,','))))as actors,count(*)as total_movies
from netflix
where country ilike'India' and type='Movie'
group by actors
order by total_movies desc
limit 10;
```

1️⃣5️⃣ Classify Content as 'Good' or 'Bad' Based on Keywords

CTE that labels content referencing 'kill' or 'violence'.
```sql
with cte as(select *, case 
when description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
else 'Good_content' end as category from netflix)
select category,count(*) from cte
group by 1;
```

## **Insights Gained**

Movies dominate Netflix’s library compared to TV Shows.

"TV-MA" and "R" are among the most common content ratings.

The United States and India are leading contributors of Netflix content.

Highly seasonal shows (5+ seasons) are relatively rare.

Documentary and drama categories appear frequently.

Certain actors and directors appear in significantly higher volumes.

Keyword-based classification helps identify content themes.
