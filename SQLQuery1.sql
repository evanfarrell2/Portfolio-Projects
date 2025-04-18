SELECT * FROM PortfolioProject..HousePrices
-----Filter to Dublin only ----
SELECT *
FROM PortfolioProject..HousePrices
WHERE LOWER(COUNTY) LIKE '%dublin%'
ORDER BY Date_Sale

--------Clean the dates 

SELECT SALE_DATE, CONVERT(Date,SALE_DATE)
FROM PortfolioProject..HousePrices

UPDATE HousePrices
SET SALE_DATE = CONVERT(Date, SALE_DATE)

ALTER TABLE HousePrices
ADD Date_Sale Date;

UPDATE HousePrices
SET Date_Sale = CONVERT(Date, SALE_DATE)

-----Avg sale price per year in Dublin--
SELECT YEAR(Date_Sale) AS year,
	   ROUND(AVG(SALE_PRICE), 0) AS avg_price
FROM PortfolioProject..HousePrices
WHERE LOWER(COUNTY) LIKE '%dublin%'
GROUP BY YEAR(Date_Sale)
ORDER BY year;

--number of sales per year ---
SELECT YEAR(Date_Sale) AS year,
    COUNT(*) AS number_of_sales
FROM PortfolioProject..HousePrices
WHERE LOWER(COUNTY) LIKE '%dublin%'
GROUP BY YEAR(Date_Sale)
ORDER BY year;

----avg price by property---
SELECT 
    PROPERTY_DESC,
    ROUND(AVG(SALE_PRICE), 0) AS avg_price
FROM PortfolioProject..HousePrices
WHERE LOWER(COUNTY) LIKE '%dublin%'
GROUP BY PROPERTY_DESC
ORDER BY avg_price DESC;


----delete unsused columns---
SELECT *
FROM PortfolioProject..HousePrices

Alter Table PortfolioProject..HousePrices
DROP COLUMN DateofSale
