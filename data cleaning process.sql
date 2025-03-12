SELECT * FROM Passengers;
SELECT * FROM Trains;
SELECT * FROM train_schedule;
SELECT * FROM reservations;
SELECT * FROM payments;
SELECT * FROM cancellation;

-- Check for NULL values:

SELECT * FROM Passengers WHERE name IS NULL OR email IS NULL OR phone_number IS NULL OR age IS NULL OR gender IS NULL;

SELECT * FROM Trains WHERE train_name IS NULL OR train_type IS NULL OR total_coaches IS NULL;

SELECT * FROM Train_Schedule WHERE train_id IS NULL OR source_station IS NULL OR destination_station IS NULL 
OR departure_time IS NULL OR arrival_time IS NULL OR travel_duration IS NULL;

SELECT * FROM Reservations WHERE booking_date IS NULL OR journey_date IS NULL;

SELECT * FROM Payments WHERE amount IS NULL OR transaction_date IS NULL;

SELECT * FROM cancellation WHERE refund_amount IS NULL OR cancellation_date IS NULL;
-- There are no NULL values in any tables.

-- check for Duplicates:

SELECT name, email, phone_number, age,gender, COUNT(*) 
FROM Passengers 
GROUP BY name, email, phone_number, age, gender
HAVING COUNT(*) > 1;

SELECT train_name,train_type,total_coaches, COUNT(*) 
FROM trains 
GROUP BY  train_name,train_type,total_coaches
HAVING COUNT(*) > 1;

SELECT source_station, destination_station,departure_time,arrival_time,travel_duration, COUNT(*) 
FROM Train_Schedule 
GROUP BY source_station, destination_station,departure_time,arrival_time,travel_duration
HAVING COUNT(*) > 1;

SELECT amount,payment_mode,payment_status, transaction_date, COUNT(*) 
FROM Payments 
GROUP BY  amount,payment_mode,payment_status, transaction_date
HAVING COUNT(*) > 1;

SELECT refund_amount,cancellation_date, reason, COUNT(*) 
FROM Cancellation 
GROUP BY refund_amount,cancellation_date, reason
HAVING COUNT(*) > 1;

SELECT booking_date, journey_date,status,  COUNT(*) 
FROM Reservations 
GROUP BY booking_date, journey_date,status
HAVING COUNT(*) > 1;

-- Into this all queries there is no duplicate except the passenger table

-- Remove duplicates:

SELECT * FROM Passengers p1
JOIN Passengers p2 
ON p1.email = p2.email 
AND p1.phone_number = p2.phone_number 
AND p1.passenger_id > p2.passenger_id;

SET SQL_SAFE_UPDATES = 0;

DELETE p1 FROM Passengers p1
JOIN Passengers p2 
ON p1.email = p2.email 
AND p1.phone_number = p2.phone_number 
AND p1.passenger_id > p2.passenger_id;

SET SQL_SAFE_UPDATES = 1;
-- deleting all duplicates in passengers table.

-- Inconsistent capitalization correction:

UPDATE Passengers 
SET name = CONCAT(
    UPPER(LEFT(name, 1)), 
    LOWER(SUBSTRING(name, 2))
);

-- Misspelled last name correction:
UPDATE Passengers 
SET name = 'Priya Agrawal' 
WHERE name = 'pRiya Aggrawal';

UPDATE Passengers 
SET name = 'Amit Gupta' 
WHERE name = 'Amit Guptaa';

UPDATE Passengers 
SET name = 'Neha Kumari' 
WHERE name = 'Neha kumarri';

-- Email format issue (double dots):
UPDATE Passengers 
SET email = REPLACE(email, '..', '.')
WHERE email LIKE '%..%';

-- Finding Outliers :

SELECT * FROM passengers WHERE age <1 OR age > 85;  

-- Replace outlier with an estimated correct value:

UPDATE Passengers 
SET age = 20  
WHERE passenger_id = 213;

-- Delete Invalid Age Records :

DELETE FROM Passengers 
WHERE age < 0 OR age > 100;


-- Finding outliers for train coaches:

SElECT * FROM trains WHERE total_coaches <5 OR total_coaches>19;

-- Replace outlier with an estimated correct value:
UPDATE trains 
SET total_coaches = 10
WHERE train_id = 12;

-- FINDING outliers for amount from payments table :

SELECT * FROM payments WHERE amount <400 OR amount> 2000;

UPDATE payments
SET amount = 999.99
WHERE payment_id = 32;


UPDATE payments
SET amount = 999.99
WHERE payment_id = 112;

-- FINDING outlier for refund_amount from cancellation table :
SELECT * FROM CANCELLATION WHERE refund_amount <400 OR refund_amount>2000;

