---------------------------------------------------
-- Medium Level – Transaction Data & Summary Views
---------------------------------------------------

-- Drop dependent views first
IF OBJECT_ID('sale_summary_mv', 'V') IS NOT NULL
    DROP VIEW sale_summary_mv;
GO

IF OBJECT_ID('sales_summary_view', 'V') IS NOT NULL
    DROP VIEW sales_summary_view;
GO

-- Drop table safely
IF OBJECT_ID('transaction_data', 'U') IS NOT NULL
    DROP TABLE transaction_data;
GO

-- Create transaction_data table with BIGINT to prevent overflow
CREATE TABLE transaction_data (
    id INT,
    value BIGINT
);
GO

-- Insert 1 million rows for id = 1
WITH Numbers AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects AS a CROSS JOIN sys.objects AS b
)
INSERT INTO transaction_data (id, value)
SELECT 1, CAST(RAND(CHECKSUM(NEWID())) * 1000 AS BIGINT)
FROM Numbers;
GO

-- Insert 1 million rows for id = 2
WITH Numbers AS (
    SELECT TOP (1000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects AS a CROSS JOIN sys.objects AS b
)
INSERT INTO transaction_data (id, value)
SELECT 2, CAST(RAND(CHECKSUM(NEWID())) * 1000 AS BIGINT)
FROM Numbers;
GO

-- Create normal summary view
CREATE VIEW sales_summary_view AS
SELECT
    id,
    COUNT(*) AS total_orders,
    SUM(value) AS total_sales,
    AVG(value * 1.0) AS avg_transaction
FROM transaction_data
GROUP BY id;
GO

-- Query the view
SELECT TOP 10 * FROM sales_summary_view;
GO

---------------------------------------------------
-- Hard Level – Customer, Product, Orders, Order Summary
---------------------------------------------------

-- Drop dependent view first
IF OBJECT_ID('vw_order_summary', 'V') IS NOT NULL
    DROP VIEW vw_order_summary;
GO

-- Drop tables if exist
IF OBJECT_ID('sales_orders', 'U') IS NOT NULL DROP TABLE sales_orders;
IF OBJECT_ID('product_catalog', 'U') IS NOT NULL DROP TABLE product_catalog;
IF OBJECT_ID('customer_master', 'U') IS NOT NULL DROP TABLE customer_master;
GO

-- Create customer_master table
CREATE TABLE customer_master (
    customer_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(50),
    city VARCHAR(30)
);
GO

-- Create product_catalog table
CREATE TABLE product_catalog (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    brand VARCHAR(30),
    unit_price NUMERIC(10,2) NOT NULL
);
GO

-- Create sales_orders table
CREATE TABLE sales_orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id VARCHAR(5) REFERENCES product_catalog(product_id),
    quantity INT NOT NULL,
    customer_id VARCHAR(5) REFERENCES customer_master(customer_id),
    discount_percent NUMERIC(5,2),
    order_date DATE NOT NULL
);
GO

-- Insert data into customer_master
INSERT INTO customer_master (customer_id, full_name, phone, email, city) VALUES
('C1', 'Amit Sharma', '9876543210', 'amit.sharma@example.com', 'Delhi'),
('C2', 'Priya Verma', '9876501234', 'priya.verma@example.com', 'Mumbai'),
('C3', 'Ravi Kumar', '9988776655', 'ravi.kumar@example.com', 'Bangalore'),
('C4', 'Neha Singh', '9123456789', 'neha.singh@example.com', 'Kolkata'),
('C5', 'Arjun Mehta', '9812345678', 'arjun.mehta@example.com', 'Hyderabad'),
('C6', 'Sneha Reddy', '9090909090', 'sneha.reddy@example.com', 'Chennai'),
('C7', 'Vikram Das', '9123412345', 'vikram.das@example.com', 'Pune'),
('C8', 'Rohit Gupta', '9000000001', 'rohit.gupta@example.com', 'Lucknow'),
('C9', 'Pooja Nair', '9898989898', 'pooja.nair@example.com', 'Kochi'),
('C10', 'Ankit Yadav', '9345678901', 'ankit.yadav@example.com', 'Ahmedabad');
GO

-- Insert data into product_catalog
INSERT INTO product_catalog (product_id, product_name, brand, unit_price) VALUES
('P1', 'Smartphone X100', 'Samsung', 25000.00),
('P2', 'Laptop Pro 15', 'Dell', 65000.00),
('P3', 'Wireless Earbuds', 'Sony', 5000.00),
('P4', 'Smartwatch Fit', 'Apple', 30000.00),
('P5', 'Tablet 10.5', 'Lenovo', 22000.00),
('P6', 'Gaming Console', 'Sony', 45000.00),
('P7', 'Bluetooth Speaker', 'JBL', 7000.00),
('P8', 'Digital Camera', 'Canon', 55000.00),
('P9', 'LED TV 55 inch', 'LG', 60000.00),
('P10', 'Power Bank 20000mAh', 'Mi', 2500.00);
GO

-- Insert data into sales_orders
INSERT INTO sales_orders (product_id, quantity, customer_id, discount_percent, order_date) VALUES
('P1', 2, 'C1', 5.00, '2025-09-01'),
('P2', 1, 'C2', 10.00, '2025-09-02'),
('P3', 3, 'C3', 0.00, '2025-09-03'),
('P4', 1, 'C4', 8.00, '2025-09-04'),
('P5', 2, 'C5', 5.00, '2025-09-05'),
('P6', 1, 'C1', 12.00, '2025-09-06'),
('P7', 2, 'C2', 0.00, '2025-09-07'),
('P8', 1, 'C3', 10.00, '2025-09-08'),
('P9', 1, 'C6', 15.00, '2025-09-09'),
('P10', 4, 'C7', 0.00, '2025-09-10'),
('P1', 1, 'C8', 5.00, '2025-09-11'),
('P2', 2, 'C9', 10.00, '2025-09-12'),
('P3', 2, 'C10', 0.00, '2025-09-13'),
('P4', 1, 'C5', 8.00, '2025-09-14'),
('P5', 3, 'C6', 5.00, '2025-09-15'),
('P6', 1, 'C7', 12.00, '2025-09-16'),
('P7', 2, 'C8', 0.00, '2025-09-17'),
('P8', 1, 'C9', 10.00, '2025-09-18'),
('P9', 1, 'C10', 15.00, '2025-09-19'),
('P10', 5, 'C4', 0.00, '2025-09-20');
GO

-- Create order summary view
CREATE VIEW vw_order_summary AS
SELECT
    O.order_id,
    O.order_date,
    P.product_name,
    C.full_name,
    (P.unit_price * O.quantity) - ((P.unit_price * O.quantity) * O.discount_percent / 100) AS final_cost
FROM customer_master AS C
JOIN sales_orders AS O ON O.customer_id = C.customer_id
JOIN product_catalog AS P ON P.product_id = O.product_id;
GO

-- Query order summary
SELECT TOP 10 * FROM vw_order_summary;
GO

-- Create role and grant permission
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'sresta')
    CREATE ROLE sresta;
GO

GRANT SELECT ON vw_order_summary TO sresta;
-- REVOKE SELECT ON vw_order_summary FROM sresta; -- Uncomment to revoke
GO
