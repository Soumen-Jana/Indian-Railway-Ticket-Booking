-- First,I rename the current table to keep a backup of the data.
ALTER TABLE Passengers RENAME TO Passengers_backup;

-- Now, create a new table with the same structure but without the UNIQUE constraints.
CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,  -- Removed UNIQUE constraint
    phone_number VARCHAR(15) NOT NULL,  -- Removed UNIQUE constraint
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL
);

-- Now, move the existing data from the old table into the new one.
INSERT INTO Passengers (passenger_id, name, email, phone_number, age, gender)
SELECT passenger_id, name, email, phone_number, age, gender FROM Passengers_backup;

SELECT COUNT(*) FROM Passengers;  -- New table
SELECT COUNT(*) FROM Passengers_backup;  -- Backup table


SET FOREIGN_KEY_CHECKS=0;

-- Once I've verified that all data has been transferred correctly, I drop the backup table.
DROP TABLE Passengers_backup;


SET FOREIGN_KEY_CHECKS=1;


--
INSERT INTO Passengers (passenger_id, name, email, phone_number, age, gender) VALUES
(201, 'Rahul Sharma', 'rahul.sharma@gmail.com', '9976543210', 28, 'Male'),
(202, 'Priya Singh', 'priya@gmail.com', '9823456789', 25, 'Female'),
(203, 'Aniket Das', 'aniket@gmail.com', '9734567890', 32, 'Male'),
(204, 'Rahul Sharma', 'rahul.sharma@gmail.com', '9976543210', 28, 'Male'),
(205, 'Priya Singh', 'priya@gmail.com', '9823456789', 25, 'Female');

INSERT INTO Passengers (passenger_id, name, email, phone_number, age, gender) VALUES
(206, 'Oldest Passenger', 'oldest.passenger@gmail.com', '9000000001', 120, 'Male');


INSERT INTO Passengers (passenger_id, name, email, phone_number, age, gender) VALUES
(213, 'Anjali Menon', 'Anjali_Menon@gmail.com', '9000000001', -20, 'Male'); -- Outlier in age
INSERT INTO Passengers (passenger_id, name, email, phone_number, age, gender) VALUES
(199, 'Ramesh Verma', 'ramesh.verma@gmail.com', '9000000001', 120, 'Male'), -- Outlier in age
(207, 'sUnil SHarma', 'sunil.SHARMA@example.com', '9000000002', 28, 'male'),  -- Inconsistent capitalization
(208, 'pRiya Aggrawal', 'priya.Aggrawal@EXAMPLE.com', '9000000003', 30, 'Female'),  -- Misspelled last name (should be "Agrawal")
(209, 'Amit Guptaa', 'amit.guptaa@email.com', '9000000004', 26, 'Male'),  -- Misspelled last name (should be "Gupta")
(210, 'Neha kumarri', 'neha.kumarri@email.com', '9000000005', 32, 'Female'),  -- Misspelled last name (should be "Kumari")
(211, 'roHIT Mehta', 'rohitMEHTA@email.com', '9000000006', 27, 'Male'),  -- Mixed casing
(212, 'Pooja iyer', 'pooja_iyer@gmail..com', '9000000007', 29, 'Female');  -- Email format issue (double dots)


-- Increasing payment amount to an unrealistic value
UPDATE Payments 
SET amount = 999999.99 
WHERE payment_id = 112;

-- Increasing payment amount to an unrealistic value
UPDATE Payments 
SET amount = 8999.99 
WHERE payment_id = .32;


-- Unrealistic number of train coaches
UPDATE Trains 
SET total_coaches = 1000 
WHERE train_id = 12;


-- Misspelled train name
UPDATE Trains 
SET train_name = 'Kalkata Shatabdi' 
WHERE train_id = 6;