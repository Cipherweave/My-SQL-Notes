USE sql_store;

SELECT 
	first_name, 
	last_name, 
	customer_id, 
    (points * 2) + 10 AS "New Name",
    birth_date
FROM customers
-- WHERE customer_id = 1  where is like a python if statement. everything is similar != > <  <= >=... except for dates
WHERE birth_date > '1986-03-28';  # this is the currect format for dates and its not str
-- ORDER BY first_name;



SELECT DISTINCT state   #for UNIQUENESS of stetes
FROM customers;


SELECT name, unit_price, unit_price * 1.1 AS new_price
FROM products;

SELECT *
from orders
WHERE order_date >= "2019-01-01" and customer_id = 6; # same as OR. Also AND has more power. same as NOT


SELECT *
from customers
WHERE state IN("VA", 'FL', 'GA'); # this is how IN works

SELECT *
from customers
WHERE points BETWEEN 1000 AND 2000 or birth_date Between "1990-1-1" and "2000-1-1";  # BETWEEN Operator

SELECT *
from customers
WHERE last_name LIKE "b%"; # LIKE operator in this case is if the last name starts with b and % is anything else after that
# for example "%b%" is if there is any letter b in the last name. or "%y" this where it ends with y
# For Example "_y" is any last name where its two letters and ends with y. "___y" and 4 letters with y at the end. or "b__y".


SELECT *
from customers
-- WHERE last_name LIKE "%field%"
WHERE last_name REGEXP "field"; -- this and the upper line are the same.
-- The REGEXP is exactly like the one in python there is a link of all commands saves in your google bookmarks
-- the important ones 
-- ^ starts at the beggining 
-- $ at the end
-- | or
-- [abcd] any between the values inside
-- [a-z] range any between

SELECT *
from customers
WHERE phone is NULL; -- NULL means if its empty 

SELECT *
from customers
ORDER BY first_name DESC; -- DESC means descending order	

SELECT first_name, last_name 
from customers
ORDER BY state, first_name; -- means first sory by state and then sort by first_name withing state.

SELECT *
from order_items
where order_id = 2
order by quantity * unit_price DESC;

SELECT *, quantity * unit_price AS total_price
from order_items
where order_id = 2  
order by total_price DESC;



SELECT *
from customers
LIMIT 3;  -- only gives you the first three

SELECT *
from customers
LIMIT 6, 3; -- skipes 6 rows and gives 3 



SELECT *  # TOP THREE CUSTOMERS
from customers
ORDER BY points DESC
LIMIT 3;

-- SELECT *
-- from customers, clients   -- this doesnt work 
-- LIMIT 3;


SELECT *
from orders
JOIN customers ON orders.customer_id = customers.customer_id;   -- joins two tables based on their common behavior.

SELECT order_id, customers.customer_id, first_name, last_name -- it doesnt know if its the cutomer id from orders or customers so we have to specify
from orders
JOIN customers 
	ON orders.customer_id = customers.customer_id;


SELECT order_id, c.customer_id, first_name, last_name  
from orders o -- we choose o for more simple functions
JOIN customers c
	ON o.customer_id = c.customer_id;
    
    
SELECT order_id, oi.product_id, quantity, oi.unit_price
from order_items oi
JOIN  products p ON oi.product_id = p.product_id;


SELECT *
from order_item oi
JOIN sql_invoicing.products p   -- for a table from a different data base
	ON oi.product_id = p.product_id; -- we only have to prefix the tables
    -- that are not part of the USED database 
		

SELECT e.employee_id, e.first_name, 
	e.last_name, m.first_name Boss_name
from sql_hr.employees e
JOIN sql_hr.employees m ON e.reports_to =  m.employee_id;  -- employees with their boss


-- JOINING MULTIPLE TABLES

SELECT o.order_id, o.order_date, p.first_name, p.last_name, os.name AS status
FROM orders o
JOIN customers p ON o.customer_id = p.customer_id
JOIN order_statuses os ON os.order_status_id = o.status;


SELECT *
from order_items oi
JOIN order_item_notes oin ON oi.order_id = oin.order_id 
	AND oi.product_id = oin.product_id;
    
-- <<<<<<< THESE TWO ARE THE SAME
-- explicit join syntax (more suggested to use this)
SELECT *  
from orders o 
JOIN customers c
	on o.customer_id = c.customer_id;
   
-- this is called implicit join syntax. (not suggested to use this)
SELECT * 
from orders o, customers c
WHERE o.customer_id = c.customer_id;
-- >>>>>>>


