-- sakila Database

-- INNER JOINS

-- 10 - What country is the city based in?
SELECT *
FROM country 
LIMIT 10;

SELECT *
FROM city 
LIMIT 10;

SELECT city, country, city.country_id
FROM city 
JOIN country 
	ON country.country_id = city.country_id;


-- 11 - What language is spoken in each film?
SELECT title, film.language_id, name
FROM film 
JOIN language
	ON film.language_id = language.language_id;


-- 12 - List all film titles and their category (genre)
SELECT 
	film.film_id,	
	film.title, 
	category.name,
	film_category.category_id
FROM film 
JOIN film_category
	ON film.film_id = film_category.film_id 
JOIN category 
	ON category.category_id = film_category.category_id;


-- 13 - Create an email list of Canadian customers
/*
customer
	address_id
address
	city_id
city
	country_id
country
 */

SELECT 
	first_name,
	last_name,
	country.country,
	email
FROM customer 
JOIN address 
	ON customer.address_id = address.address_id
JOIN city 
	ON address.city_id = city.city_id
JOIN country 
	ON city.country_id = country.country_id
	WHERE country = 'Canada';


-- 14 - How much rental revenue has each customer generated? 
-- In other words, what is the SUM rental payment amount for each customer ordered by the SUM amount from high to low?
/*
customer
	customer_id
payment
 */

SELECT	
	CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
	SUM(payment.amount) AS total_amount
FROM customer
JOIN payment 
	ON customer.customer_id = payment.customer_id
GROUP BY customer_name
ORDER BY total_amount DESC;


-- 15 - How many cities are associated to each country? 
-- Filter the results to countries with at least 10 cities.
SELECT
	COUNT(city.city) AS city_count,
	country.country
FROM city
JOIN country
	ON city.country_id = country.country_id
	GROUP BY country;


-- LEFT JOINS

-- 16 - Which films do not have an actor?
SELECT film.title, film_actor.film_id
FROM film
LEFT JOIN film_actor 
	ON film.film_id = film_actor.film_id
WHERE film_actor.film_id IS NULL;
	

-- 17 - Which comedies are not in inventory?
-- A) Find all films not in inventory (regardless of genre)
-- B) Find category ID to join with category table
-- Not in inventory = inventory.film_id IS NULL
SELECT title, inventory.film_id
FROM film 
LEFT JOIN inventory 
	ON film.film_id = inventory.film_id 
JOIN film_category 
	ON film.film_id = film_category.film_id 
JOIN category 
	ON film_category.category_id = category.category_id 
WHERE inventory.film_id IS NULL
	AND category.name = 'Comedy';


-- 18 - Generate a list of never been rented films
/*
film
	film_id
inventory
	inventory_id (left join)
rental
 */

SELECT film.title, inventory.inventory_id 
FROM film
JOIN inventory 
	ON film.film_id = inventory.film_id
LEFT JOIN rental 
	ON rental.inventory_id = inventory.inventory_id
WHERE rental.inventory_id IS NULL;
