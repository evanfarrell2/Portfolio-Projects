SELECT * FROM PortfolioProject..AgeGroups
----clean data-----
ALTER TABLE AgeGroups
DROP COLUMN F3, F4, F5, F7

EXEC sp_rename 'AgeGroups.Census Year','Year', 'COLUMN'; 
EXEC sp_rename 'AgeGroups.%','Percentage', 'COLUMN';

-----------Home Ownership for 23–29 Age Group Over Time
SELECT Year,ROUND(SUM(CASE 
WHEN [Nature of Occupancy] IN (
     'Owner occupied with loan or mortgage', 
     'Owner occupied without loan or mortgage') 
      THEN Number 
           ELSE 0 
            END) * 1.0 / SUM(Number) * 100, 2) AS OwnershipPercentage
FROM PortfolioProject..AgeGroups
WHERE AgeBracket = '25 - 29 years'
GROUP BY Year
ORDER BY Year;
----------Age Groups (25–29 vs 30–39) Owners

SELECT AgeBracket,Year,SUM(Number) AS TotalOwners
FROM PortfolioProject..AgeGroups
WHERE AgeBracket IN ('25 - 29 years', '30 - 34 years', '35 - 39 years')
AND [Nature of Occupancy] = ('Owner occupied with loan or mortgage') 
GROUP BY AgeBracket, Year
ORDER BY Year, AgeBracket;

-----Age Groups (25–29 vs 30–39) Renters
SELECT AgeBracket,Year,SUM(Number) AS TotalRenters
FROM PortfolioProject..AgeGroups
WHERE AgeBracket IN ('25 - 29 years', '30 - 34 years', '35 - 39 years')
AND [Nature of Occupancy] IN ('Rented from private landlord', 'Rented from a local authority', 'Rented from a voluntary body') 
GROUP BY AgeBracket, Year
ORDER BY Year, AgeBracket;


-----Rent for 23–29 Age Group Over Time

SELECT Year,SUM(Number) AS TotalRenters
FROM PortfolioProject..AgeGroups
WHERE AgeBracket IN ('Under 25 years', '25 - 29 years')
  AND [Nature of Occupancy] IN ('Rented from private landlord', 'Rented from a local authority', 'Rented from a voluntary body')
GROUP BY Year
ORDER BY Year;

----- % of renters between 25-29 years

SELECT Year, ROUND(SUM(CASE WHEN [Nature of Occupancy] IN (
       'Rented from private landlord', 
       'Rented from a local authority', 
       'Rented from a voluntary body') 
        THEN Number 
             ELSE 0 
            END) * 1.0 
        / SUM(Number) * 100, 2) AS RentersPercentage
FROM PortfolioProject..AgeGroups
WHERE AgeBracket IN ('25 - 29 years', '30 - 34 years', '35 - 39 years')
GROUP BY Year
ORDER BY Year;


--------- rent per age group bracket

SELECT 
    Year, 
    AgeBracket,
    ROUND(
        SUM(CASE 
                WHEN [Nature of Occupancy] IN (
                    'Rented from private landlord', 
                    'Rented from a local authority', 
                    'Rented from a voluntary body') 
                THEN Number 
                ELSE 0 
            END) * 1.0 / SUM(Number) * 100, 2
    ) AS RentersPercentage
FROM PortfolioProject..AgeGroups
WHERE AgeBracket IN ('25 - 29 years', '30 - 34 years', '35 - 39 years')
GROUP BY Year, AgeBracket
ORDER BY Year, AgeBracket;