-- we were using inner join so far. for using outer join it is two types
-- LEFT join means prorotize the LEFT table and same with RIGHT JOIN. in this 
-- case left is the customer and right is the orders.
-- remove the LEFT before join to see the problem. the problem is that with inner join
-- it only shows the customers whom had an order but outer join prevents that.

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id
order by c.customer_id;


-- example of outer join 
SELECT 
	p.product_id,
    p.name,
    oi.quantity 
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id; 
-- product number 7 has have never been ordered but still exists in the resault.

-- for multi table queries, i think left represents the table for "FROM".



SELECT 
	o.order_date,
    o.order_id,
    c.first_name,
    sh.name AS shipper,
    os.name AS status
FROM orders o 
JOIN customers c ON c.customer_id = o.customer_id
LEFT JOIN shippers sh ON sh.shipper_id = o.shipper_id
LEFT JOIN order_statuses os ON o.status = os.order_status_id
ORDER BY os.name;


-- shorter format
SELECT 
	p.product_id,
    p.name,
    oi.quantity 
FROM products p
-- LEFT JOIN order_items oi ON oi.product_id = p.product_id; 
LEFT JOIN order_items oi USING (product_id);  -- same as the line above
-- you can also use it with inner join. 
-- but it only words if we have the same name for two columns


SELECT *
from order_items oi
-- JOIN order_item_notes oin ON oi.order_id = oin.order_id
-- 	AND oi.product_id = oin.product_id;
JOIN order_item_notes oin USING (order_id, product_id);


SELECT 
	p.date,
    cl.name AS Client,
    p.amount, 
    pm.name
FROM sql_invoicing.payments p
JOIN sql_invoicing.clients cl USING (client_id)
JOIN sql_invoicing.payment_methods pm ON pm.payment_method_id = p.payment_method;


SELECT o.order_id, c.first_name
FROM orders o
NATURAL JOIN customers c; -- this just takes the common column but not always works


-- cross JOIN puts every column of the first table with every column of the second table
select *
FROM customers c
CROSS JOIN products p;
-- you could also do this saying FROM customers c, products p 


SELECT 
	sh.name AS Shipper,
    p.name AS product
FROM products p
CROSS JOIN shippers sh;


-- <<<<
-- UNION connects two tables from row perspective. but the number of columns selected have to be equal. 
SELECT first_name 
FROM customers
UNION
SELECT name
FROM shippers;
-- >>>> 

SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "GOLD" AS type
FROM customers c
WHERE c.points > 3000
UNION
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "Silver" AS type
FROM customers c
WHERE c.points BETWEEN 2000 and 3000
UNION 
SELECT 
	c.customer_id,
    c.first_name,
    c.points,
    "Bronze" AS type
FROM customers c
WHERE c.points < 2000
ORDER By first_name;


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> DATA MANIPULATION SECTION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



-- if you open the setting for each section you will see the meaning of each check mark
INSERT INTO customers
VALUES (DEFAULT, 
	'John', 
    'Smith',
    '1990-01-01',
    null, -- in table setting for tables which is NN we are not requred to pass any value and we could just say NULL or DEFAULT
    'ADRESS',
    'city',
	'CA', 
    DEFAULT); -- id will automaticly get assign since AI is checked in the setting. so we have to put default 



-- OR This is also right. we could also change the order and it would stay the same.
INSERT INTO customers (first_name, last_name, birth_date, address, city, state)
VALUES ('John', 
    'Smith',
    '1990-01-01', 
    'ADRESS',
    'city',
	'CA');
    
INSERT INTO products
VALUES (DEFAULT, 'A', 50, 1), 
	(DEFAULT, 'B', 60, 2),
    (DEFAULT, 'C', 70, 3); -- for multiple rows
    

INSERT INTO	orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES (LAST_INSERT_ID(), 1, 1, 2.95); -- LAST_INSERT_ID is basically a built in fucntion the do what its name is.
-- we need this when we are adding to a parent table and child table. because orders and order_items are related

CREATE TABLE order_archived AS  -- this is how we copy a table
SELECT * FROM orders; -- when we have statemnet inside another statement, it is called a subquery


INSERT INTO order_archived -- in here we chose a subquery instead of the values.
SELECT *
FROM orders 
WHERE order_date < '2019-01-01';

CREATE TABLE sql_invoicing.invoices_archive AS  -- complex example
SELECT 
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM sql_invoicing.invoices i 
LEFT JOIN sql_invoicing.clients c USING(client_id)
WHERE i.payment_date is not Null;


