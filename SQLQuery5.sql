1.      List all cities that have both Employees and Customers.
select * from Employees
select * from Customers

SELECT Distinct e.City
FROM Employees e
JOIN Customers c ON e.City = c.City

SELECT DISTINCT City
FROM Employees
WHERE City IN (
    SELECT DISTINCT City
    FROM Customers
)




2.      List all cities that have Customers but no Employee.

a.      Use sub-query

b.      Do not use sub-query

B.

SELECT DISTINCT c.City
FROM Customers c
LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL;


3.      List all products and their total order quantities throughout all orders.

SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalOrderQuantity
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName;

SELECT p.ProductID, p.ProductName, 
       (SELECT SUM(od.Quantity)
        FROM [Order Details] od
        WHERE od.ProductID = p.ProductID) AS TotalOrderQuantity
FROM Products p;

4.      List all Customer Cities and total products ordered by that city.

	SELECT c.City,
       (SELECT SUM(od.Quantity)
        FROM Orders o
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        WHERE o.CustomerID = c.CustomerID) AS TotalProductsOrdered
FROM Customers c;

5.      List all Customer Cities that have at least two customers.
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2;


6.      List all Customer Cities that have ordered at least two different kinds of products.

SELECT c.City, COUNT(DISTINCT od.ProductID) AS DifferentProductsOrdered
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2;

7.    List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT c.CustomerID, c.ContactName, c.City AS CustomerCity, o.ShipCity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.ShipCity <> c.City;

8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT 
    p.ProductID,
    p.ProductName,
    AVG(p.UnitPrice) AS AveragePrice,
    (SELECT TOP 1 c.City
     FROM Customers c
     JOIN Orders o ON c.CustomerID = o.CustomerID
     JOIN [Order Details] od ON o.OrderID = od.OrderID
     WHERE od.ProductID = p.ProductID
     GROUP BY c.City
     ORDER BY SUM(od.Quantity) DESC) AS TopCity
FROM 
    Products p
JOIN 
    [Order Details] od ON p.ProductID = od.ProductID
GROUP BY 
    p.ProductID, p.ProductName
ORDER BY 
    SUM(od.Quantity) DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

9.      List all cities that have never ordered something but we have employees there.

a.      Use sub-query

b.      Do not use sub-query

SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
);


10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT TOP 1 e.City
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.City
HAVING COUNT(o.OrderID) = (
    SELECT MAX(OrderCount)
    FROM (
        SELECT COUNT(o.OrderID) AS OrderCount
        FROM Employees e
        JOIN Orders o ON e.EmployeeID = o.EmployeeID
        GROUP BY e.City
    ) AS OrderCounts
)
AND e.City IN (
    SELECT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.City
    HAVING SUM(od.Quantity) = (
        SELECT MAX(TotalQuantity)
        FROM (
            SELECT SUM(od.Quantity) AS TotalQuantity
            FROM Customers c
            JOIN Orders o ON c.CustomerID = o.CustomerID
            JOIN [Order Details] od ON o.OrderID = od.OrderID
            GROUP BY c.City
        ) AS ProductQuantities
    )
);

11. How do you remove the duplicates record of a table?

We can use Distinct Keyword