-- Netflix MP: Creating the main table to store Netflix dataset information
-- Columns:
-- show_id      : Unique identifier for each show
-- type         : Type of content ('Movie' or 'TV Show')
-- title        : Title of the show
-- director     : Director(s) of the show (comma-separated if multiple)
-- casts        : Cast/actors of the show (comma-separated)
-- country      : Country or countries where the show was produced
-- date_added   : Date the show was added to Netflix
-- release_year : Year the show was released
-- rating       : Content rating (e.g., PG, TV-MA)
-- duration     : Duration of the show (minutes for movies, seasons for TV shows)
-- listed_in    : Genre(s) of the show (comma-separated)
-- description  : Brief description or synopsis of the show
CREATE TABLE netflix (
    show_id VARCHAR(6),
    type VARCHAR(10),    
    title VARCHAR(150),
    director VARCHAR(208),
    casts VARCHAR(1000),    
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix; --see the data

 SELECT COUNT(*) as total_content
 FROM netflix; --to the the total count of the data to verify weather it is imported correctly or not
 SELECT DISTINCT type from netflix; --show all unique values present in the column type of the netflix table.

 SELECT * FROM netflix;--making analysis..analyse the data carefully

  --Some business problems...>
  --Q1. Count the Number of Movies vs TV Shows

  
SELECT * FROM netflix; --see the data once
  
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1; --WRITING 1 EQUIVALENT TO  TYPE AS 	it indicates the 1st column.
  --question 1 completed...>


--Q2. Find the Most Common Rating for Movies and TV Shows
--TYPE 1
--GROUP BY version → shows the full breakdown of all ratings per type.
SELECT * FROM netflix;


SELECT 
    type,
    rating,
    COUNT(*) AS total
FROM netflix
GROUP BY type, rating
ORDER BY type, total DESC;

 


 --TYPE 2
  --gives all ratings with rank numbers.
SELECT 
    type,
    rating,
    COUNT(*) AS total,
    RANK() OVER (
        PARTITION BY type 
        ORDER BY COUNT(*) DESC
    ) AS ranking
FROM netflix
GROUP BY type, rating
ORDER BY type, total DESC;  

--TYPE 3
--by subquerry
SELECT *
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS total,
        RANK() OVER (
            PARTITION BY type 
            ORDER BY COUNT(*) DESC
        ) AS ranking
    FROM netflix
    GROUP BY type, rating
) t1
WHERE ranking = 1;

--TYPE 4	
--CTE version → only the top rating(s) per type.
--gives only the most frequent rating(s) per type.
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;	

--Q3. List All Movies Released in a Specific Year (e.g., 2021)


SELECT * FROM netflix
where release_year=2021;


--VARIENT...
--Small improvement (if you only want Movies, not TV Shows)
SELECT *
FROM netflix
WHERE release_year = 2021
  AND type = 'Movie';


  --(if you want specific columns)
SELECT show_id, title, director, country, rating
FROM netflix
WHERE release_year = 2021
  AND type = 'Movie';

--Q4. Find the Top 5 Countries with the Most Content on Netflix

--query 1)If you just want a quick count, use Query 1.
select country ,

count(*) as cnt
from netflix
GROUP BY country
ORDER BY country DESC
LIMIT 5;

--query 2) If you want a proper analysis by real countries, use Query 2.

SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--Q5. Identify the Longest Movie
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;





--Q6. Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--Q7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';




--advance querry
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';


--Q8. List All TV Shows with More Than 5 Seasons


SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


  --Q9. Count the Number of Content Items in Each Genre
  SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


--Q10.Find each year and the average numbers of content release in India on netflix.
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- (optional advanced): Show year + average side by side
SELECT 
    release_year,
    COUNT(*) AS total_content,
    AVG(COUNT(*)) OVER () AS avg_content_per_year
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY release_year;


--Q11. List All Movies that are Documentaries

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND listed_in LIKE '%Documentaries%';

  --Q12. Find All Content Without a Director
  SELECT * 
FROM netflix
WHERE director IS NULL;

--Q13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

  --Q14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
  SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--Q15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 


SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE
            WHEN title ILIKE '%kill%' 
              OR description ILIKE '%kill%'
              OR title ILIKE '%violence%'
              OR description ILIKE '%violence%'
            THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

--another approach (Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords)
SELECT 
    show_id,
    title,
    CASE
        WHEN title ILIKE '%kill%' 
          OR description ILIKE '%kill%'
          OR title ILIKE '%violence%'
          OR description ILIKE '%violence%'
        THEN 'Contains Violence/Kill'
        ELSE 'Other'
    END AS category
FROM netflix;