UPDATE sql_invoicing.invoices  -- this is how we update rows 
SET payment_total = 10, payment_date = '2019-03-01' -- we could also use other columns like payment_totla = invoice_total * 0.5
WHERE invoice_id = 1;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';


-- Sometimes we could use subqueries in UPDATE statements we just have to put IN instead of = in where clouse.
    
UPDATE orders 
SET comments = "GOLD costumer"
WHERE customer_id IN
	(SELECT customer_id
    FROM customers
    WHERE points > 3000);
    
    
DELETE FROM sql_invoicing.invoices
WHERE client_id IN (
	SELECT client_id 
	from sql_invoicing.clients 
	WHERE name = 'Myworks'
);



-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Summerizing DATA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- built in functions
SELECT 
	MAX(payment_date) AS highest,
    MIN(invoice_total) AS lowerst,
	AVG(invoice_total) AS average,
    SUM(invoice_total * 1.1) AS total, -- mutiply each row by 1.1 then sum them
    COUNT(invoice_total) AS number_of_invoices, -- these fouction do not count nulls 
    COUNT(payment_date) AS count_of_payments, -- for example here
    COUNT(*) AS total_records,
	COUNT(DISTINCT client_id) AS total_records -- doesnt produce dublicates and count UNIQUE 
FROM sql_invoicing.invoices
WHERE invoice_date > '2019-07-01';




-- example

SELECT 
	"first half of 2019" AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM sql_invoicing.invoices
WHERE invoice_date between "2019-01-01" and "2019-06-30"
UNION
SELECT 
	"second half of 2019" AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM sql_invoicing.invoices
WHERE invoice_date between "2019-07-01" and "2019-12-31"
UNION
SELECT 
	"total" AS date_range,
	SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM sql_invoicing.invoices
WHERE invoice_date between "2019-01-01" and "2019-12-31";


SELECT 
	client_id,
	SUM(invoice_total) AS total_sales
FROM sql_invoicing.invoices i
-- where 
GROUP BY client_id;   -- sometimes we have a client doing multiple invoices, this was we can just get the client total invoice.
-- order by 


SELECT
	city,
	state,
	SUM(invoice_total) AS total_sales
FROM sql_invoicing.invoices i
JOIN sql_invoicing.clients c USING(client_id)
GROUP BY city, state;


-- example
SELECT 
	p.date,
    pm.name AS payment_method,
    SUM(p.amount) AS total_payment
FROM sql_invoicing.payments p 
JOIN sql_invoicing.payment_methods pm ON pm.payment_method_id = p.payment_method
GROUP BY p.date, pm.name
ORDER BY DATE;



-- HAVING clause: we use WHERE before grouping our rows and HAVING after grouping our rows 
SELECT 
	client_id,
	SUM(invoice_total) AS total_sales,
    Count(*) as number_of_invoices 
FROM sql_invoicing.invoices i
-- where 
GROUP BY client_id WITH ROLLUP  -- gives you a total at the end. When grouping by multiple coloums it gives to total for each colomn as well
-- order by 
HAVING total_sales > 500;



SELECT 
	c.name,
    c.client_id,
	SUM(amount) AS total_amount
FROM sql_invoicing.clients c
LEFT JOIN sql_invoicing.payments p USING(client_id)
-- WHERE c.state = "VA"
GROUP BY c.name, c.client_id 
HAVING total_amount > 100;



SELECT 
	pm.name,
    SUM(p.amount) AS total
FROM sql_invoicing.payments p
LEFT JOIN sql_invoicing.payment_methods pm ON pm.payment_method_id = p.payment_method
GROUP BY pm.name WITH rollup;



SELECT *
FROM sql_invoicing.clients c 
WHERE c.client_id NOT IN (
	SELECT DISTINCT i.client_id  
	FROM sql_invoicing.invoices i
);


SELECT 
	DISTINCT o.customer_id,
    c.first_name,
    c.last_name,
    i.product_id
FROM sql_store.orders o
LEFT JOIN sql_store.customers c USING (customer_id)
LEFT JOIN sql_store.order_items i USING (order_id)
WHERE i.product_id = 3;

-- ALL and ANY will act like ALL and ANY from PYTHON


SELECT *
FROM sql_invoicing.invoices i
WHERE i.invoice_total > (
	SELECT AVG(j.invoice_total) as AVERAGE 
    FROM sql_invoicing.invoices j
    WHERE j.client_id = i.client_id
);



