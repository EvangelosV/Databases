/* 
"Βρες μου τους τίτλους των ταινιών που έχουν ως λέξη-κλειδί την λέξη 
'mafia' και δεν είναι αγγλόφωνες, μαζί με τη γλώσσα τους."
Output: 8 rows
*/
SELECT m.title AS Movie_Title, m.original_language AS Original_Language
FROM movie m
JOIN hasKeywords hK ON m.id = hK.movie_id
JOIN keyword k ON hK.keywords = k.id
WHERE k.name LIKE 'mafia' AND m.original_language NOT LIKE 'en';


/* 
"Βρες μου τους τίτλους των ταινιών με σκηνοθέτη τον Martin Scorsese που 
κυκλοφόρησαν μεταξύ του 1985-1999, μαζί με το έτος κυκλοφορίας τους."
Output: 11 rows
*/
SELECT m.title AS Movie_Title, YEAR(m.release_date) AS Release_Year 
FROM movie m
JOIN movie_crew mc ON m.id = mc.movie_id
GROUP BY mc.name, mc.job, m.title, m.release_date
HAVING mc.job LIKE 'Director' AND mc.name LIKE 'Martin Scorsese' AND
YEAR(m.release_date) BETWEEN 1985 AND 1999
ORDER BY m.release_date 


/* 
"Βρες μου τους τίτλους των ταινιών που η μέση βαθμολογία τους ξεπερνά
την μέση βαθμολογία όλων των ταινιών του έτους κυκλοφορίας τους για τη δεκαετία των 80's, μαζί με το έτος
κυκλοφορίας τους, τη μέση βαθμολογία τους και τη μέση βαθμολογία ταινιών του εκάστοτε έτους."
Output: 47 rows
*/
WITH YearlyAverageRatings AS (
    SELECT YEAR(m.release_date) AS Release_Year, AVG(r.rating) AS Avg_Rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY YEAR(m.release_date)
),
MovieAverageRatings AS (
    SELECT m.id, m.title, YEAR(m.release_date) AS Release_Year, AVG(r.rating) AS Avg_Rating
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    GROUP BY m.id, m.title, YEAR(m.release_date)
    HAVING COUNT(r.rating)>5
)
SELECT mar.title AS Movie_Title, mar.release_year AS Release_Year, mar.avg_rating AS Avg_Rating, yar.avg_rating AS Year_Avg_Rating
FROM MovieAverageRatings mar
JOIN YearlyAverageRatings yar ON mar.release_year = yar.release_year
WHERE (mar.release_year BETWEEN 1980 AND 1989) AND mar.avg_rating > yar.avg_rating 
ORDER BY mar.avg_rating DESC


/* 
"Βρες μου τους τίτλους των ταινιών με τα μεγαλύτερα έσοδα κάθε έτους μεταξύ 1985-2010, μαζί με το έτος
κυκλοφορίας τους και τα έσοδά τους."
Output: 24 rows
*/
WITH MaxRevenue AS (
    SELECT YEAR(m.release_date) as release_year, MAX(m.revenue) as MaxRevenue
    FROM movie m
    GROUP BY YEAR(m.release_date)
)
SELECT m.title AS Movie_Title, m.revenue AS Movie_Revenue, YEAR(m.release_date) AS Release_Year
FROM movie m
JOIN MaxRevenue maxr ON maxr.release_year = YEAR(m.release_date)
WHERE m.revenue = maxr.MaxRevenue AND release_year BETWEEN 1985 AND 2010
ORDER BY m.revenue DESC


/* 
"Βρες μου τα ονόματα των 3 συλλογών ταινιών με τα μεγαλύτερα έσοδα στην ιστορία, μαζί με τα έσοδά τους."
Output: 3 rows
*/
SELECT DISTINCT TOP 3 c.name AS Collection_Name, SUM(CAST(m.revenue as BIGINT)) as Collection_Revenue --CAST->BIGINT logw overflow
FROM collection c
JOIN belongsTocollection bc ON bc.collection_id=c.id
JOIN movie m ON m.id = bc.movie_id
GROUP BY c.name
ORDER BY Collection_Revenue DESC


/*
"Βρες μου τα ονόματα των 5 ηθοποιών που έχουν υποδειθεί τους περισσότερους διαφορετικούς ρόλους 
σε ταινίες, μαζί με τον αριθμό των διαφορετικών ρόλων τους."
Output: 5 rows
*/
SELECT TOP 5 mc.name AS Actor_Name, COUNT(DISTINCT mc.character) as Number_Of_Different_Roles
FROM movie_cast mc
GROUP BY mc.name
ORDER BY Number_Of_Different_Roles DESC


