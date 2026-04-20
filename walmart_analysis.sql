WALMART SALES DATA - SQL ANALYSIS
Analyst: Yashika Bansikar
Tool: SQLite
Dataset: Walmart Weekly Sales 2010-2012


-- QUERY 1: Top 5 Stores by Total Sales
-- Business Question: Which Walmart store generates the most revenue?

SELECT c1 AS Store, 
SUM(CAST(c3 AS REAL)) AS Total_Sales
FROM Walmart
WHERE c1 != 'Store'
GROUP BY c1
ORDER BY Total_Sales DESC
LIMIT 5;

-- INSIGHT: Store 20 leads with $301M in total sales



-- QUERY 2: Holiday vs Normal Week Sales
-- Business Question: Do holidays actually boost Walmart sales?

SELECT 
CASE WHEN c4 = '1' THEN 'Holiday Week'
     ELSE 'Normal Week'
END AS Week_Type,
ROUND(AVG(CAST(c3 AS REAL)), 2) AS Avg_Weekly_Sales,
COUNT(*) AS Number_of_Weeks
FROM Walmart
WHERE c4 != 'Holiday_Flag'
GROUP BY c4
ORDER BY Avg_Weekly_Sales DESC;

-- INSIGHT: Holiday weeks average $1,122,887 vs Normal weeks at $1,041,256
-- Holidays boost sales by ~8% per week.
-- Note: Raw totals were misleading due to unequal sample sizes,
-- so AVG was used instead of SUM for a fair comparison.



-- QUERY 3: Top 5 Months by Total Sales
-- Business Question: Which month generates the highest revenue?

SELECT 
SUBSTR(c2, 4, 2) AS Month,
ROUND(SUM(CAST(c3 AS REAL)), 2) AS Total_Sales
FROM Walmart
WHERE c2 != 'Date'
GROUP BY SUBSTR(c2, 4, 2)
ORDER BY Total_Sales DESC
LIMIT 5;

-- INSIGHT: July (Month 07) is the top performing month at $650M,
-- contrary to expectations that December would lead due to holiday shopping.



-- QUERY 4: Temperature Impact on Sales
-- Business Question: Does weather affect how much people shop at Walmart?

SELECT 
CASE 
    WHEN CAST(c5 AS REAL) < 32 THEN 'Freezing (Below 32F)'
    WHEN CAST(c5 AS REAL) BETWEEN 32 AND 60 THEN 'Cold (32-60F)'
    WHEN CAST(c5 AS REAL) BETWEEN 61 AND 80 THEN 'Warm (61-80F)'
    ELSE 'Hot (Above 80F)'
END AS Temperature_Range,
ROUND(AVG(CAST(c3 AS REAL)), 2) AS Avg_Weekly_Sales,
COUNT(*) AS Number_of_Weeks
FROM Walmart
WHERE c5 != 'Temperature'
GROUP BY Temperature_Range
ORDER BY Avg_Weekly_Sales DESC;


-- INSIGHT: Cold weather (32-60F) drives the highest average weekly sales at $1,079,583.
-- Hot weather (above 80F) shows the lowest at $953,590.
-- Suggests customers prefer in-store shopping in cooler temperatures.



-- QUERY 5: Fuel Price Impact on Sales
-- Business Question: Does the cost of fuel affect Walmart shopping behaviour?

SELECT 
CASE 
    WHEN CAST(c6 AS REAL) < 2.5 THEN 'Low Fuel Price (Below $2.5)'
    WHEN CAST(c6 AS REAL) BETWEEN 2.5 AND 3.0 THEN 'Medium ($2.5-$3.0)'
    WHEN CAST(c6 AS REAL) BETWEEN 3.0 AND 3.5 THEN 'High ($3.0-$3.5)'
    ELSE 'Very High (Above $3.5)'
END AS Fuel_Price_Range,
ROUND(AVG(CAST(c3 AS REAL)), 2) AS Avg_Weekly_Sales,
COUNT(*) AS Number_of_Weeks
FROM Walmart
WHERE c6 != 'Fuel_Price'
GROUP BY Fuel_Price_Range
ORDER BY Avg_Weekly_Sales DESC;

-- INSIGHT: Fuel price shows minimal impact on Walmart sales.
-- Medium, High and Very High fuel price ranges all average around $1.04M-$1.06M.
-- Suggests customers shop at Walmart consistently regardless of fuel costs,
-- possibly because Walmart is a necessity destination



-- QUERY 6: Unemployment Rate Impact on Sales
-- Business Question: Does high unemployment drive more people to budget shop at Walmart?

SELECT 
CASE 
    WHEN CAST(c8 AS REAL) < 6 THEN 'Low Unemployment (Below 6%)'
    WHEN CAST(c8 AS REAL) BETWEEN 6 AND 8 THEN 'Medium (6-8%)'
    WHEN CAST(c8 AS REAL) BETWEEN 8 AND 10 THEN 'High (8-10%)'
    ELSE 'Very High (Above 10%)'
END AS Unemployment_Range,
ROUND(AVG(CAST(c3 AS REAL)), 2) AS Avg_Weekly_Sales,
COUNT(*) AS Number_of_Weeks
FROM Walmart
WHERE c8 != 'Unemployment'
GROUP BY Unemployment_Range
ORDER BY Avg_Weekly_Sales DESC;

-- INSIGHT: Contrary to the popular Walmart Effect theory,
-- sales actually DECLINE during high unemployment periods.
-- Low unemployment drives $1,180,603 avg weekly sales vs
-- Very High unemployment at only $841,882 -- a $338,000 difference!



-- QUERY 7: Year over Year Sales Performance
-- Business Question: Which year was Walmart's strongest performer?

SELECT 
SUBSTR(c2, 7, 4) AS Year,
ROUND(SUM(CAST(c3 AS REAL)), 2) AS Total_Sales,
ROUND(AVG(CAST(c3 AS REAL)), 2) AS Avg_Weekly_Sales,
COUNT(*) AS Number_of_Weeks
FROM Walmart
WHERE c2 != 'Date'
GROUP BY SUBSTR(c2, 7, 4)
ORDER BY Total_Sales DESC;

-- INSIGHT: While 2011 showed highest total revenue at $2.44B,
-- 2010 had the strongest average weekly performance at $1,059,669.
-- This highlights the importance of normalizing for time periods
-- when comparing annual performance.