SELECT *
FROM clients c
WHERE EXISTS (	 -- exists returns True if it exists. it is faster than IN since it doesnt return a new temp table
	SELECT client_id 	
    FROM invoices 
    WHERE client_id = c.client_id
    );
    
    
SELECT *
FROM sql_store.products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM sql_store.order_items oi
    WHERE p.product_id = oi.product_id
);

USE sql_store;

SELECT 
	DISTINCT c.client_id,
    c.name,
    (SELECT SUM(invoice_total) FROM sql_invoicing.invoices
    WHERE client_id = c.client_id) AS total_sales,
    (SELECT AVG(j.invoice_total)
    FROM sql_invoicing.invoices j) AS average,
    (SELECT total_sales - average) AS difference
FROM sql_invoicing.clients c
LEFT JOIN sql_invoicing.invoices i USING (client_id)
group by c.client_id, c.name;

-- int functions
SELECT ROUND(5.73);
SELECT ROUND(5.73, 1); -- 	to what decimal number
SELECT TRUNCATE(5.7345); -- keep the first two digits and remove the the others 
SELECT CEILING(5.2);  -- round up
SELECT FLOOR(5.7); -- round down
SELECT ABS(-5.2); -- absoulute value

-- str functions
-- we have LENGTH, UPPER, LOWER, 
SELECT LTRIM('    sky'); -- removes spaces on the left and opposite for RTRIM.
SELECT LEFT("HEYYYY", 2); -- first two characters and opposite for RIGHT.
SELECT SUBSTRING("kindergarten", 3, 5); -- strats from 3th character and go 5 forward. if we dont give the third parametre, it will got till end
SELECT LOCATE('n', 'kindergarten'); -- if character doesnt exist, we get 0	
SELECT REPLACE("kindergarten", 'garten', 'garden'); -- replace garten with garden
SELECT CONCAT('first', ' last'); -- connect them toghther

-- ex
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM sql_store.customers;


-- date functions, time functions
SELECT NOW(), CURDATE(), CURTIME();
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), minute(NOW());
SELECT DAYNAME(NOW()), MONTHNAME(NOW());
SELECT EXTRACT(YEAR FROM NOW());

USE sql_store;

SELECT *
FROM orders
WHERE YEAR(order_date) = 2019;

SELECT *
FROM orders
WHERE YEAR(order_date) = YEAR(NOW());

SELECT date_format(NOW(), "%y"); -- gives you different formats of date
SELECT date_format(NOW(), "%Y");
SELECT date_format(NOW(), "%m %Y");
SELECT date_format(NOW(), "%M %Y");
SELECT date_format(NOW(), "%M %d %Y");
SELECT TIME_FORMAT(NOW(), "%H:%i %P"); -- gives you different formats for time




SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); -- adds one day to the date 
SELECT DATE_ADD(NOW(), INTERVAL -1 YEAR); -- goes back one year
SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR); -- goes back one year

SELECT DATEDIFF('2019-01-05', '2019-01-01'); -- gives date day differnece. if you swap the dates, you get negative value 	

SELECT TIME_TO_SEC('9:00') - TIME_TO_SEC('9:02'); -- gives the time differnece. in sec


-- IFNULL function

USE sql_store;

SELECT 
	order_id,
    IFNULL(shipper_id, 'Not Assigned') AS shipper -- if shipper is null then return Not Assigned
FROM orders;


SELECT 
	order_id,
    COALESCE(shipper_id, comments, 'Not Assigned') AS shipper -- if shipper is null then return the value in comments and if comments is null then return Not Assigned
FROM orders;


SELECT CONCAT(first_name, ' ', last_name) AS customer,
	IFNULL(phone, "UNKNOWN") AS Phone
FROM customers;



-- IF FUNCTION 

-- IF(expression, first, second)  if expression is TRUE, return FIRST, else, return SECOND


SELECT 
	order_id,
    order_date,
    IF(YEAR(order_date) = YEAR(NOW()), 'ACTIVE', 'ARCHIVED') AS Category 
FROM orders;

SELECT 
	p.product_id,
    p.name,
    SUM(o.quantity) AS quantity,
    IF(SUM(o.quantity) > 1, 'TO MANY', "one") AS Frequency
FROM products p
LEFT JOIN order_items o USING (product_id)
GROUP BY p.product_id, p.name;



-- Case expresion
-- Case is an alternative for if expression if we have multiple cases.

