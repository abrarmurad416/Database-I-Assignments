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



