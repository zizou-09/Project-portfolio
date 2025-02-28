-- (1) HR WANTS A LIST OF ALL PRODUCTS AND SALES TRANSACTIONS. CALL OUT PRODUCT DETAILS(EXCLUDE THE ONES THAT 
--HAVE NEVER BEEN SOLD) AND SHOW SALES TRANSACTIONS EVEN IF THE PRODUCT IS MISSING FROM THE PRODUCT TABLE

SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail

SELECT pp.ProductID, pp.Name AS ProductName, sod.SalesOrderID AS OrderID, sod.OrderQty AS OrderQuantity
FROM Production.Product AS pp  
FULL JOIN Sales.SalesOrderDetail AS sod
ON pp.ProductID = sod.ProductID 
WHERE  sod.OrderQty   > 0
ORDER BY sod.OrderQty DESC

--(2) HR WANTS TO SEND PROMOTIONAL EMAIL TO ALL CUSTOMERS THAT HAVE NEVER RECEIVED EMAILPROMOTOIONS AND HAVE
--THE TELEPHONE NUMBER WITH AREA CODE 612. WRITE AN SQL QUERY TO CALLOUT THEIR FIRSTNAME, LAST NAME, CONTACT NUMBER 
-- AND EMAIL PROMOTION

SELECT * FROM  Person.PersonPhone
SELECT * FROM Person.Person


	SELECT p.FirstName,p.LastName, ph.PhoneNumber, P.Emailpromotion
FROM  Person.PersonPhone AS ph  
INNER JOIN  Person.Person AS p  
    ON ph.BusinessEntityID = p.BusinessEntityID  
WHERE ph.PhoneNumber LIKE '612%'  AND P.EmailPromotion < 1
ORDER by  p.FirstName

--(3) MANAGEMENT WANTS TO REWARD SALESPERSON WITH SALES AMOUNT EXCEEDING FIVE MILLION
--RETRIEVE THEIR SALES AMOUNT, FIRST NAME AND LAST NAME, ARRANGE THE SALES AMOUNT FROM
--HIGHEST TO LOWEST
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesPerson
SELECT * FROM Person.Person

SELECT p.FirstName,p.LastName,
SUM(soh.TotalDue) AS Total_Sales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
HAVING SUM(soh.TotalDue) > 5000000
ORDER BY Total_Sales DESC

--(4) MANAGER NEED THE LIST OF CUSTOMERS WITH CREDIT CARD WHOSE EXPIRATION DATE IS 2006
--WRITE A QUERY TO RETRIEVE THE CUSTOMER ID, FIRST AND LAST NAME, CARD TYPE AND NUMBER
--AND EXPIRATION YEAR
 
SELECT * FROM Person.Person
SELECT * from sales.CreditCard
SELECT * FROM Sales.PersonCreditCard

SELECT sc.CustomerID, pp.FirstName, pp.LastName, cc.CardType, cc.CardNumber, CC.ExpYear
FROM Sales.Customer as sc  
INNER JOIN Person.Person AS pp
ON sc.PersonID = pp.BusinessEntityID  
INNER JOIN Sales.PersonCreditCard pc
ON sc.CustomerID = pc.BusinessEntityID  
INNER JOIN Sales.CreditCard cc 
ON pc.CreditCardID = cc.CreditCardID 
WHERE CC.ExpYear = 2006
ORDER BY sc.CustomerID ASC

--(5)WRITE A QUERY TO CALL OUT THE TOTAL SALES AMOUNT OF CUSTOMERS WITH MORE THAN TEN ORDERS
--LIST THEIR FULLNAME, CUDSTOMER ID, TOTAL ORDER AND TOTAL SALES AND ARRANGE THE TOTAL SALES 
--FROM HIGHEST TO LOWEST

SELECT * FROM Sales.Customer
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Person.Person

SELECT sc.CustomerID, CONCAT(pp.FirstName,' ' , pp.LastName) AS Full_Name, COUNT(soh.SalesOrderID) AS Total_Order,  
       SUM(soh.TotalDue) AS TotalSales  
FROM Sales.Customer AS  sc  
INNER JOIN Person.Person pp 
ON sc.PersonID = pp.BusinessEntityID  
INNER JOIN Sales.SalesOrderHeader soh 
ON sc.CustomerID = soh.CustomerID  
GROUP BY sc.CustomerID, pp.FirstName, pp.LastName  
HAVING COUNT(soh.SalesOrderID) >= 10  
ORDER BY TotalSales DESC;

--(6) RETRIEVE THE LIST OF ALL PRODUCT IN THE CLOTHING CATEGORY ALONG WITH THEIR PRICE

SELECT * FROM Production.ProductCategory
SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory

SELECT pp.Name AS ProductName, pp.ListPrice, pc.Name AS CategoryName
FROM Production.Product pp
INNER JOIN  Production.ProductSubcategory ps 
ON pp.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'CLOTHING' 
ORDER BY pp.ListPrice DESC;

--(7)RETRIEVE THE LIST OF SALESPERSON WHO HAVE SOLD MORE THAN AVERAGE  SALES AMOUNT
--LIST THEIR NAME, TOTAL SALES AMOUNT AND NUMBER OF ORDER

SELECT * FROM Person.Person
SELECT * FROM Sales.SalesPerson
SELECT * FROM Sales.SalesOrderHeader

SELECT pp.FirstName + ' ' + pp.LastName AS Name ,COUNT(sh.SalesOrderID) AS Num_Of_Orders,
    ROUND(SUM(sh.TotalDue), 2) AS TotalSalesAmount
