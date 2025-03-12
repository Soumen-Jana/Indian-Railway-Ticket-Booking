 -- What is the age and gender distribution of passengers?
 SELECT 
    gender,
    CASE 
        WHEN age BETWEEN 0 AND 17 THEN '0-17'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+' 
    END AS age_group,
    COUNT(*) AS total_passengers
FROM Passengers
GROUP BY gender, age_group
ORDER BY gender, age_group;

-- Who are the top 10 frequent travelers?

SELECT p.passenger_id, p.name, p.email, COUNT(r.reservation_id) AS total_trips
FROM Reservations r
JOIN Passengers p ON r.passenger_id = p.passenger_id
GROUP BY p.passenger_id, p.name, p.email
ORDER BY total_trips DESC
LIMIT 10;

-- Which passengers have the highest spending on tickets?

SELECT p.passenger_id, p.name, p.email, SUM(py.amount) AS total_spent
FROM Payments py
JOIN Reservations r ON py.reservation_id = r.reservation_id
JOIN Passengers p ON r.passenger_id = p.passenger_id
WHERE py.payment_status = 'Success'  -- Only consider successful payments
GROUP BY p.passenger_id, p.name, p.email
ORDER BY total_spent DESC
LIMIT 10;

-- What are the top 5 busiest train routes?
SELECT ts.source_station, ts.destination_station, COUNT(r.reservation_id) AS total_bookings
FROM Reservations r
JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id
GROUP BY ts.source_station, ts.destination_station
ORDER BY total_bookings DESC
LIMIT 5;

-- Which trains have the longest travel duration?

SELECT t.train_id, t.train_name, ts.source_station, ts.destination_station, ts.travel_duration
FROM Train_Schedule ts
JOIN Trains t ON ts.train_id = t.train_id
ORDER BY ts.travel_duration DESC
LIMIT 5;

-- Which month has the highest number of ticket bookings?

SELECT MONTHNAME(booking_date) AS month, 
       COUNT(reservation_id) AS total_bookings
FROM Reservations
GROUP BY MONTH(booking_date), MONTHNAME(booking_date)
ORDER BY total_bookings DESC
LIMIT 1;

-- How many reservations get confirmed vs. on the waiting list?

SELECT status, COUNT(reservation_id) AS total_reservations
FROM Reservations
GROUP BY status;

-- What is the percentage of last-minute bookings (less than 24 hours before departure)?

SELECT 
    (COUNT(CASE WHEN TIMESTAMPDIFF(HOUR, booking_date, journey_date) < 24 THEN 1 END) * 100.0 / COUNT(*)) 
    AS last_minute_booking_percentage
FROM Reservations;

-- What is the total revenue earned per train type?

SELECT t.train_type, SUM(p.amount) AS total_revenue
FROM Payments p
JOIN Reservations r ON p.reservation_id = r.reservation_id
JOIN Trains t ON r.train_id = t.train_id
WHERE p.payment_status = 'Success'
GROUP BY t.train_type
ORDER BY total_revenue DESC;

-- What payment mode is used the most by passengers?

SELECT payment_mode, COUNT(payment_id) AS total_transactions
FROM Payments
WHERE payment_status = 'Success'
GROUP BY payment_mode
ORDER BY total_transactions DESC;

-- What is the cancellation rate per train type and route?

SELECT 
    t.train_type, 
    ts.source_station, 
    ts.destination_station,
    COUNT(c.cancellation_id) AS total_cancellations,
    COUNT(r.reservation_id) AS total_reservations,
    ROUND((COUNT(c.cancellation_id) * 100.0 / COUNT(r.reservation_id)), 2) AS cancellation_rate
FROM Reservations r
JOIN Train_Schedule ts ON r.schedule_id = ts.schedule_id
JOIN Trains t ON r.train_id = t.train_id
LEFT JOIN Cancellation c ON r.reservation_id = c.reservation_id
GROUP BY t.train_type, ts.source_station, ts.destination_station
ORDER BY cancellation_rate DESC;

-- What are the top 3 reasons for cancellations?

SELECT reason, COUNT(cancellation_id) AS total_cancellations
FROM Cancellation
WHERE reason IS NOT NULL AND reason <> ''
GROUP BY reason
ORDER BY total_cancellations DESC
LIMIT 3;

-- What is the average refund amount given per cancellation?

SELECT 
    ROUND(AVG(refund_amount), 2) AS average_refund
FROM Cancellation
WHERE refund_amount IS NOT NULL;










