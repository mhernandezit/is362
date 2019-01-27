# Michael Hernandez
# IS 362

/*
1. How many airplanes have listed speeds?  What is the minimum listed speed and the maximum listed speed?  
*/
SELECT Max(speed)   AS `Maximum Speed`, 
       Min(speed)   AS `Minimum Speed`, 
       Count(speed) AS `Planes with listed speeds` 
FROM   planes 
WHERE  speed IS NOT NULL;

/*
2. What is the total distance flown by all of the planes in January 2013?  
What is the total distance flown by all of the planes in January 2013 where the tailnum is missing?
*/
WITH fullsum AS 
( 
       SELECT Sum(distance) AS `distance OF ALL flights IN january 2013` 
       FROM   flights 
       WHERE  month= '1' 
       AND    year = '2013'), nullsum AS 
( 
       SELECT Sum(distance) AS `distance OF flights IN january 2013 without a tail number` 
       FROM   flights 
       WHERE  month = '1' 
       AND    year = '2013' 
       AND    tailnum = '') 
SELECT     * 
FROM       fullsum 
INNER JOIN nullsum;

/*
3. What is the total distance flown for all planes on July 5, 2013 grouped by aircraft manufacturer?  
Write this statement first using an INNER JOIN, then using a LEFT OUTER JOIN.  
How do your results compare? 
*/

SELECT Sum(flights.distance), 
       planes.manufacturer 
FROM   flights 
       INNER JOIN planes 
               ON flights.tailnum = planes.tailnum 
WHERE  flights.month = '7' 
       AND flights.day = '5' 
       AND flights.year = '2013' 
GROUP  BY planes.manufacturer 
ORDER  BY planes.manufacturer; 

SELECT Sum(flights.distance), 
       planes.manufacturer 
FROM   flights 
       LEFT JOIN planes 
              ON flights.tailnum = planes.tailnum 
WHERE  flights.month = '7' 
       AND flights.day = '5' 
       AND flights.year = '2013' 
GROUP  BY planes.manufacturer 
ORDER  BY planes.manufacturer; 

/*
4. What was the lowest recorded temperature in 2013 for each origin airport, and how many delays were caused by the 
low temperatures.  Provide enough information to analyze delay information by Manufacturer, Origin, and Tail number.
Export the result set to CSV
*/

WITH low_weather AS 
( 
         SELECT   Min(weather.temp) AS min_temp, 
                  weather.origin, 
                  weather.day, 
                  weather.month 
         FROM     weather 
         WHERE    year = '2013' 
         GROUP BY origin), flight_delays AS 
( 
       SELECT origin, 
              f.tailnum, 
              manufacturer, 
              f.year, 
              f.month, 
              f.day, 
              arr_delay 
       FROM   flights f 
       JOIN   planes p 
       ON     f.tailnum = p.tailnum) 
SELECT    low_weather.min_temp, 
          low_weather.origin, 
          flight_delays.year, 
          flight_delays.month, 
          flight_delays.day, 
          flight_delays.manufacturer, 
          flight_delays.tailnum, 
          flight_delays.arr_delay 
FROM      low_weather 
LEFT JOIN flight_delays 
ON        low_weather.origin = flight_delays.origin 
AND       low_weather.day = flight_delays.day 
AND       low_weather.month = flight_delays.month 
INTO OUTFILE 'C:/Users/Praetor/OneDrive - CUNY School of Professional Studies/is362/lowtempanalysis.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';