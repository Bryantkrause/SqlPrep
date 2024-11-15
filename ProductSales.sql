-- Dynamically retrieve list of all product and amount sold in last year of data
SELECT
    CASE 
        WHEN GROUPING(p.Name) = 1 THEN 'Grand Total'  -- Label the grand total row
        ELSE p.Name 
    END AS ProductName,
    COUNT(p.Name) AS ProductCount, -- Count of products, with total count in the grand total row
    SUM(s.UnitPrice * s.OrderQty) AS TotalSales
-- Calculate total sales for each product and for the grand total

FROM
    Sales.SalesOrderHeader AS soh -- Main sales order table
    JOIN Sales.SalesOrderDetail AS s ON soh.SalesOrderID = s.SalesOrderID -- Join to order details to get product info
    JOIN Production.Product AS p ON s.ProductID = p.ProductID
-- Join to product table to get product names

-- Filter the data to only include records from the most recent year available
WHERE 
    YEAR(soh.OrderDate) = (SELECT MAX(YEAR(OrderDate))
FROM Sales.SalesOrderHeader)
-- Subquery finds the maximum (latest) year in the OrderDate column, ensuring we only get data from that year

GROUP BY 
    GROUPING SETS ((p.Name), ())
-- Use GROUPING SETS to create subtotals by product and a grand total

ORDER BY 
    CASE WHEN GROUPING(p.Name) = 1 THEN 1 ELSE 0 END,  -- Sort to display grand total at the bottom
    TotalSales DESC;                                   -- Order products by total sales in descending order