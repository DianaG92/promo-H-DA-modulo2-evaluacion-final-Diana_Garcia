-- EJERCICIO FINAL MÓDULO 2 --

USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE "%amazing%";

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title
FROM film
WHERE length > "120";

-- 5. Recupera los nombres de todos los actores.
SELECT first_name
FROM actor;

-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "Gibson";

-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title
FROM film
WHERE rating NOT LIKE "R" AND rating NOT LIKE "PG-13";

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(*) AS "recuento_peliculas", rating
FROM film
GROUP BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS "peliculas_alquiladas"
FROM customer
LEFT JOIN rental
ON customer.customer_id = rental.customer_id 
GROUP BY customer_id, first_name, last_name;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT category.name, COUNT(inventory.film_id) AS total_alquileres
FROM rental
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
ON inventory.film_id = film_category.film_id
LEFT JOIN category
ON  film_category.category_id = category.category_id
GROUP BY film_category.category_id;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT AVG(length), rating
FROM film
GROUP BY rating;

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film_actor.film_id = film.film_id
WHERE film.title LIKE "Indian Love";

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title
FROM film
WHERE description LIKE "%dog%" OR description LIKE "%cat%";

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT actor_id
FROM actor 
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor);

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT film.title
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE category.name = "Family"
GROUP BY film.title;

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT actor.first_name, actor.last_name
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) > 10;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title
FROM film 
WHERE rating = "R" AND length > 120;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT category.name, AVG(film.length) AS promedio_duracion
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
GROUP BY category.name
HAVING AVG(film.length) > 120;

-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT actor.first_name, COUNT(film_actor.film_id) AS cantidad_peliculas
FROM actor
INNER JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
HAVING COUNT(film_actor.film_id) >= 5;

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
SELECT DISTINCT film.title
FROM film
INNER JOIN inventory 
ON film.film_id = inventory.film_id
INNER JOIN rental 
ON inventory.inventory_id = rental.inventory_id
WHERE rental.rental_id IN 
	(SELECT rental_id
    FROM rental 
    WHERE DATEDIFF(return_date, rental_date) > 5);  -- this function calculates the difference between two dates --

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id NOT IN 	
	(SELECT DISTINCT film_actor.actor_id
    FROM film_actor
    INNER JOIN film_category
    ON film_actor.film_id = film_category.film_id
    INNER JOIN category
    ON film_category.category_id = category.category_id
    WHERE category.name = "Horror");

-- BONUS
-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT film.title
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE length > 180 AND name = "Comedy"
GROUP BY film.title;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
SELECT CONCAT(a1.first_name, ' ', a1.last_name) AS actor1, CONCAT(a2.first_name, ' ', a2.last_name) AS actor2, COUNT(*) AS peliculas_comunes
FROM film_actor AS fa1
INNER JOIN film_actor AS fa2 
ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id  -- this avoids duplicates in actor pairs --
INNER JOIN actor AS a1 
ON fa1.actor_id = a1.actor_id
INNER JOIN actor AS a2 
ON fa2.actor_id = a2.actor_id
GROUP BY a1.first_name, a1.last_name, a2.first_name, a2.last_name
HAVING COUNT(*) > 0;  -- this shows only pairs of actors who have worked together in at least one movie --