
-- Get orders placed within close proximity
SELECT
    soh1.CustomerID,
    soh1.SalesOrderID AS FirstOrderID,
    soh2.SalesOrderID AS SecondOrderID,
    soh1.OrderDate AS FirstOrderDate,
    soh2.OrderDate AS SecondOrderDate,
    DATEDIFF(MINUTE, soh1.OrderDate, soh2.OrderDate) as Minuets
FROM
    Sales.SalesOrderHeader AS soh1
    JOIN Sales.SalesOrderHeader AS soh2
    ON soh1.CustomerID = soh2.CustomerID
        AND soh1.SalesOrderID < soh2.SalesOrderID
        AND DATEDIFF(MINUTE, soh1.OrderDate, soh2.OrderDate) <= 120
-- Within 60 minutes
ORDER BY 
    soh1.CustomerID, soh1.OrderDate;