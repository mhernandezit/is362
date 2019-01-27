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
What is the total distance flown by all of the planes in January 2013?  
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

SELECT sum(flights.distance), 
       planes.manufacturer 
FROM   flights 
       INNER JOIN planes 
               ON flights.tailnum = planes.tailnum 
WHERE  flights.month = '7' 
       AND flights.day = '5' 
       AND flights.year = '2013' 
GROUP  BY planes.manufacturer
order by planes.manufacturer; 

SELECT sum(flights.distance), 
       planes.manufacturer 
FROM   flights 
       left JOIN planes 
               ON flights.tailnum = planes.tailnum 
WHERE  flights.month = '7' 
       AND flights.day = '5' 
       AND flights.year = '2013' 
GROUP  BY planes.manufacturer; 
