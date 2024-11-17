
-- get orders placed outside a specific window
SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue
FROM
    Sales.SalesOrderHeader
WHERE 
    DATEPART(HOUR, OrderDate) NOT BETWEEN 9 AND 17
-- Outside typical 9 AM - 5 PM business hours
ORDER BY 
    OrderDate;
