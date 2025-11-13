-- create a database to import the cleaned dataset from python 
create database dangcem;
-- import the clean dataset from python 

-- perform data transformation to change the date format to normal sql date format
UPDATE cleaned_sales
SET 
    Date = DATE_FORMAT(STR_TO_DATE(Date, '%m/%d/%Y'),
            '%Y/%m/%d'); 

-- stock data
UPDATE cleaned_stock
SET 
    Date = DATE_FORMAT(STR_TO_DATE(Date, '%m/%d/%Y'),
            '%Y/%m/%d'); 
            
            -- change the datatype to date 
alter table cleaned_stock modify column Date date;
alter table cleaned_sales modify column Date date;


-- OBJECTIES
-- 1. Evaluate sales performance across multiple dimensions — region, product, and time period.
SELECT
    Region,
    Product,
    Year,
    MonthName AS Month,
    SUM(Quantity_Sold) AS Total_Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(COGS) AS Total_COGS,
    SUM(Profit) AS Total_Profit,
    AVG(Unit_Price) AS Avg_Unit_Price,
    AVG(ProfitMargin) AS Avg_Profit_Margin,
    COUNT(*) AS Total_Transactions
FROM
    cleaned_sales
GROUP BY
    Region,
    Product,
    Year,
    MonthName
ORDER BY
    Region,
    Product,
    Year,
    Month;



-- 2. Simple inventory efficiency
SELECT
    Product,
    Region,
    SUM(Quantity_Sold) AS Total_Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    AVG(ProfitMargin) AS Avg_Profit_Margin,
    -- Simple sales velocity category
    CASE
        WHEN SUM(Quantity_Sold) < 1000 THEN 'Slow-Moving'
        WHEN SUM(Quantity_Sold) BETWEEN 5000 AND 10000 THEN 'Moderate'
        ELSE 'Fast-Moving'
    END AS Sales_Velocity
FROM
    cleaned_sales
WHERE
    Payment_Status != 'Pending'  -- Only consider completed sales
GROUP BY
    Product,
    Region
ORDER BY
    Region,
    Product;


-- 3. Analyze profitability metrics
SELECT
    Product,
    Region,
    SUM(Revenue) AS Total_Revenue,
    SUM(COGS) AS Total_COGS,
    SUM(Profit) AS Total_Profit,
    AVG(ProfitMargin) AS Avg_Profit_Margin,
    COUNT(*) AS Total_Transactions
FROM
    cleaned_sales
WHERE
    Payment_Status != 'Pending'  -- Only include completed sales
GROUP BY
    Product,
    Region
ORDER BY
    Region,
    Product;


-- 4 -- Analyze customer and payment behavior
SELECT
    Region,
    Product,
    Payment_Status,
    COUNT(*) AS Number_of_Transactions,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    AVG(ProfitMargin) AS Avg_Profit_Margin,
    SUM(Quantity_Sold) AS Total_Units_Sold
FROM
    cleaned_sales
GROUP BY
    Region,
    Product,
    Payment_Status
ORDER BY
    Region,
    Product,
    Payment_Status;


-- -- Simple stock analysis: daily price range
SELECT
    Date,
    Open,
    High,
    Low,
    Close,
    High - Low AS Daily_Price_Range,
    Volume
FROM
    cleaned_stock
ORDER BY
    Date;
