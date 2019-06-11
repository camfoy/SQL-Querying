USE sakila;

-- 1a.
SELECT first_name, last_name
FROM actor;

-- 1b.
SELECT CONCAT(first_name, ' ', last_name) as 'Actor Names'
FROM actor;

-- 2a.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c.
SELECT actor_id, last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d.
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `description` BLOB NULL AFTER `last_update`;

-- 3b.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `description`;

-- 4a.
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b.
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d.
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';

-- 5a.
SHOW CREATE TABLE address;

-- 6a.
SELECT staff.first_name, staff.last_name, address.address, address.address2
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

-- 6b.
SELECT payment.staff_id, staff.first_name, staff.last_name, SUM(payment.amount) AS 'TOTAL'
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY payment.staff_id;

-- 6c.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

-- 6d.
SELECT film.title, COUNT(inventory.film_id) AS 'Number of Copies'
FROM film
INNER JOIN inventory on film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- 6e.
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'TOTAL PAID'
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

-- 7a.
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id IN (
	SELECT language_id
	FROM language
	WHERE name = 'English'
);

-- 7b.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
	)
);

-- 7c.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d.
SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM film_category
    WHERE category_id IN (
		SELECT category_id
        FROM category
        WHERE name = 'FAMILY'
	)
);

-- 7e.
SELECT film.title, COUNT(rental.inventory_id) as 'TOTAL RENTS'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental.inventory_id) DESC;

-- 7f.
SELECT store.store_id, SUM(payment.amount) AS 'Revenue'
FROM payment
INNER JOIN staff ON payment.staff_id = staff.staff_id
INNER JOIN store ON staff.store_id = store.store_id
GROUP BY store.store_id;

-- 7g.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;

-- 7h.
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category
INNER JOIN film_category ON category.category_id = film_category.category_id
INNER JOIN inventory ON film_category.film_id = inventory.film_id
INNER JOIN rental ON inventory.inventory_id = rental.rental_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
LIMIT 5;

-- 8a.
CREATE VIEW top_five_genres AS (
	SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
	FROM category
	INNER JOIN film_category ON category.category_id = film_category.category_id
	INNER JOIN inventory ON film_category.film_id = inventory.film_id
	INNER JOIN rental ON inventory.inventory_id = rental.rental_id
	INNER JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY category.name
	LIMIT 5
);

-- 8b.
SELECT * FROM top_five_genres;

-- 8c.
DROP VIEW top_five_genres;