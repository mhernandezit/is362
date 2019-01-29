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
4. What were the minimum and maximum recorded temperatures in 2013 for EWR (the other origins do not have enough data to be 
statistically significant), and how many delays were caused by the low temperatures?  
Provide enough information to analyze delay information by Date, Manufacturer and Tail number.
Export the result set to CSV
*/

SELECT w.temp, 
       w.origin, 
       Concat(w.month, '/', w.day, '/', w.year) AS wdate,
       w.hour,
       f.tailnum, 
       IFNULL(f.arr_delay, 0), 
       p.manufacturer 
FROM   weather w 
       LEFT OUTER JOIN flights f 
                    ON w.origin = f.origin 
                       AND w.day = f.day 
                       AND w.month = f.month 
					   and w.hour = f.hour
                       and w.year = f.year
       INNER JOIN planes p 
               ON f.tailnum = p.tailnum
               where w.year = '2013' and w.origin = 'EWR'
               
INTO OUTFILE 'C:/Users/Praetor/OneDrive - CUNY School of Professional Studies/is362/weatherdata.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 

select temp, origin from weather where origin = 'JFK';