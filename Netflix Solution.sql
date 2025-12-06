drop table if exists netflix;
create table netflix(
show_id	varchar(6),
type varchar(10),
title varchar(150),
director varchar(250),
casts varchar(900)	,
country varchar(150),
date_added varchar(50),	
release_year Int,
rating varchar(10),
duration varchar(15),	
listed_in varchar(100),
description varchar(250)
);
select * from netflix;

select count(*) as total_contents from netflix;

--1. TV shows Vs Movies
select distinct type,count(type) as total from netflix group by type;

--2. Most common Rating
select type,rating from(select type,rating,row_number()over(partition by type order by count(*) desc)as rn from netflix group by 1,2) as t where rn=1;

--3.List all movies released in specific year(2020)
select title from netflix where type='Movie' and release_year=2020;

--4. Top 5 countries with most content on netflix
select distinct trim(unnest(string_to_array(country,',')))as countries,count(show_id)as total_count
from netflix 
group by countries
order by total_count desc
limit 5;

--5. Longest movie
SELECT *
FROM netflix
WHERE CAST(REPLACE(duration, 'min', '') AS INTEGER) = (
      SELECT MAX(CAST(REPLACE(duration, 'min', '') AS INTEGER))
      FROM netflix where type='Movie'
) and type='Movie';

--6. find content added in the last 5 years
select * from netflix
where to_date(date_added,'Month DD,YYYY')>=current_date-interval '5years';

--7. find movies/Tv shows by director 'Rajiv chilaka'
Select * from netflix where director like'%Rajiv Chilaka%';


--8.list all tv shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show' AND CAST(REPLACE(REPLACE(duration, 'Seasons', ''), 'Season', '') AS INTEGER) > 5;

select * from netflix where type='TV Show' and split_part(duration,' ',1)::numeric>5;

--9.content in each genre
select distinct trim(unnest(string_to_array(listed_in,',')))as genre,count(*)as total 
from netflix
group by genre
order by total desc;

--10. Average release per year for india 
select extract(year from to_date(date_added,'Month DD,YYYY'))as year,
count(*),round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric *100,0)as Average_per_year
from netflix
where country='India'
group by 1
order by average_per_year desc;

--11. List all movies as documentries
select * from netflix where listed_in like'%Documentaries%' and type='Movie';

--12.Find content with Director
select * from netflix where (director is null) or (director=' ')or director='N/A';

--13.How many movies did salman khan act in the last 10 years

select * from netflix where casts ilike'%Salman Khan%' and release_year>=extract(Year from current_date)-10;

--14.Top 10 actors in most number of movies  produced in india
select distinct(trim(unnest(string_to_array(casts,','))))as actors,count(*)as total_movies
from netflix
where country ilike'India' and type='Movie'
group by actors
order by total_movies desc
limit 10;

--15. categorise the content with respect to word 'kill' and 'violence' in their description as good or bad and then find the total number of good and bad movies.

with cte as(select *, case 
when description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
else 'Good_content' end as category from netflix)
select category,count(*) from cte
group by 1;