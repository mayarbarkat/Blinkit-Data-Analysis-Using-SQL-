SELECT * FROM blinkit;
SELECT COUNT(*) FROM blinkit;
-- DATA CLEANING
SELECT Distinct item_Fat_Content FROM blinkit;

UPDATE blinkit
SET item_Fat_Content = 'Low Fat'
WHERE item_Fat_Content = 'LF';

UPDATE blinkit
SET item_Fat_Content = 'Regular'
WHERE item_Fat_Content = 'reg';

UPDATE blinkit
SET item_Fat_Content = LOWER(item_Fat_Content);


-- ANOTHER SOLUTION THAT DOES THE SAME WORK USING CASE STATEMENT 
Update blinkit 
SET item_Fat_CONTENT =
CASE WHEN item_Fat_Content IN ('LF', 'lower fat') THEN 'Low Fat'
     WHEN item_Fat_Content = 'reg' THEN 'Regular'
	 ELSE item_Fat_Content
END ;

-- DATA ANALYSIS 
-- KPI Requirements
-- 1 total revenue:
SELECT SUM(Total_Sales) FROM blinkit;
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)),' MILLIONS') AS Total_Revenue FROM blinkit;
-- 2 Total revenue of Low Fat
SELECT CONCAT(CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)),' MILLIONS') AS Total_Revenue FROM blinkit WHERE item_Fat_Content = 'Low Fat';
-- 3 average sale 
SELECT AVG(Total_Sales) as avg_revenue FROM blinkit;
SELECT CAST(AVG(Total_Sales) AS DECIMAL(3,0)) as avg_revenue FROM blinkit;
-- 4 average rating of our sales
SELECT CAST(AVG(Rating) AS DECIMAL(3,1)) as avg_Rating FROM blinkit; 
-- Granular Requirements
-- 1 average customer rating for each item type
SELECT item_Type, CAST(AVG(Rating) AS DECIMAL(10,1)) as average_rating From blinkit GROUP BY item_Type ORDER BY average_rating DESC;
-- 2  number of items sold of each outlet type 
SELECT Outlet_Type, COUNT(*) AS number_of_sales FROM  blinkit GROUP BY Outlet_Type; 
-- 3 number and revenue  of items sold of each item type 
SELECT item_Type, COUNT(*) AS number_of_sales,CONCAT(CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,0)),' K') AS Total_revenue FROM  blinkit GROUP BY item_Type ORDER BY number_of_sales DESC ; 
-- TOP FIVE 
SELECT TOP 5 item_Type, COUNT(*) AS number_of_sales,CONCAT(CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,0)),' K') AS Total_revenue FROM  blinkit GROUP BY item_Type ORDER BY number_of_sales DESC ; 


-- 4 number of sales by outlet size ( to see how the outlet size and location type effect the sales)
SELECT Outlet_Size, Outlet_Location_Type , COUNT(*) AS number_of_sales, SUM(Total_Sales) AS Total_revenue FROM blinkit GROUP BY Outlet_Location_Type,Outlet_Size ORDER by 1,2 ;
-- 5 total sales by outlet establishsment ( to see how the age of the outlet influence the sales)
SELECT Outlet_Establishment_Year , COUNT(*) AS number_of_sales , SUM(Total_Sales) AS Total_revenue FROM blinkit GROUP BY Outlet_Establishment_Year

SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

SELECT Outlet_Location_Type, Item_Fat_Content, 
       CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit
GROUP BY Outlet_Location_Type, Item_Fat_Content


-- 6 percentage sale by outlet size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;