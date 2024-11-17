
-- find differences based on bill to and ship to
SELECT
    soh.SalesOrderID,
    soh.billtoAddressID,
    adrs.AddressTypeID as ShipToType,
    adrType.Name as ShipType,
    soh.shipToAddressID,
    cust.PersonID,
    cust.StoreID,
    cust.CustomerID


-- these joins will match the customer id to the store id to verify the correct address
FROM sales.salesOrderHeader as soh
    join sales.Customer as cust on soh.CustomerID = cust.CustomerID
    join person.BusinessEntityAddress as adrs on soh.ShipToAddressID = adrs.AddressID
    join person.AddressType as adrType on adrs.AddressTypeID = adrType.AddressTypeID

where soh.billtoAddressID <> soh.shipToAddressID