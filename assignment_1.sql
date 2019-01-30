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
Answer: 
The minimum speed of an airplane is 90
The maximum speed of an airplane is 432
23 airplanes have listed speeds
*/

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
Answer: 
The total distance flown by all planes in January 2013 is 27188805
The distance flown for planes that have no tailnums is 81763
*/

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
Answer: 
Here is the query results:
# Sum(flights.distance), manufacturer
195089, AIRBUS
78786, AIRBUS INDUSTRIE
2199, AMERICAN AIRCRAFT INC
937, BARKER JACK L
335028, BOEING
31160, BOMBARDIER INC
1142, CANADAIR
2898, CESSNA
1089, DOUGLAS
77909, EMBRAER
1157, GULFSTREAM AEROSPACE
7486, MCDONNELL DOUGLAS
15690, MCDONNELL DOUGLAS AIRCRAFT CO
4767, MCDONNELL DOUGLAS CORPORATION

The query with the left join counts the distance of planes that do not have a manufacturer field:

# Sum(flights.distance), manufacturer
127671, 
195089, AIRBUS
78786, AIRBUS INDUSTRIE
2199, AMERICAN AIRCRAFT INC
937, BARKER JACK L
335028, BOEING
31160, BOMBARDIER INC
1142, CANADAIR
2898, CESSNA
1089, DOUGLAS
77909, EMBRAER
1157, GULFSTREAM AEROSPACE
7486, MCDONNELL DOUGLAS
15690, MCDONNELL DOUGLAS AIRCRAFT CO
4767, MCDONNELL DOUGLAS CORPORATION
*/

/*
4. Is there a correlation between temperature and delays?  Is there a higher average delay in the summer or winter months?
Are there any months which have a negative delay (more on time flights than delayed)?
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
                    ON w.day = f.day 
                       AND w.month = f.month 
					   and w.hour = f.hour
                       and w.year = f.year
       INNER JOIN planes p 
               ON f.tailnum = p.tailnum
               where w.year = '2013'
INTO OUTFILE 'C:/Users/Praetor/OneDrive - CUNY School of Professional Studies/is362/weatherdata.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'; 
/*
There is not a direct correlation with average delay to temperature - from the data it looks like the highest average delays are 
in the winter and summer months.  Interestingly, the months of May, August and September have significantly lower average delays
than the other months.  It would make more sense to travel through these months to avoid delays.
*/