FROM Sales.SalesPerson sp
INNER JOIN  Person.Person pp
ON sp.BusinessEntityID = pp.BusinessEntityID
INNER JOIN  Sales.SalesOrderHeader sh 
ON sp.BusinessEntityID = sh.SalesPersonID
GROUP BY pp.FirstName + ' ' + pp.LastName
HAVING SUM(sh.TotalDue) > ( SELECT AVG(SalesTotal)
            FROM ( SELECT SalesPersonID, SUM(TotalDue) AS SalesTotal
            FROM Sales.SalesOrderHeader
            WHERE SalesPersonID IS NOT NULL
            GROUP BY SalesPersonID ) AS SalesAverages )
ORDER BY  Num_Of_Orders DESC;

--(8) RETRIEVE FROM EACH SALES TERRITORY WHERE THE TOTAL EXCEEDS ONE MILLION THEIR TOTAL SALES AMOUNT,
--INCLUDING THE TERRITORY NAME ANDN THE TOTAL SALES AMOUNT

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesTerritory

SELECT st.Name AS Territory,SUM(soh.TotalDue) AS Total_Sales_Amount
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name
HAVING  SUM(soh.TotalDue) > 1000000
ORDER BY Total_Sales_Amount DESC;


--(9) WRITE A QUERY TO RETRIEVE EMPLOYEES WHO WORK AS MARKETING ASSISTANT, SALES REPRESENTATIVE

SELECT * FROM Person.Person
SELECT * FROM HumanResources.Employee

SELECT  pp.FirstName,  pp.LastName,  hr.JobTitle  
FROM Person.Person AS pp  
JOIN  HumanResources.Employee AS hr  
    ON pp.BusinessEntityID = hr.BusinessEntityID  
WHERE  hr.JobTitle IN ('marketing assistant', 'sales representative')


--10 HR WANTS THE LIST OF EMPLOYEES WHO WERE HIRED IN THE LAST 15YRS. WRITE A QUERY TO RETRIEVE THEIR 
--FIRST AND LAST NAME AND HIRED DATE
	
SELECT  pp.FirstName, pp.LastName, hr.HireDate
FROM  HumanResources.Employee AS hr
JOIN Person.Person AS pp
ON hr.BusinessEntityID = pp.BusinessEntityID
WHERE  hr.HireDate >= DATEADD(YEAR, -15, GETDATE())
ORDER BY hr.HireDate DESC

--(11) WRITE QUERY TO RETRIEVE THE COUNTRY NAME AND TOTAL SALES AMOUNT FOR THE YEAR

SELECT * FROM Sales.SalesPerson
SELECT * FROM Sales.SalesTerritory

SELECT cr.Name AS country_name, SUM(sp.SalesYTD) AS total_sales_ytd
FROM Sales.SalesPerson sp
JOIN Sales.SalesTerritory st 
ON sp.TerritoryID = st.TerritoryID
JOIN Person.CountryRegion cr 
ON st.CountryRegionCode = cr.CountryRegionCode 
GROUP BY cr.Name
ORDER BY total_sales_ytd DESC;

--(12) RETRIEVE SALESPERSON WITH MORE THAN 500 BONUS, LIST THEIR FIRST AND LAST NAME

SELECT DISTINCT pp.LastName, pp.FirstName
FROM Person.Person AS pp 
JOIN HumanResources.Employee AS hr
    ON hr.BusinessEntityID = pp.BusinessEntityID 
WHERE 500.00 > 
    (SELECT Bonus
     FROM Sales.SalesPerson AS sp
     WHERE hr.BusinessEntityID = sp.BusinessEntityID);


--(13) RETRIEVE THE AVERAGE RATE PER CURRENCY AND SALES TERRITORY OF ALL ORDER PLACED BEFORE THE YEAR 2014

SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.CurrencyRate
SELECT * FROM Sales.SalesTerritory

 SELECT st.Name AS TerritoryName, cr.ToCurrencyCode,   AVG(cr.AverageRate) AS AvgExchangeRate,  
       COUNT(soh.SalesOrderID) AS TotalOrders  
FROM Sales.SalesOrderHeader soh  
INNER JOIN Sales.CurrencyRate cr ON soh.CurrencyRateID = cr.CurrencyRateID  
INNER JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID  
WHERE YEAR(cr.CurrencyRateDate) < 2014  
GROUP BY st.Name, cr.ToCurrencyCode  
ORDER BY st.Name, AvgExchangeRate DESC;


--(14) RETRIEVE THE LIST OF VENDORS AND THE NUMBER OF PRODUCTS SUPPLIED

SELECT * FROM Purchasing.Vendor
SELECT * FROM Purchasing.ProductVendor

SELECT  v.Name AS VendorName, COUNT(pv.ProductID) AS Number_Of_Products
FROM Purchasing.Vendor v
LEFT JOIN Purchasing.ProductVendor pv 
ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY  v.Name
ORDER BY Number_Of_Products DESC, VendorName;


--(15)RETRIEVE PRODUCT NAME AND SALEN ORDERID OF PRODUCTS WITH PRICER HIGHER THAN TEN
--ARRANGE PRICE LIST IN DESCENDING ORDER

SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail

SELECT p.Name, sod.SalesOrderID, p.ListPrice 
FROM Production.Product AS p  
LEFT OUTER JOIN Sales.SalesOrderDetail AS sod  
ON p.ProductID = sod.ProductID 
WHERE P.ListPrice > 10
ORDER BY p.ListPrice desc;
