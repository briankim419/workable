require "pg"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "dvdrental")
    yield(connection)
  ensure
    connection.close
  end
end


db_connection do |conn|
  a = conn.exec("SELECT rental_id FROM rental")
binding.pry
end

SELECT customer.customer_id, customer.first_name, customer.last_name, customer.activebool, customer.active, customer.last_update FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id;



  1. Which customer has made the most rentals at store 2?
  2. A customer tried to rent “Image Princess” from store 1 on 29/07/2005 at 3pm but it
  was sold-out. Would he be able to rent it from store 2 if he had tried?
  3. How many customers are active at any given month per year (e.g. …, Jun 2005, Jul
  2005,...., Jun 2006 etc)? We define active as performing at least one rental during
  that month.
  4. Which film category is the most popular among our customers?
  5. Which film is the most popular in category “Sports”?
  6. Are there any other insights that you can gather from the data that would be helpful
  to the owner of this business?

1. Which customer has made the most rentals at store 2?
  SELECT
   customer.customer_id,
   customer.first_name,
   customer.last_name,
   COUNT(DISTINCT rental.rental_id) AS "rental_count"
  FROM
   customer
  INNER JOIN rental ON rental.customer_id = customer.customer_id
  INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
  WHERE
   inventory.store_id = 2
  GROUP BY customer.customer_id, customer.first_name, customer.last_name
  ORDER BY rental_count DESC
  LIMIT 10;

#Jorge Olivares 26 rentals



  2. A customer tried to rent “Image Princess” from store 1 on 29/07/2005 at 3pm but it
  was sold-out. Would he be able to rent it from store 2 if he had tried?


SELECT film.film_id, title, inventory.last_update, store_id, rental_date, return_date, inventory.inventory_id
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
WHERE
film.title = 'Image Princess';
##ANSWER = Yes, inventory_id(2091, 2092, 2093) were all available at store 2 but all inventory_id(2089, 2090, 2091) were all rented out

3. How many customers are active at any given month per year (e.g. …, Jun 2005, Jul
2005,...., Jun 2006 etc)? We define active as performing at least one rental during
that month.

SELECT COUNT(DISTINCT rental.customer_id) AS customer_count
FROM rental
WHERE rental.rental_date >= '2005-05-01 00:00:00'::timestamp
AND  rental.rental_date <  '2005-06-01 00:00:00'::timestamp

4. Which film category is the most popular among our customers?

SELECT category.category_id, name, COUNT(DISTINCT rental.rental_id) AS rental_count
FROM category
INNER JOIN film_category ON film_category.category_id = category.category_id
INNER JOIN film ON film.film_id = film_category.film_id
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY category.category_id, name
ORDER BY rental_count DESC
LIMIT 10;

#SPORTS with 1179

5. Which film is the most popular in category “Sports”?

SELECT film.title, COUNT(DISTINCT rental.rental_id) AS rental_count
FROM category
INNER JOIN film_category ON film_category.category_id = category.category_id
INNER JOIN film ON film.film_id = film_category.film_id
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC
LIMIT 10

Bucket Brotherhood - 34 times


6. Are there any other insights that you can gather from the data that would be helpful
to the owner of this business?

revenue of each store
SELECT SUM(payment.amount) AS revenue, staff.store_id
FROM payment
INNER JOIN staff ON staff.staff_id = payment.staff_id
GROUP BY staff.store_id

revenue  | store_id
----------+----------
30252.12 |        1
31059.92 |        2

revenue by film

SELECT SUM(payment.amount) AS revenue, film.title
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
INNER JOIN payment ON payment.customer_id = rental.customer_id
GROUP BY film.title
ORDER BY revenue DESC
LIMIT 10;

revenue |        title
---------+---------------------
3542.57 | Ridgemont Submarine
3506.73 | Apache Divine
3442.83 | Forward Temple
3434.92 | Bucket Brotherhood
3420.00 | Pulp Beverly
3410.97 | Harry Idaho
3398.17 | Rugrats Shakespeare
3390.43 | Massacre Usual
3388.05 | Network Peak
3379.99 | Rocketeer Mother

release year and rental date?

best roi? under the assumption that replacement_cost = cogs

SELECT (SUM(payment.amount) - SUM(film.replacement_cost)) / SUM(film.replacement_cost) AS roi, film.title
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
INNER JOIN payment ON payment.customer_id = rental.customer_id
GROUP BY film.title
ORDER BY roi DESC
LIMIT 10;


roi           |       title
-------------------------+-------------------
-0.55223763088931628257 | Control Anthem
-0.55817238558355309624 | Daisy Menagerie
-0.56192556192556192556 | Star Operation
-0.56324440382411396904 | Sting Personal
-0.56414796299189362773 | Young Language
-0.56540558823663846495 | Matrix Snowman
-0.56674321380203733145 | Fellowship Autumn
-0.56676788520363939358 | Purple Movie
-0.56771888167237004446 | Talented Homicide
-0.56779468544174426527 | North Tequila
