DROP TABLE IF EXISTS new_genres;
CREATE TEMP TABLE new_genres as
SELECT DISTINCT genres as original, 
genres as new_genres
FROM play_store_apps;

SELECT *
FROM new_genres;

UPDATE new_genres
SET new_genres = 'Games'
WHERE new_genres ILIKE '%Action%'
OR new_genres ILIKE '%Adventure%'
OR new_genres ILIKE '%Arcade%'
OR new_genres ILIKE '%Board%'
OR new_genres ILIKE '%Card%'
OR new_genres ILIKE '%Casino%'
OR new_genres ILIKE '%Casual%'
OR new_genres ILIKE '%Educational%'
OR new_genres ILIKE '%Puzzle%'
OR new_genres ILIKE '%Racing%'
OR new_genres ILIKE '%Role Playing%'
OR new_genres ILIKE '%Simulation%'
OR new_genres ILIKE '%Strategy%'
OR new_genres LIKE '%Trivia%'
OR new_genres ILIKE '%Word%';

UPDATE new_genres
SET new_genres = 'Book'
WHERE new_genres ILIKE '%Book%'
OR new_genres LIKE '%Comics%';

UPDATE new_genres
SET new_genres = 'Navigation'
WHERE new_genres ILIKE '%Navigation%';

UPDATE new_genres
SET new_genres = 'Lifestyle'
WHERE new_genres ILIKE '%Beauty%'
OR new_genres ILIKE '%Parenting%'
OR new_genres LIKE 'Dating'
OR new_genres LIKE 'House & Home';

UPDATE new_genres
SET new_genres = 'Entertainment'
WHERE new_genres ILIKE '%Event%'
OR new_genres ILIKE '%Entertainment%';

UPDATE new_genres
SET new_genres = 'Photo & Video'
WHERE new_genres ILIKE '%Video%'
OR new_genres LIKE 'Photography';

UPDATE new_genres
SET new_genres = 'Travel'
WHERE new_genres ILIKE '%Travel%';

UPDATE new_genres
SET new_genres = 'Productivity'
WHERE new_genres LIKE 'Art & Design;Creativity'
OR new_genres LIKE 'Art & Design';

UPDATE new_genres
SET new_genres = 'Social Networking'
WHERE new_genres ILIKE '%Social%'
OR new_genres LIKE '%Communication%';

UPDATE new_genres
SET new_genres = 'Catelogs'
WHERE new_genres LIKE 'News & Magazines';

UPDATE new_genres
SET new_genres = 'Utilities'
WHERE new_genres LIKE 'Tools'
OR new_genres LIKE 'Libraries & Demo';

UPDATE new_genres
SET new_genres = 'Shopping'
WHERE new_genres LIKE 'Auto & Vehicles'