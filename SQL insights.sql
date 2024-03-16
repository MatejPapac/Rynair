--What is the average overall rating for each passenger country with more that 10 flights?
WITH agg AS (
    SELECT 
        AVG(overall_rating) AS average,
        COUNT(overall_rating) AS number_of_flights,
        origin
    FROM ryanair_dataset 
    GROUP BY origin
    ORDER BY average DESC
)
SELECT 
    average,
    origin
FROM agg
WHERE number_of_flights > 10;



--How many flights were there each month?
SELECT extract(MONTH from date_flown::date) AS month, COUNT(*) AS number_of_flights
FROM ryanair_dataset
WHERE date_flown IS NOT NULL
GROUP BY month
ORDER BY month ASC;

--What is the distribution of seat comfort ratings?

SELECT seat_comfort, COUNT(*) AS frequency
FROM ryanair_dataset
GROUP BY seat_comfort
ORDER BY seat_comfort;


--What are the top 10 most popular destinations?
SELECT destination, COUNT(*) AS number_of_flights
FROM ryanair_dataset
GROUP BY destination
ORDER BY number_of_flights DESC
LIMIT 10;

--What percentage of passengers recommend Ryanair, and how does it vary by seat type (Economy/Business)?
SELECT seat_type,
       ROUND(COUNT(CASE WHEN recommended = 'yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS recommend_percentage
FROM ryanair_dataset
GROUP BY seat_type;

--What are the average ratings for seat comfort, 
--cabin staff service, food & beverages, and value for money by type of traveller (Solo, Family, Couple)?
SELECT type_of_traveller,
       AVG(seat_comfort) AS average_seat_comfort,
       AVG(cabin_staff_service) AS average_cabin_staff_service,
       AVG(food_beverages) AS average_food_beverages,
       AVG(value_for_money) AS average_value_for_money
FROM ryanair_dataset
GROUP BY type_of_traveller;


--Do verified trips have higher or lower average ratings compared to non-verified trips?
SELECT trip_verified, AVG(overall_rating) AS average_rating
FROM ryanair_dataset
GROUP BY trip_verified;


--How have the overall ratings and individual service component ratings 
--(cabin staff service, food & beverages, etc.) trended over the last year?
SELECT to_char(date_flown::date, 'YYYY-MM') AS month,
       AVG(overall_rating) OVER (ORDER BY to_char(date_flown::date, 'YYYY-MM')) AS avg_overall_rating,
       AVG(seat_comfort) OVER (ORDER BY to_char(date_flown::date, 'YYYY-MM')) AS avg_seat_comfort,
       AVG(cabin_staff_service) OVER (ORDER BY to_char(date_flown::date, 'YYYY-MM')) AS avg_cabin_staff_service
FROM ryanair_dataset
WHERE date_flown IS NOT NULL
GROUP BY month, overall_rating, seat_comfort, cabin_staff_service
ORDER BY month DESC;

--How do average ratings vary by aircraft family?
SELECT aircraft_family,
       AVG(overall_rating) AS average_overall_rating,
       AVG(seat_comfort) AS average_seat_comfort,
       AVG(cabin_staff_service) AS average_cabin_staff_service,
       AVG(food_beverages) AS average_food_beverages,
       AVG(ground_service) AS average_ground_service
FROM ryanair_dataset
GROUP BY aircraft_family
ORDER BY average_overall_rating;
