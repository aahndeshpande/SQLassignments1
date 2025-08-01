USE [AdventureWorks2019] 
GO

--q1 : 1. How many products can you find in the Production.Product table?


Select count(*)
from Production.Product
-- answer : 504

--q2 : 2.Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.

SELECT COUNT(*) AS ProductsWithSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--answer : 295

--3. q3: How many Products reside in each SubCategory? Write a query to display the results with the following titles. ProductSubcategoryID CountedProducts


SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID


--4.      How many products that do not have a product subcategory.   
SELECT COUNT(*) AS NumberOfProductsWithSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NULL
--answer 4 :  209

--5.      Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) as SumOfProductsQuantity
FROM Production.ProductInventory

--6.    Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.


SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7.    Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100


SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100

--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT AVG(Quantity) AS AverageQuantity
FROM Production.ProductInventory
WHERE LocationID = 10

--9.    Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

SELECT ProductID, Shelf, AVG(Quantity) As TheAvg
FROM Production.ProductInventory
WHERE Shelf NOT IN ('N/A')
GROUP BY ProductID, Shelf

--11.  List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--12.   Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following.


SELECT c.[Name] AS Country, s.[Name] AS Province
FROM person.CountryRegion c JOIN person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode


--13.  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.


SELECT c.[Name] AS Country, s.[Name] AS Province
FROM person.CountryRegion c JOIN person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.[Name] IN ('Germany','Canada')

-- now using Northwind Database

USE [Northwind Database] 
GO

--14.  List all Products that has been sold at least once in last 27 years.

SELECT DISTINCT P.ProductName
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.OrderDate >= '1998-01-01'


--15.  List top 5 locations (Zip Code) where the products sold most.

SELECT TOP 5 ShipPostalCode, COUNT(*) AS soldproduct
FROM Orders 
GROUP BY ShipPostalCode
ORDER BY COUNT(ShipPostalCode) DESC

--16.  List top 5 locations (Zip Code) where the products sold most in last 27 years.

SELECT TOP 5 O.ShipPostalCode, COUNT(*) AS LocationCount
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
WHERE O.OrderDate >= '1998-01-01'
GROUP BY O.ShipPostalCode
ORDER BY COUNT(*) DESC



--17.   List all city names and number of customers in that city.     

SELECT City, COUNT(CustomerID) AS CustomersCount
FROM Customers
GROUP BY City

--18.  List city names which have more than 2 customers, and number of customers in that city

SELECT City, COUNT(CustomerID) AS CustomersCount
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >=2

--19.  List the names of customers who placed orders after 1/1/98 with order date.

SELECT DISTINCT C.ContactName
FROM Customers C JOIn Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderDate > '1998-01-01'


--20.  List the names of all customers with most recent order dates

SELECT C.ContactName, O.OrderDate AS OrderDate
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID
ORDER BY O.OrderDate DESC

--21.  Display the names of all customers  along with the  count of products they bought

SELECT C.ContactName, COUNT(OD.ProductID) AS CountOfProductsBought
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID JOIN [Order Details] OD ON O.OrderID = OD.OrderID JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY C.ContactName


--22.  Display the customer ids who bought more than 100 Products with count of products.

SELECT C.CustomerID, COUNT(OD.ProductID) AS CountOfProductsBought
FROM Customers C JOIN Orders O ON C.CustomerID = O.CustomerID JOIN [Order Details] OD ON O.OrderID = OD.OrderID JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY C.CustomerID
HAVING COUNT(OD.ProductID) > 100

--23.  List all of the possible ways that suppliers can ship their products. Display the results as below

    --Supplier Company Name                Shipping Company Name

SELECT S.CompanyName AS [Supplier Company Name], Ship.CompanyName AS [Shipping Company Name]
FROM Suppliers S
CROSS JOIN Shippers Ship
ORDER BY [Supplier Company Name], [Shipping Company Name]


--24.  Display the products order each day. Show Order date and Product Name.

SELECT O.OrderDate, P.ProductName
FROM Orders O JOIN [Order Details] OD ON O.OrderID = OD.OrderID JOIN Products P ON OD.ProductID = P.ProductID
ORDER BY O.OrderDate

--25.  Displays pairs of employees who have the same job title.
SELECT e1.EmployeeId AS EmployeeId1, e1.Title AS Title, e2.EmployeeId AS EmployeeId2
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeId < e2.EmployeeId

--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT M.EmployeeId AS ManagerId, M.Title AS ManagerTitle, COUNT(*) AS NumberOfEmployeesReporting
FROM Employees M JOIN Employees E ON M.EmployeeId = E.ReportsTo 
GROUP BY M.EmployeeId, M.Title
HAVING COUNT(*) > 2

--27.  Display the customers and suppliers by city. The results should have the following columns 
--City Name Contact Name, Type (Customer or Supplier)
SELECT City, CompanyName AS [Name], ContactName AS [Contact Name], 'Customer' AS Type
FROM Customers
UNION ALL
SELECT City, CompanyName AS [Name], ContactName AS [Contact Name], 'Supplier' AS Type
FROM Suppliers
ORDER BY City, [Name]
