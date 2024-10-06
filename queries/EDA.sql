
-- Performing a data check for future cleaning/validation
SELECT
    COUNT(DISTINCT InvoiceNo) AS Invoices,
    COUNT(DISTINCT CustomerID) AS Customers,
    COUNT(DISTINCT Country) AS Countries,
    MIN(InvoiceDate) AS FirstDate,
    MAX(InvoiceDate) AS LastDate,
    MIN(UnitPrice) AS LowerPrice,
    MAX(UnitPrice) AS HighestPrice,
    AVG(UnitPrice) AS AvgPrice
FROM online_retail


-- Products with negative Price and based on the DEscription, indicates that those invoices might be canceled order or value returned to customer. Therefore we will not consider those orders into RFM_table
select * from online_retail
where unitprice < 0

-- checking orders where there is no customerid
select * from online_retail
where CustomerID is null

-- checking if orders with negative or 0 quantity exists

select * from online_retail
where Quantity < 1

-- Observing the StcokCode column we can see a pattern, therefore a data check and potential cleaning or filtering should be performed
WITH base_table AS (
    SELECT
        *,
        LENGTH(StockCode) AS StockCodeSTRLen
    FROM online_retail
)
    SELECT 
        * FROM base_table 
    WHERE StockCodeSTRLen > 7 or StockCodeSTRLen < 5


-- As UK is the country with majority of transaction history, it will be selected to perform the RFM query
SELECT
    Country,
    COUNT(*) AS VolumebyCountry
FROM online_retail
GROUP BY 
    Country
ORDER BY 
    2 DESC

