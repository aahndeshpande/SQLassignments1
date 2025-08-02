
use [Northwind Database]
go

--q1.List all cities that have both Employees and Customers.
Select Distinct City
From Customers
Where City In(Select City From Employees)


--q2  List all cities that have Customers but no Employee.
--a.      Use sub-query
Select Distinct City
From Customers
Where City Not In(Select City From Employees)

--b. Do not use sub-query
Select Distinct c.City
From Customers c Left Join Employees e
On c.City = e.City


-- q3. List all products and their total order quantities throughout all orders.

SELECT P.ProductName, SUM(OD.Quantity) AS TotalProductOrdered
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
Order by TotalProductOrdered ASC





--q4.  List all Customer Cities and total products ordered by that city.


SELECT C.City, SUM(OD.Quantity) AS TotalProductOrdered
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY C.City

--q5. List all Customer Cities that have at least two customers.

SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(DISTINCT CustomerID) >= 2;

--q6 6.      List all Customer Cities that have ordered at least two different kinds of products.
Select Distinct c.City
From Customers c Inner Join Orders o
On c.CustomerID = o.CustomerID
Inner Join [Order Details] od
On o.OrderID = od.OrderID
Group By c.City
Having count(od.ProductID) > 2


--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT C.CustomerID, C.CompanyName, C.City AS CustomerCity, O.ShipCity
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE C.City <> O.ShipCity;




--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH ProductTotals AS (
    SELECT OD.ProductID, SUM(OD.Quantity) AS TotalQty
    FROM [Order Details] OD
    GROUP BY OD.ProductID
),
Top5Products AS (
    SELECT TOP 5 PT.ProductID
    FROM ProductTotals PT
    ORDER BY PT.TotalQty DESC
),
ProductCityStats AS (
    SELECT C.City, OD.ProductID, SUM(OD.Quantity) AS Qty
    FROM Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    WHERE OD.ProductID IN (SELECT ProductID FROM Top5Products)
    GROUP BY C.City, OD.ProductID
),
MaxCityPerProduct AS (
    SELECT ProductID, City
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Qty DESC) AS rn
        FROM ProductCityStats
    ) a
    WHERE rn = 1
)
SELECT P.ProductName, AVG(OD.UnitPrice) AS AvgPrice, MCP.City
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN MaxCityPerProduct MCP ON P.ProductID = MCP.ProductID
WHERE P.ProductID IN (SELECT ProductID FROM Top5Products)
GROUP BY P.ProductName, MCP.City;



--9.List all cities that have never ordered something but we have employees there.
--a.      Use sub-query
Select e.City
From Employees e
Where e.City Not In(Select c.City From Customers c Inner Join Orders o On c.CustomerID=o.CustomerID)

--b.      Do not use sub-query
Select e.City
From Employees e Left Join Customers c
On e.City = c.City
Where c.City is Null


--10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)

-- Q10: Using JOIN with subquery to compare top employee city and top ship city

SELECT EC.City
FROM (
    SELECT E.City, COUNT(O.OrderID) AS OrderCount
    FROM Employees E
    JOIN Orders O ON E.EmployeeID = O.EmployeeID
    GROUP BY E.City
) AS EC
JOIN (
    SELECT O.ShipCity, SUM(OD.Quantity) AS TotalQuantity
    FROM Orders O
    JOIN [Order Details] OD ON O.OrderID = OD.OrderID
    GROUP BY O.ShipCity
) AS SC
ON EC.City = SC.ShipCity
WHERE EC.OrderCount = (
    SELECT MAX(EC2.OrderCount)
    FROM (
        SELECT E.City, COUNT(O.OrderID) AS OrderCount
        FROM Employees E
        JOIN Orders O ON E.EmployeeID = O.EmployeeID
        GROUP BY E.City
    ) AS EC2
)
AND SC.TotalQuantity = (
    SELECT MAX(SC2.TotalQuantity)
    FROM (
        SELECT O.ShipCity, SUM(OD.Quantity) AS TotalQuantity
        FROM Orders O
        JOIN [Order Details] OD ON O.OrderID = OD.OrderID
        GROUP BY O.ShipCity
    ) AS SC2
);



--11.How do you remove the duplicates record of a table?
-- To remove duplicate records in SQL, I usually use either the GROUP BY method or the ROW_NUMBER() method. With GROUP BY, I group rows based on the columns that define duplicates and keep just one from each group. When I need more control—like choosing which duplicate to keep—I use ROW_NUMBER() to number the rows in each group and delete the ones with a higher number.
