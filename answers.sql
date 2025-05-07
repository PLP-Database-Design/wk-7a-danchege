-- Question 1.

-- Original table violated 1NF because Products column contains multiple values (comma-separated values).
-- To convert the table to 1NF, we need to create a new table where each product is in a separate row.
-- Created a new 1NF-compliant table using the following SQL query
CREATE TABLE OrderDetails_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit+1), ',', -1)) AS Product
FROM 
    ProductDetail
JOIN
    (SELECT 0 AS digit UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) n
    ON LENGTH(REPLACE(Products, ',', '')) <= LENGTH(Products)-n.digit
WHERE
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.digit+1), ',', -1)) <> '';
-- The query splits comma-separated products into separate rows
-- The querry uses a numbers table (0-3 in this case) to handle up to 4 products per order
-- SUBSTRING_INDEX extracts each product from the list

-- Question 2.
-- Original table violated 2NF because CustomerName is partially dependent on OrderID (non-prime attribute).
-- To convert the table to 2NF, we need to create two new tables: Orders and OrderItems.

-- Created Orders table (removes partial dependency of CustomerName on OrderID)
CREATE TABLE Orders AS
SELECT DISTINCT 
    OrderID, 
    CustomerName
FROM 
    OrderDetails;

-- Created OrderItems table (contains only full dependencies)
CREATE TABLE OrderItems AS
SELECT 
    OrderID,
    Product,
    Quantity
FROM 
    OrderDetails;

-- Added primary keys to the new tables to ensure uniqueness and to enhance data integrity
-- OrderID is the primary key for Orders table
-- OrderID and Product together form the primary key for OrderItems table
ALTER TABLE Orders ADD PRIMARY KEY (OrderID);
ALTER TABLE OrderItems ADD PRIMARY KEY (OrderID, Product);