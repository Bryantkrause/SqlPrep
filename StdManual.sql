-- Step 1: Calculate Average TotalDue for Each Customer
use AdventureWorks2022;
WITH
    CustomerAvg
    AS
    (
        SELECT
            CustomerID,
            AVG(TotalDue) AS AvgTotalDue
        FROM
            Sales.SalesOrderHeader
        GROUP BY 
        CustomerID
    ),

    -- Step 2: Calculate Squared Differences for Each Transaction and Sum them
    CustomerVariance
    AS
    (
        SELECT
            soh.CustomerID,
            SUM(POWER(soh.TotalDue - ca.AvgTotalDue, 2)) AS SumOfSquaredDiffs,
            COUNT(soh.SalesOrderID) AS TransactionCount,
            ca.AvgTotalDue
        FROM
            Sales.SalesOrderHeader AS soh
            JOIN
            CustomerAvg AS ca ON soh.CustomerID = ca.CustomerID
        GROUP BY 
        soh.CustomerID, ca.AvgTotalDue
    ),

    -- Step 3: Calculate Standard Deviation Manually
    CustomerStdDev
    AS
    (
        SELECT
            CustomerID,
            AvgTotalDue,
            CASE 
            WHEN TransactionCount > 1 THEN SQRT(SumOfSquaredDiffs / (TransactionCount - 1))
            ELSE 0  -- Handle single-transaction customers with no variability
        END AS StdDevTotalDue
        FROM
            CustomerVariance
    ),

    -- Step 4: Calculate Z-Scores and Flag High-Risk Transactions
    TransactionZScores
    AS
    (
        SELECT
            soh.SalesOrderID,
            soh.CustomerID,
            soh.OrderDate,
            soh.TotalDue,
            csd.AvgTotalDue,
            csd.StdDevTotalDue,
            CASE 
            WHEN csd.StdDevTotalDue = 0 THEN 0
            ELSE (soh.TotalDue - csd.AvgTotalDue) / csd.StdDevTotalDue
        END AS ZScore
        FROM
            Sales.SalesOrderHeader AS soh
            JOIN
            CustomerStdDev AS csd ON soh.CustomerID = csd.CustomerID
    )

-- Step 5: Select High-Risk Transactions
SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue,
    ZScore,
    CASE 
        WHEN ZScore > 3 THEN 'High-Risk'
        ELSE 'Normal'
    END AS RiskFlag
FROM
    TransactionZScores
WHERE 
    ZScore > 3
-- Only show high-risk transactions
ORDER BY 
    ZScore DESC;
