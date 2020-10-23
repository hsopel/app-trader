SELECT *
FROM play_store_apps
LIMIT 10;

SELECT *
FROM app_store_apps
LIMIT 10;

SELECT name
FROM app_store_apps
INTERSECT
SELECT name
FROM play_store_apps;
------------------------------------

---NUMBER OF APPS BY PRICE RANGE IN BOTH STORES---

SELECT COUNT(price) as num_apps_app_store, ROUND(ROUND(AVG(rating*2))/2,1) as avg_rating,
	CASE WHEN price <= 1.00 THEN '< $1.00'
		WHEN price <= 9.99 THEN '$1.01 - $9.99'
			ELSE '$10 or above' END as price_range
FROM app_store_apps
GROUP BY price_range
ORDER BY num_apps_app_store DESC;

SELECT COUNT(price) as num_apps_play_store, ROUND(ROUND(AVG(rating*2))/2,1) as avg_rating,
	CASE WHEN trim(price, '$')::numeric <= '1.00' THEN '< $1.00'
		WHEN trim(price, '$')::numeric <= '9.99' THEN '$1.01 - $9.99'
			ELSE '$10 or above' END as price_range
FROM play_store_apps
GROUP BY price_range
ORDER BY num_apps_play_store DESC;

--BREAKDOWN BY CATEGORY/GENRE - AVG RATING AND TOTAL APPS 
--Use category from play store and primary genre from app store
SELECT INITCAP(lower(category)), COUNT(*) as num_apps, ROUND(AVG(rating::numeric),2) --AVG(trim(install_count::numeric, '+,""'))
FROM play_store_apps
WHERE price < '1.00'
GROUP BY category
ORDER BY COUNT(*) DESC;

SELECT primary_genre, COUNT(primary_genre), ROUND(AVG(rating),2) as avg_rating, AVG(price)::money as avg_price
FROM app_store_apps
GROUP BY primary_genre
ORDER BY COUNT(primary_genre) DESC;

SELECT genres, ROUND(ROUND(AVG(rating*2))/2,1) as avg_rating, COUNT(name)
FROM play_store_apps
WHERE price <= '1.00'
AND rating IS NOT null
GROUP BY genres
ORDER BY avg_rating DESC;

SELECT primary_genre, ROUND(ROUND(AVG(rating*2))/2,1) as avg_rating
FROM app_store_apps
WHERE price <= 1.00
GROUP BY primary_genre
ORDER BY avg_rating DESC;

--Looking into specific genres
SELECT *
FROM app_store_apps
WHERE primary_genre = 'Games'
ORDER BY price DESC;

SELECT name, type, price::money
FROM play_store_apps
WHERE category LIKE 'GAME'
ORDER BY price DESC;

SELECT AVG(trim(price, '$')::numeric)
FROM play_store_apps
WHERE category LIKE 'GAME'
AND type = 'Paid';

SELECT *
FROM play_store_apps
WHERE category = 'FAMILY'
ORDER BY name;

--Is content rating important? 
SELECT content_rating, ROUND(AVG(CAST(review_count as numeric))) as average_review
FROM app_store_apps
GROUP BY content_rating
HAVING ROUND(AVG(CAST(review_count as numeric))) > 12000
ORDER BY average_review DESC;

--Unhelpful breakdown of number apps by price
SELECT price, COUNT(*)
FROM play_store_apps
GROUP BY price
ORDER BY price;

SELECT price, COUNT(*)
FROM app_store_apps
GROUP BY price
ORDER BY price;

--Let's look at average review count by category review count... 

SELECT category, ROUND(AVG(rating), 2) as avg_rating, ROUND(AVG(review_count)) as avg_review_count
FROM play_store_apps
WHERE price <= '1.00'
GROUP BY category
ORDER BY avg_rating DESC;

--rating and review count for games that cost <=$0.99
SELECT name, ROUND((rating*2)/2,1) as rnd_rating, price::money, review_count
FROM app_store_apps
WHERE primary_genre = 'Games'
AND price <= '0.99'
AND review_count::numeric > '1000'
ORDER BY rnd_rating DESC;

--Finally figured out the most important part of the project - yay! 
--Found apps available in both store using multiple CTEs
WITH app_store AS (SELECT name, rating, review_count
				  FROM app_store_apps 
				  WHERE price <= '1.00'),
	play_store AS (SELECT name, rating, review_count
					FROM play_store_apps
					WHERE trim(price, '$')::numeric <= '1.00'),
	matching AS (SELECT name
					FROM app_store
					INTERSECT
					SELECT name
					FROM play_store),
	best_apps AS (SELECT name, a.primary_genre, a.rating as app_rating, a.review_count as app_rc, p.category, p.rating as play_rating, p.review_count as play_rc
					FROM matching
					INNER JOIN app_store_apps as a
					USING (name)
					INNER JOIN play_store_apps as p
					USING(name))						

SELECT *
FROM best_apps
ORDER BY name DESC;

--apps available in both stores with a rating of >=4.5
SELECT DISTINCT(name), primary_genre, app_rating, app_rc, category, play_rating, play_rc
FROM best_apps
WHERE app_rating >=4.5
AND play_rating >=4.5
ORDER BY app_rating DESC;