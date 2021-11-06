USE insurancedb;

SELECT * FROM claims
;

SELECT COUNT(Policy_Holder_Id) FROM claims
;

SELECT COUNT(PolicyHolderId) FROM policyholders
;

-- Q1 --
-- a --
SELECT Policy_Holder_Id, COUNT(Claim_Number)
FROM claims
WHERE Policy_Holder_Id = 391;

-- b --
SELECT Policy_Holder_Id, MAX(Claim_Date_Filed)
FROM claims
WHERE Policy_Holder_Id = 391;

-- c --
SELECT Policy_Holder_Id, SUM(Claim_Amount)
FROM claims
WHERE Policy_Holder_Id = 391;

-- Q2 --
SELECT Gender AS Accident_Claims, SUM(Claim_Amount) AS Total_Claim_Amount, AVG(Claim_Amount) AS Average_Claim_Amount
FROM policyholders
	LEFT JOIN claims ON claims.Policy_Holder_Id = policyholders.PolicyHolderId
WHERE Claim_Type = 'Accident'
GROUP BY Gender
;

-- Q3 --
SELECT COUNT(DISTINCT(Policy_Holder_Id)) AS Policyholders_with_claims, COUNT(DISTINCT(PolicyHolderId)) AS Total_holders, COUNT(DISTINCT(PolicyHolderId)) - COUNT(DISTINCT(Policy_Holder_Id)) AS Policyholders_with_no_claims
FROM claims
	RIGHT JOIN policyholders ON claims.Policy_Holder_Id = policyholders.PolicyHolderId
;

-- Q4 --
SELECT Claim_Type, 'Claim Time <= 28 Days' AS Category, COUNT(Claim_Number) AS Number_of_Claims
FROM claims
WHERE DATEDIFF(STR_TO_DATE(Claim_Date_Settled, "%m/%d/%Y"), STR_TO_DATE(Claim_Date_Filed, "%m/%d/%Y")) <= 28
GROUP BY Claim_Type
ORDER BY Claim_Type
;

-- Q5 --
SELECT PolicyHolderId, COUNT(Claim_Number) AS number_claims
FROM policyholders
	LEFT JOIN claims ON claims.Policy_Holder_Id = policyholders.PolicyHolderId
GROUP BY PolicyHolderId
;

SELECT COUNT(PolicyHolderId) AS number_policyHolders, number_claims
FROM (SELECT PolicyHolderId, COUNT(Claim_Number) AS number_claims
FROM policyholders
	LEFT JOIN claims ON claims.Policy_Holder_Id = policyholders.PolicyHolderId
GROUP BY PolicyHolderId
) AS table1
GROUP BY number_claims
ORDER BY number_claims
;

-- Q6 --
SELECT Policy_Holder_Id, Gender, Age, HomeDemo, (2018 - YearEnrolled)*AnnualPremium AS Total_Premium, IFNULL(SUM(Claim_Amount),0) AS Total_Claims, 
	IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) AS Loss_Ratio
FROM policyholders
	LEFT JOIN claims ON policyholders.PolicyHolderId = claims.Policy_Holder_Id
GROUP BY PolicyHolderId
ORDER BY IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) DESC
LIMIT 10
;

-- Q7 --
SELECT SUM(Total_Claims) AS Total_Claims, SUM(Total_Premium) AS Total_Premium, ROUND(SUM(Total_Claims)/SUM(Total_Premium), 4) AS Loss_Ratio
FROM ( SELECT Policy_Holder_Id, Gender, Age, HomeDemo, (2018 - YearEnrolled)*AnnualPremium AS Total_Premium, IFNULL(SUM(Claim_Amount),0) AS Total_Claims, 
	IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) AS Loss_Ratio
FROM policyholders
	LEFT JOIN claims ON policyholders.PolicyHolderId = claims.Policy_Holder_Id
GROUP BY PolicyHolderId
ORDER BY IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) DESC
) AS table2
;

-- Q8 --
SELECT Gender, SUM(Total_Claims) AS Total_Claims, SUM(Total_Premium) AS Total_Premium, ROUND(SUM(Total_Claims)/SUM(Total_Premium), 4) AS Loss_Ratio
FROM ( SELECT Policy_Holder_Id, Gender, Age, HomeDemo, (2018 - YearEnrolled)*AnnualPremium AS Total_Premium, IFNULL(SUM(Claim_Amount),0) AS Total_Claims, 
	IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) AS Loss_Ratio
FROM policyholders
	LEFT JOIN claims ON policyholders.PolicyHolderId = claims.Policy_Holder_Id
GROUP BY PolicyHolderId
ORDER BY IFNULL(ROUND(SUM(Claim_Amount) / ((2018 - YearEnrolled)*AnnualPremium), 4),0) DESC
) AS table3
GROUP BY Gender
;
