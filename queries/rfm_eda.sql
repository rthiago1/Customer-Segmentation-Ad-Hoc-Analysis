
SELECT
    CustomerSegment,
    AVG(RecencyDays) AS RecencyAVG,
    AVG(OrdersVolume) AS FrequencyAVg,
    AVG(TotalSpent) AS AVGSpent
FROM rfm_analysis
GROUP BY 
    CustomerSegment




SELECT
    CustomerSegment,
    SUM(TotalSpent) /
    (SELECT SUM(TotalSpent) FROM rfm_analysis) AS SpentProportion
FROM rfm_analysis
GROUP BY 
    CustomerSegment