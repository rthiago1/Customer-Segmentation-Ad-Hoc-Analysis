
WITH base_clean_table AS (
    SELECT
        Country,
        CAST(CustomerID AS INT) AS CustomerID,
        InvoiceNo,
        DATE(InvoiceDate) AS InvoiceDate,
        CAST(Quantity AS INT) AS Quantity,
        CAST(UnitPrice AS FLOAT) AS UnitPrice
    FROM online_retail
    WHERE UnitPrice > 0
    AND CustomerID IS NOT NULL
    AND Country = 'United Kingdom'
), base_table AS (
    SELECT
        CustomerID,
        MAX(InvoiceDate) AS LastOrderDate,
        COUNT(DISTINCT CASE WHEN Quantity > 0 THEN InvoiceNo ELSE NULL END) AS Ordervolume,
        SUM(UnitPrice * Quantity) AS TotalSpent,
        MAX(InvoiceDate) OVER() AS MaxAllDate
    FROM base_clean_table
    GROUP BY 
        CustomerID
    HAVING Ordervolume > 0
    AND TotalSpent > 0
), base_rfm_table AS (
    SELECT
        CustomerID,
        JULIANDAY(MaxAllDate) - JULIANDAY(LastOrderDate) AS RecencyDays,
        Ordervolume AS OrdersVolume,
        TotalSpent,
        NTILE(10) OVER(ORDER BY JULIANDAY(MaxAllDate) - JULIANDAY(LastOrderDate) DESC) AS RecencyScore,
        NTILE(10) OVER(ORDER BY Ordervolume) AS FrequencyScore,
        NTILE(10) OVER(ORDER BY TotalSpent) AS MonetaryScore
    FROM base_table
), final_rfm_table AS (
    SELECT
        CustomerID,
        RecencyScore,
        FrequencyScore,
        MonetaryScore,
        (RecencyScore+FrequencyScore+MonetaryScore) AS RFM,
        NTILE(10) OVER(ORDER BY (RecencyScore+FrequencyScore+MonetaryScore)) AS RFMScore
    FROM base_rfm_table
)
    SELECT
        *,
        CASE 
            WHEN RFMScore > 7 THEN 'Top Customer'
            WHEN RFMScore >= 5 AND RFMScore < 8 THEN 'Loyal Customer'
            WHEN RFMScore >= 2 AND RFMScore < 5 THEN 'At Risk'
            WHEN RFMScore < 2 THEN 'Immediate Attention'
            ELSE 'CheckLogic'
        END AS CustomerSegment
    FROM final_rfm_table