/* 
"Βρες μου τους τίτλους και τον μέσο όρο βαθμολογίας των ταινιών με ηθοποιό τον Leonardo DiCaprio 
και εμφάνισέ τους με φθίνουσα σειρά ως προς τον μέσο όρο βαθμολογίας."
Output: 16 rows 
*/
SELECT m.title AS Movie_Title, AVG(r.rating) AS Average_Rating
FROM movie m
FULL OUTER JOIN ratings r ON r.movie_id = m.id
JOIN movie_cast mc ON mc.movie_id = m.id
WHERE mc.name LIKE 'Leonardo DiCaprio'
GROUP BY m.title
ORDER BY Average_Rating DESC


/*
"Βρες μου τους σκηνοθέτες με μέσο όρο βαθμολογίας ταινιών -που να έχουν περισσότερες από 5 κριτικές- 
μεγαλύτερο του 7, και τον μέσο όρο βαθμολογίας των ταινιών καθενός από αυτούς."
Output: 231 rows
*/
SELECT mc.name AS Director_Name, AVG(r.rating) AS Average_Rating
FROM movie m
JOIN ratings r ON r.movie_id = m.id
JOIN movie_crew mc ON mc.movie_id = m.id
GROUP BY mc.name, mc.job
HAVING AVG(r.rating) > 3.5 AND COUNT(r.rating) > 5 AND mc.job LIKE 'Director'
ORDER BY Average_Rating DESC


/*
"Βρες μου τα ονόματα των 5 εταιριών παραγωγής με τις περισσότερες ταινίες 
που ανήκουν στο είδος 'Adventure', μαζί με το πλήθος των ταινιών που ανήκουν στο είδος αυτό."
Output: 5 rows
*/
SELECT TOP 5 pc.name AS Production_Company, COUNT(m.id) AS Number_Of_Adventure_Movies
FROM movie m
JOIN hasProductioncompany hp ON hp.pc_id = m.id
JOIN productioncompany pc ON  hp.pc_id = pc.id
JOIN hasGenre hg ON hg.movie_id = m.id
JOIN genre g ON g.id = hg.genre_id
WHERE g.name LIKE 'Adventure'
GROUP BY pc.name
ORDER BY Number_Of_Adventure_Movies DESC


/*
"Βρες μου τον τίτλο της παλαιότερης ταινίας από κάθε είδος, μαζί με το είδος και το έτος κυκλοφορίας της."
Output: 9 rows
*/
WITH OldestGenre AS (
    SELECT hg.genre_id, MIN(m.release_date) AS oldest_release_date
    FROM movie m
    JOIN hasGenre hg ON hg.movie_id = m.id
    GROUP BY hg.genre_id
)
SELECT g.name AS Genre, m.title AS Movie_Title, YEAR(m.release_date) AS Year_Of_Release
FROM movie m
JOIN hasGenre hg ON hg.movie_id = m.id
JOIN genre g ON g.id = hg.genre_id
JOIN OldestGenre og ON hg.genre_id = og.genre_id AND m.release_date = og.oldest_release_date
ORDER BY YEAR(m.release_date)


/*
"Βρες μου τον μέσο όρο εσόδων των ταινιών που έχουν παραχθεί από την εταιρία παραγωγής 'Paramount Pictures' ανά έτος για τα έτη 1980-1989."
Output: 10 rows
*/
SELECT YEAR(m.release_date) AS Year, AVG(CAST(m.revenue AS BIGINT)) AS Average_Revenue
FROM movie m
JOIN hasProductioncompany hp ON hp.movie_id = m.id
JOIN productioncompany pc ON hp.pc_id = pc.id
WHERE pc.name LIKE 'Paramount Pictures' AND YEAR(m.release_date) BETWEEN 1980 AND 1989
GROUP BY YEAR(m.release_date)
ORDER BY Year


/*
"Βρες μου τις ιστοσελίδες των ταινιών που έλαβαν πάνω απο 4 μέση βαθμολογία,
μαζί με τα τον τίτλο και την μέση βαθμολογία τους, με προϋπόθεση ότι έχουν 5 και πάνω κριτικές."
Output: 113 rows
*/
SELECT m.title AS Movie_Title, m.homepage AS Movie_Homepage, AVG(r.rating) AS Average_Ratings
FROM movie m
FULL OUTER JOIN ratings r ON r.movie_id = m.id
GROUP BY m.title, m.homepage
HAVING AVG(r.rating)>4 AND COUNT(r.rating)>4 
ORDER BY AVG(r.rating) DESC;