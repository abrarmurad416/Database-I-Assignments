-- Use Existing Database (Remove Duplicate Creation)
DROP DATABASE IF EXISTS InventoryDB;
CREATE DATABASE InventoryDB;
USE InventoryDB;

-- Customer Table (Created First)
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL
);

-- Product Table (Independent Table)
CREATE TABLE Product (
    ProductID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);

-- Supplier Table (Independent Table)
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Contact VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL
);

-- Order Table (Depends on Customer)
CREATE TABLE `Order` (
    OrderID INT PRIMARY KEY NOT NULL,
    OrderDate DATE NOT NULL,
    CustomerID INT NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

-- Supply Table (Many-to-Many between Supplier and Product)
CREATE TABLE Supply (
    SupplyID INT PRIMARY KEY NOT NULL,
    SupplierID INT NOT NULL,
    ProductID INT NOT NULL,
    SupplyDate DATE NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE
);

-- Inventory Table (Depends on Product)
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Location VARCHAR(100) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE
);

-- Employee Table (Independent Table)
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Contact VARCHAR(100) NOT NULL
);

-- Shipment Table (Depends on Order)
CREATE TABLE Shipment (
    ShipmentID INT PRIMARY KEY NOT NULL,
    ShipmentDate DATE NOT NULL,
    OrderID INT NOT NULL,
    Status VARCHAR(50) NOT NULL CHECK (Status IN ('Pending', 'Shipped', 'Delivered')),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE
);

-- Delivery Table (Depends on Employee and Shipment)
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY NOT NULL,
    EmployeeID INT NOT NULL,
    ShipmentID INT NOT NULL,
    Route VARCHAR(100) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID) ON DELETE CASCADE
);

-- Payment Table (Depends on Order)
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY NOT NULL,
    OrderID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE
);

-- Verify Tables
SHOW TABLES;

-- Describe Tables
DESC Customer;
DESC `Order`;
DESC Supplier;
DESC Product;
DESC Supply;
DESC Inventory;
DESC Employee;
DESC Shipment;
DESC Delivery;
DESC Payment;

-- Insert sample data into Customer Table
INSERT INTO Customer (CustomerID, Name, Email, PhoneNumber)
VALUES
    (1, 'John Doe', 'johndoe@example.com', '123-456-7890'),
    (2, 'Jane Smith', 'janesmith@example.com', '987-654-3210'),
    (3, 'Alice Brown', 'alicebrown@example.com', '555-666-7777');

-- Insert sample data into Product Table
INSERT INTO Product (ProductID, Name, Category, Price)
VALUES
    (1, 'Laptop', 'Electronics', 999.99),
    (2, 'Desk Chair', 'Furniture', 199.99),
    (3, 'Headphones', 'Electronics', 49.99);

-- Insert sample data into Supplier Table
INSERT INTO Supplier (SupplierID, Name, Contact, Address)
VALUES
    (1, 'Tech Supplies Inc.', 'tech@example.com', '123 Tech St.'),
    (2, 'Office Essentials', 'office@example.com', '456 Office Blvd.');

-- Insert sample data into Supply Table
INSERT INTO Supply (SupplyID, SupplierID, ProductID, SupplyDate)
VALUES
    (1, 1, 1, '2024-01-10'),
    (2, 2, 2, '2024-01-15');

-- Insert sample data into Order Table
INSERT INTO `Order` (OrderID, OrderDate, CustomerID, TotalAmount)
VALUES
    (1, '2024-02-01', 1, 1049.98),
    (2, '2024-02-05', 2, 999.99);

-- Insert sample data into Inventory Table
INSERT INTO Inventory (InventoryID, ProductID, Quantity, Location)
VALUES
    (1, 1, 50, 'Warehouse A'),
    (2, 2, 30, 'Warehouse B');

-- Insert sample data into Employee Table
INSERT INTO Employee (EmployeeID, Name, Role, Contact)
VALUES
    (1, 'Mark Johnson', 'Delivery Driver', 'mark@example.com'),
    (2, 'Sarah Lee', 'Warehouse Manager', 'sarah@example.com');

-- Insert sample data into Shipment Table
INSERT INTO Shipment (ShipmentID, ShipmentDate, OrderID, Status)
VALUES
    (1, '2024-02-10', 1, 'Shipped'),
    (2, '2024-02-12', 2, 'Pending');

-- Insert sample data into Delivery Table
INSERT INTO Delivery (DeliveryID, EmployeeID, ShipmentID, Route)
VALUES
    (1, 1, 1, 'Route 66'),
    (2, 1, 2, 'Route 77');

-- Insert sample data into Payment Table
INSERT INTO Payment (PaymentID, OrderID, Amount, PaymentDate)
VALUES
    (1, 1, 1049.98, '2024-02-03'),
    (2, 2, 999.99, '2024-02-06');

SELECT * FROM Customer;
SELECT * FROM `Order`;
SELECT * FROM Supplier;
SELECT * FROM Product;
SELECT * FROM Supply;
SELECT * FROM Inventory;
SELECT * FROM Employee;
SELECT * FROM Shipment;
SELECT * FROM Delivery;
SELECT * FROM Payment;

--------------------------------------------------------
-- Queries Section (10 Queries)
--------------------------------------------------------

-- 1. Simple Query with DISTINCT
SELECT DISTINCT Category FROM Product;

-- 2. Query with ORDER BY
SELECT Name, Price FROM Product ORDER BY Price DESC;

-- 3. Query with GROUP BY (Total orders per customer)
SELECT CustomerID, COUNT(*) AS TotalOrders FROM `Order` GROUP BY CustomerID;

