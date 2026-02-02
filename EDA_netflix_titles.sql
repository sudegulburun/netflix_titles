-- Exploratory Data Analysis
SELECT * 
FROM netflix_stating;

-- 1. Overview

# Total number of items:
SELECT COUNT(*) as total_titles
FROM netflix_stating;

# Movie vs TV Show distribution:
SELECT type, COUNT(*) as content_count
FROM netflix_stating
GROUP BY type;

# Rating Distribution:
SELECT rating, COUNT(*) as content_count
FROM netflix_stating
GROUP BY rating
ORDER BY content_count DESC;

-- 2. Time Analysis

# Number of contents published by year:
SELECT release_year, COUNT(*) as content_count
FROM netflix_stating
GROUP BY release_year
ORDER BY release_year;

# Distribution of movies & series by year:
SELECT release_year, type, COUNT(*) as content_count
FROM netflix_stating
GROUP BY release_year, type
ORDER BY release_year;

-- 3. Country Analysis

# Number of contents by country:
SELECT country, COUNT(*) as content_count
FROM netflix_stating
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count; 

# Top 10 content-producing country:
SELECT country, COUNT(*) as content_count
FROM netflix_stating
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count desc
LIMIT 10; 

-- 4. Genre Analysis

# Number of contents by genre:
SELECT listed_in as genre, COUNT(*) as content_count
FROM netflix_stating
GROUP BY listed_in
ORDER BY content_count DESC;

# Genre distribution on a movie and series basis:
SELECT listed_in as genre, type,  COUNT(*) as content_count
FROM netflix_stating
GROUP BY listed_in, type
ORDER BY content_count DESC;

-- 5. Duration Analysis

# Average movie duration:
SELECT ROUND(AVG(duration_value), 2) as avg_movie_duration
FROM netflix_stating
WHERE type = "Movie";

# Film runtime distribution:
SELECT duration_value as movie_duration, type, COUNT(*) AS movie_count
FROM netflix_stating
WHERE type = 'Movie'
GROUP BY duration_value, type
ORDER BY movie_count DESC;

# How many seasons do the series run for?
SELECT duration, COUNT(*) as tv_show_count
FROM netflix_stating
WHERE type = "TV Show"
GROUP BY duration
ORDER BY tv_show_count DESC;

# Average number of seasons:
SELECT 
    ROUND(AVG(duration_value), 2) AS avg_seasons
FROM netflix_stating
WHERE type = 'TV Show';

-- 6. Rating & Target Audience Analysis

# Number of contents by rating:
SELECT rating, COUNT(*) as content_count
FROM netflix_stating
GROUP BY rating
ORDER BY content_count DESC;


# Rating × Content Type:
SELECT rating, type, COUNT(*) AS content_count
FROM netflix_stating
GROUP BY rating, type
ORDER BY rating;






