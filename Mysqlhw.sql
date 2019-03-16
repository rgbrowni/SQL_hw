USE sakila;
/* Question 1a */
SELECT first_name, last_name FROM actor;
/*Question 1b */
SELECT CONCAT(first_name," ", last_name) AS "Actor_Name" FROM actor;
/* Question 2a */
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";
/* 2b */
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%GEN%";
/*2c*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;
/*2d*/
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");
/*3a*/
ALTER TABLE actor
ADD COLUMN description BLOB;
select * from actor limit 10;
/*3b*/
ALTER TABLE actor
DROP COLUMN description;

/*4a*/
select last_name, count(last_name)
FROM actor
GROUP BY last_name


/*4b*/
SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

/*4c*/
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";

/*4d*/
UPDATE actor
SET first_name = 
CASE
    WHEN first_name = "GROUCHO" THEN "HARPO"
    ELSE " "  
END;

/*5a*/

SHOW CREATE TABLE address;

/*5b*/

SELECT column_name address.first_name, 
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;

/*6a*/
SELECT s.first_name, s.last_name, a.address
FROM staff s LEFT JOIN address a ON s.address_id = a.address_id;


/*6b*/
SELECT s.first_name, s.last_name, SUM(p.amount) AS total_rung_up
FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '%2005-08-%'
GROUP BY s.staff_id;

/*6c*/

SELECT f.title, COUNT(fa.actor_id) AS actor_cnt
FROM film f INNER JOIN film_actor fa on f.film_id = fa.film_id
GROUP BY f.title;


/*7a*/
SELECT f.title 
FROM sakila.film f
WHERE f.title IN (SELECT title 
                    FROM sakila.film 
                    INNER JOIN sakila.language l USING (language_id)
                    WHERE l.name = "English")
AND LEFT(f.title, 1) IN ('K','Q')
LIMIT 100;
# Same result can also be achieved without a subquery...
SELECT f.title
FROM sakila.film f
INNER JOIN sakila.language l USING (language_id)
WHERE l.name = "English" AND 
LEFT(f.title, 1) IN ('K','Q')
LIMIT 100;


/*7b*/

SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM sakila.actor a
INNER JOIN sakila.film_actor fa2 USING (actor_id)
WHERE a.actor_id IN (SELECT fa.actor_id
                        FROM sakila.film_actor fa
                        INNER JOIN sakila.film f USING(film_id)
                        INNER JOIN sakila.film_actor fa2 ON f.film_id = fa2.film_id
                        WHERE f.title = "Alone Trip")
ORDER BY actor_name ASC
LIMIT 100;

/*7c*/


SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email
FROM sakila.customer c
INNER JOIN sakila.address ad USING (address_id)
INNER JOIN sakila.city ct ON ad.city_id = ct.city_id
INNER JOIN sakila.country cy ON cy.country_id = ct.country_id
WHERE c.active = 1 AND
cy.country = 'Canada'
ORDER BY (customer_name) ASC
LIMIT 100;

/*7d*/

SELECT f.title AS family_movies
FROM sakila.film f
INNER JOIN sakila.film_category fc USING (film_id)
INNER JOIN sakila.category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Family'
ORDER BY f.title ASC
LIMIT 100;


/*7e*/

SELECT f.title AS frequently_rented_movies
FROM sakila.rental r
LEFT JOIN sakila.inventory i USING (inventory_id)
LEFT JOIN sakila.film f ON f.film_id = i.film_id
GROUP BY (f.film_id)
ORDER BY frequently_rented_movies
LIMIT 100;

/*7f*/

SELECT st.store_id, sum(p.amount) AS dollars
FROM sakila.payment p
LEFT JOIN sakila.staff sf USING (staff_id)
LEFT JOIN sakila.store st ON st.store_id = sf.store_id
GROUP BY (st.store_id)
ORDER BY dollars DESC
LIMIT 10;

/*7g*/

SELECT s.store_id, cy.city, co.country
FROM sakila.store s
LEFT JOIN sakila.address ad USING (address_id)
LEFT JOIN sakila.city cy ON cy.city_id = ad.city_id
LEFT JOIN sakila.country co ON cy.country_id = co.country_id
LIMIT 10;

/*7h*/

SELECT cat.name, SUM(p.amount) AS revenue
FROM sakila.category cat
LEFT JOIN sakila.film_category fc USING (category_id)
LEFT JOIN sakila.inventory i ON i.film_id = fc.film_id
LEFT JOIN sakila.rental r ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.payment p ON p.rental_id = r.rental_id
GROUP BY cat.name
ORDER BY revenue DESC
LIMIT 10;

/*8a*/

USE sakila;
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS
SELECT cat.name, sum(amount) AS revenue
FROM sakila.category cat
LEFT JOIN sakila.film_category fc USING(category_id)
LEFT JOIN sakila.inventory i ON i.film_id = fc.film_id
LEFT JOIN sakila.rental r ON r.inventory_id = i.inventory_id
LEFT JOIN sakila.payment p ON p.rental_id = r.rental_id
GROUP BY cat.name
ORDER BY revenue DESC
LIMIT 10;

/*8b*/

SELECT * FROM top_five_genres
LIMIT 5;

/*8c*/

DROP VIEW IF EXISTS top_five_genres;