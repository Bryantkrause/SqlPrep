-- 
SELECT
    soh.SalesOrderID,
    soh.CustomerID,
    soh.OrderDate,
    soh.TotalDue,
    shipAdd.City AS ShipToCity,
    billAdd.City AS BillToCity,
    custAdd.City AS CustomerCity,
    CASE 
        WHEN shipAdd.City <> custAdd.City THEN 'Out of Area'
        ELSE 'In Area'
    END AS LocationFlag
FROM
    Sales.SalesOrderHeader AS soh
    JOIN Person.Address AS billAdd ON soh.BillToAddressID = billAdd.AddressID
    JOIN Person.Address AS shipAdd ON soh.ShipToAddressID = shipAdd.AddressID
    JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
    JOIN Person.Address AS custAdd ON c.CustomerID = custAdd.AddressID
WHERE 
    shipAdd.City <> custAdd.City
ORDER BY 
    soh.CustomerID DESC;