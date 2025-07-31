--q1
SELECT ProductID, Name, Color,  ListPrice
FROM Production.Product
--q2
SELECT ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE ListPrice <> 0

--q3
SELECT ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color IS NULL
--q4
SELECT ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color IS NOT NULL

--q5
SELECT ProductID, Name, Color,  ListPrice
FROM Production.Product
WHERE Color IS NOT NULL And ListPrice > 0

--q6
SELECT Name + ' ' + Color
FROM Production.Product
WHERE Color IS NOT NULL

--q7

SELECT 
    'NAME: ' + p.Name + '  --  COLOR: ' + p.Color 
FROM Production.Product AS p
WHERE p.Name LIKE '[LMH]L Crankarm'
   OR p.Name LIKE 'Chainring%'
ORDER BY p.Name ASC

--q8
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID between 300 and 400

--q9
Select ProductID, Name, Color
From Production.Product
Where Color = 'Black' Or Color = 'Blue'

--q10
Select Name
From Production.Product
Where Name Like 'S%'


--q11
Select Top 6 Name, ListPrice
From Production.Product
Where Name Like 'S[eh]%' And (ListPrice = 0.00 Or ListPrice = 53.99)
ORDER BY Name ASC


--q12
Select TOP 5 Name, ListPrice
From Production.Product
Where Name Like '[AS]%' And ListPrice !=34.99 And ListPrice !=53.99
ORDER BY Name ASC


--q13
Select Name
From Production.Product
Where Name Like 'SPO[^K]%'
Order by Name


--q14
Select Distinct Color
From Production.Product
ORDER BY Color DESC








