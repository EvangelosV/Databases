SELECT person_id
FROM Person
GROUP BY person_id
HAVING COUNT(DISTINCT name) > 1 OR COUNT(DISTINCT gender) > 1;
/* MANUALLY FIXING THE INCONSISTENCIES (FROM THE PERSON_IDs ABOVE)*/
UPDATE movie_cast
SET name = 'Miles Malleson' , gender = 2
WHERE person_id = 47395;
UPDATE movie_crew
SET name = 'Miles Malleson' , gender = 2
WHERE person_id = 47395;

UPDATE movie_cast
SET name = 'Peter Malota' , gender = 2
WHERE person_id = 1785844;
UPDATE movie_crew
SET name = 'Peter Malota' , gender = 2
WHERE person_id = 1785844;

UPDATE movie_crew
SET name = 'Ka-Fai Cheung' , gender = 2
WHERE person_id = 63574;
UPDATE movie_cast
SET name = 'Ka-Fai Cheung' , gender = 2
WHERE person_id = 63574;