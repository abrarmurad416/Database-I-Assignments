-- Normalization to 3NF with Explanations and Sample Data

-- Functional Dependencies (FDs) and Normalization Justification

-- Customer Table
-- Primary Key: CustomerID
-- Functional Dependencies:
-- CustomerID → Name, Email, Address
-- 3NF Justification:
-- All attributes are fully functionally dependent on the primary key with no transitive dependencies, satisfying 3NF.

-- Product Table
-- Primary Key: ProductID
-- Functional Dependencies:
-- ProductID → Name, Price, SupplierID
-- 3NF Justification:
-- Attributes are fully dependent on the primary key. There are no transitive dependencies, ensuring 3NF.

-- Supplier Table (Decomposed from Supply Table)
-- Primary Key: SupplierID
-- Functional Dependencies:
-- SupplierID → SupplierName, ContactInfo
-- 3NF Justification:
-- All attributes are directly dependent on the primary key without transitive dependencies, meeting 3NF requirements.

-- Supply Table (Decomposed from Supply Table)
-- Primary Key: (SupplierID, ProductID)
-- Functional Dependencies:
-- (SupplierID, ProductID) → SupplyDate, Quantity
-- 3NF Justification:
-- The composite key uniquely determines all non-key attributes, with no transitive dependencies present.

-- Order Table
-- Primary Key: OrderID
-- Functional Dependencies:
-- OrderID → CustomerID, TotalAmount, OrderDate
-- 3NF Justification:
-- All attributes are fully dependent on the primary key with no transitive dependencies.

-- Payment Table
-- Primary Key: PaymentID
-- Functional Dependencies:
-- PaymentID → OrderID, PaymentDate, Amount
-- 3NF Justification:
-- Each attribute is directly dependent on the primary key, ensuring 3NF compliance.

-- Step-by-Step Decomposition of Supply Table
-- Original Functional Dependencies:
-- SupplyID → SupplierName, ContactInfo, ProductID, SupplyDate, Quantity
-- Issue:
-- SupplierName and ContactInfo depend on SupplierID, causing transitive dependencies.
-- Decomposition Process:
-- 1. Create 'Supplier' Table: Contains SupplierID, SupplierName, and ContactInfo.
-- 2. Create 'Supply' Table: Contains SupplierID, ProductID, SupplyDate, and Quantity.
-- This decomposition removes transitive dependencies, achieving 3NF.

-- Sample Data for Modified Tables

-- Supplier Table
INSERT INTO Supplier (SupplierID, SupplierName, ContactInfo)
VALUES (1, 'Supplier A', 'contact@supplierA.com'),
       (2, 'Supplier B', 'contact@supplierB.com');

-- Supply Table
INSERT INTO Supply (SupplierID, ProductID, SupplyDate, Quantity)
VALUES (1, 101, '2025-01-01', 50),
       (2, 102, '2025-01-02', 75);

-- Justification for 3NF Compliance
-- 1NF: All columns contain atomic values.
-- 2NF: No partial dependencies exist on a part of the composite key.
-- 3NF: No transitive dependencies are present.
