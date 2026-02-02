-- Data Cleaning
SELECT *
FROM netflix_titles;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove any columns

#Creating new table for changes:
CREATE TABLE netflix_stating
LIKE netflix_titles;     

SELECT *
FROM netflix_stating;

INSERT netflix_stating
SELECT *
FROM netflix_titles;      

-- 

#Removing duplicates:
SELECT *,
ROW_NUMBER() OVER(PARTITION BY show_id, type, director, cast, country, date_added, release_year, rating, duration, listed_in, description) as row_num
FROM netflix_stating;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY show_id, type, director, cast, country, date_added, release_year, rating, duration, listed_in, description) as row_num
FROM netflix_stating
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

#There is no duplicated data in the table.

-- 

#Standardize the data (finding issues and fixing it):
SELECT *
FROM netflix_stating;

SELECT DISTINCT(type)
FROM netflix_stating;

SELECT DISTINCT(title)
FROM netflix_stating;

SELECT DISTINCT(director)
FROM netflix_stating;

SELECT DISTINCT(cast)
FROM netflix_stating;

SELECT DISTINCT(country)
FROM netflix_stating
ORDER BY 1;

SELECT DISTINCT country
FROM netflix_stating
WHERE country LIKE ', %';    

#Two of the country names started with a comma, so the leading comma and space were removed.
UPDATE netflix_stating
SET country = TRIM(LEADING ', ' FROM country)
WHERE country LIKE ', %';

SELECT DISTINCT(date_added)
FROM netflix_stating;

SELECT DISTINCT(release_year)
FROM netflix_stating;

SELECT DISTINCT(rating)
FROM netflix_stating;

SELECT DISTINCT(duration)
FROM netflix_stating;

SELECT DISTINCT(listed_in)
FROM netflix_stating;

SELECT DISTINCT(description)
FROM netflix_stating;

#Separating the `date_added` variable by day, month, and year:
ALTER TABLE netflix_stating
ADD COLUMN added_year INT;

UPDATE netflix_stating
SET added_year = RIGHT(date_added, 4)
WHERE date_added IS NOT NULL;

#It gave an error on line 6067, so I checked the error. The error was the blank value in that line so I started to remove blank values
SELECT date_added
FROM netflix_stating
WHERE show_id = 's6066' or show_id = 's6067';   

-- 

#Variables containing null or blank values:
SELECT *
from netflix_stating
WHERE director IS NULL
OR director = '';

SELECT *
from netflix_stating
WHERE cast IS NULL
OR cast = '';

SELECT *
from netflix_stating
WHERE country IS NULL
OR country = '';

SELECT *
from netflix_stating
WHERE date_added IS NULL
OR date_added = '';

SELECT *
from netflix_stating
WHERE rating IS NULL
OR rating = '';

SELECT *
from netflix_stating
WHERE duration IS NULL
OR duration = '';

SELECT *
from netflix_stating;

-- To make blank values NULL:
UPDATE netflix_stating
SET director = NULL
WHERE TRIM(director) = '';      

SELECT *
from netflix_stating;       #check

DELETE FROM netflix_stating     
WHERE director IS NULL;     #removing null values

SELECT *
from netflix_stating
WHERE director IS NULL
OR director = '';        #check

--

UPDATE netflix_stating
SET cast = NULL
WHERE TRIM(cast) = '';

DELETE FROM netflix_stating     
WHERE cast IS NULL;

SELECT *
from netflix_stating
WHERE cast IS NULL
OR cast = '';

--

UPDATE netflix_stating
SET country = NULL
WHERE TRIM(country) = '';

SELECT *
from netflix_stating;

DELETE FROM netflix_stating     
WHERE country IS NULL;

SELECT *
from netflix_stating
WHERE country IS NULL
OR country = '';

-- 

UPDATE netflix_stating
SET date_added = NULL
WHERE TRIM(date_added) = '';

SELECT *
from netflix_stating;

DELETE FROM netflix_stating     
WHERE date_added IS NULL;

SELECT *
from netflix_stating
WHERE date_added IS NULL
OR date_added = '';

--

UPDATE netflix_stating
SET rating = NULL
WHERE TRIM(rating) = '';

SELECT *
from netflix_stating;

DELETE FROM netflix_stating     
WHERE rating IS NULL;

SELECT *
from netflix_stating
WHERE rating IS NULL
OR rating = '';

--

UPDATE netflix_stating
SET duration = NULL
WHERE TRIM(duration) = '';

SELECT *
from netflix_stating;

DELETE FROM netflix_stating    
WHERE duration IS NULL;

SELECT *
from netflix_stating
WHERE duration IS NULL
OR duration = '';

-- 
#Adding year column:
UPDATE netflix_stating
SET added_year = RIGHT(date_added, 4)
WHERE date_added IS NOT NULL;            

SELECT DISTINCT added_year
FROM netflix_stating
ORDER BY 1;

#Adding month column:
ALTER TABLE netflix_stating
ADD COLUMN added_month VARCHAR(20);     
  
UPDATE netflix_stating
SET added_month = TRIM(
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(date_added, ',', 1),
        ' ',
        1
    )
)
WHERE date_added IS NOT NULL
  AND TRIM(date_added) <> '';

SELECT DISTINCT added_month
FROM netflix_stating
ORDER BY 1;

UPDATE netflix_stating
SET added_month = NULL
WHERE TRIM(added_month) = '';

DELETE FROM netflix_stating
WHERE added_month IS NULL;
 
--

#Separating the duration variable into two columns based on duration and min/season:
SELECT DISTINCT duration
FROM netflix_stating;

ALTER TABLE netflix_stating
ADD COLUMN duration_value INT,
ADD COLUMN duration_unit VARCHAR(10);

UPDATE netflix_stating
SET duration_value = CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)
WHERE duration IS NOT NULL;

UPDATE netflix_stating
SET duration_unit =
    CASE
        WHEN duration LIKE '%min%' THEN 'min'
        WHEN duration LIKE '%season%' THEN 'seasons'
    END
WHERE duration IS NOT NULL;

SELECT duration, duration_value, duration_unit
FROM netflix_stating;

SELECT *
FROM netflix_stating;
