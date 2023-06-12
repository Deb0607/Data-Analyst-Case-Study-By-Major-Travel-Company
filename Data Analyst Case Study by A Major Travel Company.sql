USE data_lamur;

CREATE TABLE user_details(
User_id VARCHAR(3) NOT NULL,
Segment VARCHAR(2) NOT NULL,
PRIMARY KEY (User_id)
);

CREATE TABLE booking_details(
Booking_id VARCHAR(3) NOT NULL,
Booking_Date DATE NOT NULL,
User_id VARCHAR(3) NOT NULL,
Line_of_business VARCHAR(10) NOT NULL,
PRIMARY KEY(Booking_id)
);

ALTER TABLE booking_details
ADD FOREIGN KEY (User_id) REFERENCES user_details(User_id);



INSERT INTO user_details(User_id,Segment) VALUES ('u1','s1');
INSERT INTO user_details(User_id,Segment) VALUES ('u2','s1');
INSERT INTO user_details(User_id,Segment) VALUES ('u3','s1');
INSERT INTO user_details(User_id,Segment) VALUES ('u4','s2');
INSERT INTO user_details(User_id,Segment) VALUES ('u5','s2');
INSERT INTO user_details(User_id,Segment) VALUES ('u6','s3');
INSERT INTO user_details(User_id,Segment) VALUES ('u7','s3');
INSERT INTO user_details(User_id,Segment) VALUES ('u8','s3');
INSERT INTO user_details(User_id,Segment) VALUES ('u9','s3');
INSERT INTO user_details(User_id,Segment) VALUES ('u10','s3');



INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b1','2022-03-23','u1','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b2','2022-03-27','u2','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b3','2022-03-28','u1','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b4','2022-03-31','u4','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b5','2022-04-02','u1','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b6','2022-04-02','u2','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b7','2022-04-06','u5','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b8','2022-04-06','u6','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b9','2022-04-06','u2','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b10','2022-04-10','u1','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b11','2022-04-12','u4','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b12','2022-04-16','u1','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b13','2022-04-19','u2','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b14','2022-04-20','u5','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b15','2022-04-22','u6','Flight');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b16','2022-04-26','u4','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b17','2022-04-28','u2','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b18','2022-04-30','u1','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b19','2022-05-04','u4','Hotel');
INSERT INTO booking_details(Booking_id,Booking_Date,User_id,Line_of_business) VALUES ('b20','2022-05-06','u1','Flight');
;

SELECT * FROM booking_details;

SELECT * FROM user_details;

/* Q-1:: Write an Sql query that gives the below output.
Segment || Total_user_count || User_who_booked_flight_in_Apr2022 */

SELECT
u.Segment,
COUNT(DISTINCT u.User_id) AS Total_user_count,
COUNT(DISTINCT CASE WHEN b.Line_of_business = 'Flight' AND b.Booking_Date BETWEEN '2022-04-01' AND '2022-04-30' THEN b.User_id ELSE NULL END)
AS User_who_booked_flight_in_Apr2022
FROM user_details AS u
LEFT JOIN booking_details AS b
	ON u.User_id = b.User_id
GROUP BY
u.Segment;


/* Q-2:: Write a query  to identify the users whose first booking was a hotel booking */

-- USING RANK() FUNCTION--
WITH First_Booking AS 
(SELECT *,
RANK() OVER (PARTITION BY User_id ORDER BY Booking_Date ASC) AS rn
FROM booking_details)
SELECT User_id FROM First_Booking
WHERE rn = 1 AND Line_of_business = 'Hotel';

-- USING FIRST_VALUE() FUNCTION--
WITH CTE1 AS(
SELECT *,
FIRST_VALUE(Line_of_business) OVER (PARTITION BY User_id ORDER BY Booking_Date ASC) AS Fisrt_Booking
FROM booking_details)
SELECT DISTINCT(User_id) FROM CTE1 WHERE Fisrt_Booking = 'Hotel';

-- USING ROW_NUMBER() FUNCTION--
WITH CTE2 AS(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY User_id ORDER BY Booking_Date ASC) AS rn
FROM booking_details)
SELECT User_id FROM CTE2 WHERE rn = 1 AND Line_of_business = 'Hotel'

/* Q-3:: Write a query to calculate the days between first & last booking of each user */

WITH CTE1 AS(
SELECT *,
FIRST_VALUE(Booking_Date) OVER (PARTITION BY User_id ORDER BY Booking_Date ASC) AS First_Booking_Date,
FIRST_VALUE(Booking_Date) OVER (PARTITION BY User_id ORDER BY Booking_Date DESC) AS Last_Booking_Date
FROM booking_details)
SELECT DISTINCT(User_id) ,
DATEDIFF(DAY,First_Booking_Date,Last_Booking_Date) AS No_of_days_between_first_and_last_booking
FROM CTE1;


/* Q-4:: Write a Query to count number of flight and hotel bookings in each of the user segments for the year 2022 */


EXEC sp_help 'dbo.user_details';