-- 4. Subquery: Find all customers who placed an order worth more than $1000
SELECT Name FROM Customer WHERE CustomerID IN (
    SELECT CustomerID FROM `Order` WHERE TotalAmount > 1000
);

-- 5. Correlated Subquery: Find customers who have made an order before '2024-02-04'
SELECT Name FROM Customer c WHERE EXISTS (
    SELECT 1 FROM `Order` o WHERE o.CustomerID = c.CustomerID AND o.OrderDate < '2024-02-04'
);

-- 6. Window Function (RANK): Rank orders by total amount
SELECT OrderID, CustomerID, TotalAmount, 
       RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank
FROM `Order`;

-- 7. Window Function (ROW_NUMBER): Assign a unique row number to each product
SELECT ProductID, Name, Price, 
       ROW_NUMBER() OVER (ORDER BY Price DESC) AS RowNum
FROM Product;

-- 8. Advanced Join (3 tables: Order + Customer + Payment)
SELECT c.Name AS CustomerName, o.OrderID, p.Amount, p.PaymentDate
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN Payment p ON o.OrderID = p.OrderID;

-- 9. Advanced Join (3 tables: Product + Supply + Supplier)
SELECT pr.Name AS ProductName, sp.Name AS SupplierName, su.SupplyDate
FROM Product pr
JOIN Supply su ON pr.ProductID = su.ProductID
JOIN Supplier sp ON su.SupplierID = sp.SupplierID;

-- 10. Query with HAVING (Total sales per customer, only showing customers with sales > $1000)
SELECT o.CustomerID, SUM(p.Amount) AS TotalSpent
FROM `Order` o
JOIN Payment p ON o.OrderID = p.OrderID
GROUP BY o.CustomerID
HAVING TotalSpent > 1000;

--------------------------------------------------------
-- Views Section (3 Views)
--------------------------------------------------------

-- 1. View: Total Sales per Customer (with calculated field)
CREATE VIEW CustomerSales AS
SELECT c.Name AS CustomerName, SUM(o.TotalAmount) AS TotalSpent
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
GROUP BY c.Name;

-- 2. View: Products with Inventory Details
CREATE VIEW ProductInventory AS
SELECT p.Name AS ProductName, i.Quantity, i.Location
FROM Product p
JOIN Inventory i ON p.ProductID = i.ProductID;

-- 3. View: Recent Payments with Customer Names
CREATE VIEW RecentPayments AS
SELECT c.Name AS CustomerName, p.Amount, p.PaymentDate
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN Payment p ON o.OrderID = p.OrderID
ORDER BY p.PaymentDate DESC;

-- Assignment 5 start

-- Advanced Queries

-- 1. Join Operation: List customers along with their orders and payment status
SELECT C.Name, O.OrderID, O.TotalAmount, P.PaymentDate, 
       CASE WHEN P.PaymentID IS NOT NULL THEN 'Paid' ELSE 'Pending' END AS PaymentStatus
FROM Customer C
JOIN `Order` O ON C.CustomerID = O.CustomerID
LEFT JOIN Payment P ON O.OrderID = P.OrderID;

-- 2. Set Operation: List all products ordered and supplied (union of orders and supplies)
SELECT ProductID, Name, 'Ordered' AS Source FROM Product WHERE ProductID IN (SELECT ProductID FROM `Order`)
UNION
SELECT ProductID, Name, 'Supplied' FROM Product WHERE ProductID IN (SELECT ProductID FROM Supply);

-- 3. Aggregation Function: Calculate average order total
SELECT AVG(TotalAmount) AS AvgOrderValue FROM `Order`;

-- 4. Grouping Query: Count orders per customer
SELECT CustomerID, COUNT(OrderID) AS OrderCount
FROM `Order`
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1;

-- 5. Statistical Function: Standard deviation of order totals
SELECT STDDEV(TotalAmount) AS OrderTotalStdDev FROM `Order`;

-- 6. Recursive Query: Generate a sequence of dates for report generation
WITH RECURSIVE DateSeries AS (
    SELECT CURDATE() AS ReportDate
    UNION ALL
    SELECT ReportDate + INTERVAL 1 DAY FROM DateSeries WHERE ReportDate < CURDATE() + INTERVAL 6 DAY
)
SELECT * FROM DateSeries;

-- 7. Execution Plan Analysis Placeholder (Will analyze a query and optimize indexing)

-- Creating Views

-- View 1: Customer Order Summary (Uses a subquery in columns)
CREATE VIEW CustomerOrderSummary AS
SELECT C.CustomerID, C.Name, 
       (SELECT COUNT(*) FROM `Order` O WHERE O.CustomerID = C.CustomerID) AS OrderCount,
       (SELECT SUM(O.TotalAmount) FROM `Order` O WHERE O.CustomerID = C.CustomerID) AS TotalSpent
FROM Customer C;

-- View 2: Product Sales Overview (Uses subquery in FROM clause)
CREATE VIEW ProductSalesOverview AS
SELECT P.ProductID, P.Name, Sales.TotalRevenue
FROM Product P
LEFT JOIN (
    SELECT O.OrderID, SUM(O.TotalAmount) AS TotalRevenue
    FROM `Order` O
    GROUP BY O.OrderID
) Sales ON P.ProductID = Sales.OrderID;

-- View 3: Recent High-Value Orders (Uses subquery in WHERE clause)
CREATE VIEW HighValueOrders AS
SELECT * FROM `Order`
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM `Order`) AND OrderDate > CURDATE() - INTERVAL 30 DAY;

