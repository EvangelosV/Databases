/*1*/
SELECT DISTINCT YEAR(m.release_date) AS year, COUNT(m.id) AS movies_per_year
FROM movie m
GROUP BY m.release_date, m.budget
HAVING m.budget > 1000000
ORDER BY movies_per_year DESC

/*2*/
SELECT g.name, COUNT(*) AS movies_per_genre
FROM movie m
JOIN hasGenre hg ON hg.movie_id = m.id
JOIN genre g ON g.id = hg.genre_id
WHERE budget > 1000000 OR runtime > 120
GROUP BY g.name
ORDER BY movies_per_genre DESC;

/*3*/
SELECT DISTINCT g.name AS genre, YEAR(m.release_date) AS year, COUNT(m.id) AS movies_per_gy
FROM movie m
JOIN hasGenre hg ON hg.movie_id = m.id
JOIN genre g ON g.id = hg.genre_id
GROUP BY g.name, m.release_date
ORDER BY g.name, year

/*4*/
SELECT YEAR(m.release_date) AS year, SUM(m.revenue) AS revenues_per_year
FROM movie m
JOIN movie_cast mc ON m.id = mc.movie_id
WHERE mc.name = 'Denzel Washington'
GROUP BY YEAR(m.release_date)
ORDER BY year;

/*5*/
SELECT YEAR(m.release_date) as year, MAX(m.budget) AS max_budget
FROM movie m
WHERE m.budget > 0
GROUP BY YEAR(m.release_date)
ORDER BY year;

/*6*/
SELECT c.name AS trilogy_name
FROM collection c
JOIN belongsTocollection bg ON bg.collection_id = c.id
JOIN movie m ON bg.movie_id = m.id
GROUP BY c.id, c.name
HAVING COUNT(m.id) = 3;

/*7*/
SELECT r.user_id, AVG(r.rating) AS avg_rating, COUNT(r.rating) AS rating_count
FROM ratings r
GROUP BY r.user_id
ORDER BY rating_count DESC

/*8*/
SELECT TOP 10 title AS movie_title, budget
FROM movie
ORDER BY budget DESC, title ASC;

/*9*/
SELECT YEAR(m.release_date) as year, m.title AS movie_with_max_budget
FROM movie m
JOIN (
    SELECT YEAR(m.release_date) as year, MAX(m.budget) AS max_budget
    FROM movie m
    WHERE m.budget > 0
    GROUP BY YEAR(m.release_date)
) AS max_budgets
ON YEAR(m.release_date) = max_budgets.year AND m.budget = max_budgets.max_budget
ORDER BY year, m.title

/*10*/
SELECT LEFT(mc.name, CHARINDEX(' ', mc.name) - 1) AS name, 
RIGHT(mc.name, LEN(mc.name) - CHARINDEX(' ', mc.name)) AS surname
FROM movie_crew mc
JOIN movie m ON mc.movie_id = m.id
JOIN hasGenre hg ON hg.movie_id = m.id
JOIN genre g ON hg.genre_id = g.id
WHERE mc.job = 'Director'
GROUP BY mc.name
HAVING COUNT(DISTINCT CASE WHEN g.name = 'Horror' THEN g.name END) > 0
AND COUNT(DISTINCT CASE WHEN g.name = 'Comedy' THEN g.name END) > 0
AND COUNT(DISTINCT g.name) = 2;

/*11*/
WITH Directors AS (
    SELECT DISTINCT mc.name
    FROM movie_crew mc
    JOIN hasGenre hg ON mc.movie_id = hg.movie_id
    JOIN genre g ON hg.genre_id = g.id
    WHERE mc.job = 'Director' AND g.name = 'Horror'
    INTERSECT
    SELECT DISTINCT mc.name
    FROM movie_crew mc
    JOIN hasGenre hg ON mc.movie_id = hg.movie_id
    JOIN genre g ON hg.genre_id = g.id
    WHERE mc.job = 'Director' AND g.name = 'Comedy'
    EXCEPT
    SELECT DISTINCT mc.name
    FROM movie_crew mc
    JOIN hasGenre hg ON mc.movie_id = hg.movie_id
    JOIN genre g ON hg.genre_id = g.id
    WHERE mc.job = 'Director' AND g.name NOT IN ('Horror', 'Comedy')
) SELECT LEFT(d.name, CHARINDEX(' ', d.name) - 1) AS name, 
RIGHT(d.name, LEN(d.name) - CHARINDEX(' ', d.name)) AS surname
FROM Directors d
ORDER BY d.name;

/*12*/
CREATE VIEW Popular_Movie_Pairs AS
SELECT r1.movie_id AS id1, r2.movie_id AS id2
FROM ratings r1
JOIN ratings r2 ON r1.user_id = r2.user_id AND r1.movie_id NOT LIKE r2.movie_id
WHERE r1.rating > 4 AND r2.rating > 4
GROUP BY r1.movie_id, r2.movie_id
HAVING COUNT(r1.user_id) > 10;