SELECT 
	order_id,
    order_date,
    CASE     -- we can add as many cases as we want 
		WHEN YEAR(order_date) = YEAR(NOW()) THEN "ACTIVE"
        WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'LAST YEAR'
        WHEN YEAR(order_date) < YEAR(NOW()) - 1 THEN 'ARCHIVED'
        ELSE 'Future'
	END AS Category
FROM orders;



-- example 
USE sql_store;

SELECT CONCAT(first_name, ' ',  last_name) AS "name",
	points,
	CASE 
		WHEN points > 3000 THEN "GOLD"
        WHEN points >= 2000 THEN "SILVER"
		ELSE "BRONZE"
	END AS 'rank'
FROM customers
ORDER BY points DESC;




-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<, VIEWS ,>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.
-- VIEWS CREATE a Copy of the table we create so we dont have to code again and we could just call the view to get the table
-- WHEN running the code below, you should refresh the left navigator page and then look at the views under tables section


CREATE VIEW client_ranking_by_points AS 
SELECT CONCAT(first_name, ' ',  last_name) AS "name",
	points,
	CASE 
		WHEN points > 3000 THEN "GOLD"
        WHEN points >= 2000 THEN "SILVER"
		ELSE "BRONZE"
	END AS 'rank'
FROM customers
ORDER BY points DESC;



-- after running the upper code we could just call the view we created instead of rewriting the code.

SELECT *
FROM client_ranking_by_points
ORDER BY points;

-- it is its own table and we could edit Join and modify it with other tables. 
-- VIEWs dont Store data


CREATE VIEW clients_balance AS
SELECT 
	c.name,
    c.client_id,
    SUM(i.invoice_total - i.payment_total) AS BALANCE 
FROM sql_invoicing.clients c 
JOIN sql_invoicing.invoices i USING (client_id)
GROUP BY c.name, c.client_id;


-- we could drop and delete the view by just saying : 

DROP VIEW clients_balance;

-- however a more prefered way is to use:

CREATE or REPLACE VIEW clients_balance AS    -- this will replace the last view with new update you make with the code
SELECT 
	c.name,
    c.client_id,
    SUM(i.invoice_total - i.payment_total) AS BALANCE 
FROM sql_invoicing.clients c 
JOIN sql_invoicing.invoices i USING (client_id)
GROUP BY c.name, c.client_id;


-- If this page is gone and you want access back to you code, you should save the query in a file and then use it later or share it with others.
-- OR 
-- go to the navigator bar and click on the edit mode of the view you are looking for. BUT it will change your code over there 




-- WE could use the views on places Like deleting. IF:
-- the view does not have any DISTICT, FUNCTIONS, GROUP BY, HAVING, UNION


USE sql_invoicing;
CREATE or REPLACE VIEW clients_balance AS    -- this will replace the last view with new update you make with the code
SELECT 
	i.invoice_id,
    i.invoice_total,
    i.payment_total,
    i.due_date,
    i.invoice_total - i.payment_total AS BALANCE 
FROM sql_invoicing.invoices i
WITH CHECK OPTION; -- tbh IDK what this does. Mosh said its for preventing deletion or updating extra rows or some like that..
-- in another words, by puting this statement, if you try to modify a row that will couse to the deletion of that row, it will give you an error.

DELETE FROM clients_balance   -- this is how we delete rows in  views.
WHERE invoice_id = 1;


UPDATE clients_balance  -- and this is how you update a view
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;


-- we could also insert rows into our tables, but we have to have every column available.
-- we use VIEWS for security reasons. sometimes, componies dont want us to see and modify thier data. so they give use views
-- we also uuse views as an abstract data so we dont have to modify our data.





-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< STORED PROCEDURES >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..


-- its just the functions


-- you can do all the stuff down by just double clicking on Stored Procedures section and select create stored procedures.
-- then write your code over there instead of changing the DLIMITER





USE sql_store

DELIMITER $$ 
-- since create procedure and its body are two different statement but we want to run them toghether, we change the delimitere ; to 
-- something new like && or $$ and the change it back to normal.
CREATE PROCEDURE get_clients()
BEGIN
    SELECT * FROM customers;
END $$

DELIMITER ;
 -- change it back to normal



CALL get_clients();   -- this is how we could call the procedure



DELIMITER $$
CREATE procedure sql_invoicing.get_invoices_with_balance()
BEGIN
	SELECT *
    FROM sql_invoicing.invoices i
    WHERE i.invoice_total - i.payment_total > 0;
END $$

DELIMITER ;


-- DROPING procedures

DROP PROCEDURE IF EXISTS get_clients


