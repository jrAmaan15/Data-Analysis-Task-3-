-- =====================================================================
-- FILE: 01_schema.sql
-- PROJECT: SQL for Data Analysis - E-commerce Database
-- PURPOSE: Create all tables with proper keys, constraints, and types
-- ENGINE: SQLite (syntax is 95% portable to MySQL / PostgreSQL - notes
--         on differences are included as comments where relevant)
-- =====================================================================

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;

-- ---------------------------------------------------------------------
-- CUSTOMERS
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    city            TEXT,
    country         TEXT,
    signup_date     DATE NOT NULL
);

-- ---------------------------------------------------------------------
-- CATEGORIES
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    category_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name   TEXT NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- EMPLOYEES (handles orders / sales reps) - used for JOIN practice
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    employee_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name       TEXT NOT NULL,
    department      TEXT NOT NULL
);

-- ---------------------------------------------------------------------
-- PRODUCTS
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name    TEXT NOT NULL,
    category_id     INTEGER NOT NULL,
    price           DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ---------------------------------------------------------------------
-- ORDERS  (one order = one purchase event by a customer)
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id     INTEGER NOT NULL,
    employee_id     INTEGER,                 -- rep who processed it, NULL = self-service
    order_date      DATE NOT NULL,
    status          TEXT NOT NULL DEFAULT 'Completed'
                        CHECK (status IN ('Completed','Pending','Cancelled','Returned')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- ---------------------------------------------------------------------
-- ORDER_ITEMS (line items - many-to-many bridge between orders/products)
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL,
    product_id      INTEGER NOT NULL,
    quantity        INTEGER NOT NULL CHECK (quantity > 0),
    unit_price      DECIMAL(10,2) NOT NULL,   -- price at time of purchase
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ---------------------------------------------------------------------
-- REVIEWS - used for extra JOIN / subquery practice
-- ---------------------------------------------------------------------
CREATE TABLE reviews (
    review_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id      INTEGER NOT NULL,
    customer_id     INTEGER NOT NULL,
    rating          INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date     DATE NOT NULL,
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- =====================================================================
-- FILE: 02_seed_data.sql
-- PURPOSE: Populate the database with realistic sample e-commerce data
-- =====================================================================

-- ---------------------------------------------------------------------
-- CUSTOMERS (15 rows, different countries/cities, different signup dates)
-- ---------------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, city, country, signup_date) VALUES
('Amaan',   'Ansari',   'amaan.ansari@example.com',   'Delhi',      'India',   '2023-01-15'),
('Priya',   'Sharma',   'priya.sharma@example.com',   'Mumbai',     'India',   '2023-02-20'),
('Rahul',   'Verma',    'rahul.verma@example.com',    'Bengaluru',  'India',   '2023-03-05'),
('Sara',    'Khan',     'sara.khan@example.com',      'Hyderabad',  'India',   '2023-03-18'),
('John',    'Smith',    'john.smith@example.com',     'New York',   'USA',     '2023-04-02'),
('Emily',   'Davis',    'emily.davis@example.com',    'Chicago',    'USA',     '2023-04-25'),
('Wei',     'Zhang',    'wei.zhang@example.com',      'Shanghai',   'China',   '2023-05-10'),
('Aiko',    'Tanaka',   'aiko.tanaka@example.com',    'Tokyo',      'Japan',   '2023-05-28'),
('Liam',    'O''Brien', 'liam.obrien@example.com',    'Dublin',     'Ireland', '2023-06-14'),
('Sofia',   'Rossi',    'sofia.rossi@example.com',    'Milan',      'Italy',   '2023-07-01'),
('Noah',    'Müller',   'noah.mueller@example.com',   'Berlin',     'Germany', '2023-07-19'),
('Fatima',  'Ali',      'fatima.ali@example.com',     'Karachi',    'Pakistan','2023-08-08'),
('Carlos',  'Garcia',   'carlos.garcia@example.com',  'Madrid',     'Spain',   '2023-08-30'),
('Mia',     'Brown',    'mia.brown@example.com',      'London',     'UK',      '2023-09-12'),
('Arjun',   'Nair',     'arjun.nair@example.com',     'Chennai',    'India',   '2023-10-01');

-- ---------------------------------------------------------------------
-- CATEGORIES
-- ---------------------------------------------------------------------
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Home & Kitchen'),
('Books'),
('Clothing'),
('Sports & Fitness'),
('Beauty & Personal Care');

-- ---------------------------------------------------------------------
-- EMPLOYEES (sales reps who process some orders)
-- ---------------------------------------------------------------------
INSERT INTO employees (full_name, department) VALUES
('Neha Kapoor',   'Sales'),
('David Lee',     'Sales'),
('Grace Kim',     'Customer Support'),
('Tom Richards',  'Sales');

-- ---------------------------------------------------------------------
-- PRODUCTS (varied categories, prices, stock levels - includes some
-- zero-stock items to make WHERE-clause practice meaningful)
-- ---------------------------------------------------------------------
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Wireless Mouse',              1, 799.00,  120),
('Mechanical Keyboard',         1, 3499.00,  45),
('Noise Cancelling Headphones', 1, 5999.00,  30),
('27" 4K Monitor',              1, 21999.00, 10),
('USB-C Hub',                   1, 1299.00,  75),
('Non-stick Frying Pan',        2, 899.00,   60),
('Electric Kettle',             2, 1499.00,  40),
('Ceramic Dinner Set',          2, 2799.00,  15),
('Blender',                     2, 2199.00,  0),
('Atomic Habits (Book)',        3, 399.00,   200),
('The Pragmatic Programmer',    3, 899.00,   85),
('Sapiens (Book)',              3, 499.00,   150),
('Men''s Running Shoes',        4, 2499.00,  55),
('Women''s Denim Jacket',       4, 1999.00,  38),
('Cotton T-Shirt',              4, 499.00,   300),
('Yoga Mat',                    5, 999.00,   90),
('Adjustable Dumbbell Set',     5, 6499.00,  12),
('Resistance Bands',            5, 599.00,   140),
('Face Moisturizer',            6, 649.00,   110),
('Herbal Shampoo',              6, 399.00,   0);

-- ---------------------------------------------------------------------
-- ORDERS (25 orders across customers, dates in 2023-2024, various status)
-- Note: customer_id 15 (Arjun Nair) intentionally has ZERO orders,
-- useful later for LEFT JOIN / "customers with no orders" queries.
-- ---------------------------------------------------------------------
INSERT INTO orders (customer_id, employee_id, order_date, status) VALUES
(1,  1, '2023-11-02', 'Completed'),
(1,  NULL, '2024-01-15', 'Completed'),
(2,  2, '2023-11-05', 'Completed'),
(3,  NULL, '2023-11-10', 'Cancelled'),
(4,  1, '2023-11-12', 'Completed'),
(5,  2, '2023-11-20', 'Completed'),
(6,  NULL, '2023-12-01', 'Returned'),
(7,  3, '2023-12-05', 'Completed'),
(8,  NULL, '2023-12-10', 'Completed'),
(9,  4, '2023-12-15', 'Pending'),
(10, NULL, '2023-12-18', 'Completed'),
(2,  1, '2024-01-03', 'Completed'),
(3,  NULL, '2024-01-08', 'Completed'),
(11, 2, '2024-01-11', 'Completed'),
(12, NULL, '2024-01-14', 'Completed'),
(13, 3, '2024-01-20', 'Cancelled'),
(14, NULL, '2024-01-25', 'Completed'),
(1,  4, '2024-02-01', 'Completed'),
(5,  NULL, '2024-02-05', 'Completed'),
(6,  1, '2024-02-08', 'Completed'),
(7,  NULL, '2024-02-14', 'Completed'),
(9,  2, '2024-02-19', 'Returned'),
(10, NULL, '2024-02-22', 'Completed'),
(12, 3, '2024-03-01', 'Completed'),
(2,  NULL, '2024-03-05', 'Completed');

-- ---------------------------------------------------------------------
-- ORDER_ITEMS (line items - each order has 1-3 products)
-- ---------------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 799.00), (1, 5, 2, 1299.00),
(2, 10, 3, 399.00),
(3, 3, 1, 5999.00),
(4, 6, 1, 899.00),
(5, 13, 1, 2499.00), (5, 18, 2, 599.00),
(6, 2, 1, 3499.00),
(7, 9, 1, 2199.00),
(8, 11, 2, 899.00), (8, 12, 1, 499.00),
(9, 4, 1, 21999.00),
(10, 16, 3, 999.00),
(11, 7, 1, 1499.00), (11, 8, 1, 2799.00),
(12, 1, 2, 799.00),
(13, 14, 1, 1999.00),
(14, 19, 4, 649.00),
(15, 3, 1, 5999.00), (15, 5, 1, 1299.00),
(16, 17, 1, 6499.00),
(17, 15, 5, 499.00),
(18, 2, 1, 3499.00), (18, 1, 1, 799.00),
(19, 20, 2, 399.00),
(20, 6, 2, 899.00),
(21, 10, 1, 399.00), (21, 11, 1, 899.00),
(22, 13, 1, 2499.00),
(23, 9, 1, 2199.00),
(24, 4, 1, 21999.00),
(25, 16, 2, 999.00), (25, 18, 1, 599.00);

-- ---------------------------------------------------------------------
-- REVIEWS
-- ---------------------------------------------------------------------
INSERT INTO reviews (product_id, customer_id, rating, review_date) VALUES
(1, 1, 5, '2023-11-10'),
(1, 2, 4, '2024-01-05'),
(3, 3, 5, '2023-11-18'),
(3, 5, 2, '2024-02-01'),
(10, 1, 5, '2024-01-20'),
(10, 8, 4, '2023-12-20'),
(13, 5, 3, '2023-11-28'),
(17, 6, 5, '2024-02-15'),
(2, 6, 4, '2023-12-08'),
(9, 7, 1, '2023-12-12'),
(19, 9, 4, '2024-01-16'),
(4, 9, 5, '2023-12-22'),
(16, 10, 4, '2023-12-25'),
(6, 4, 3, '2023-11-16');
-- =====================================================================
-- FILE: 03_analysis_queries.sql
-- PROJECT: SQL for Data Analysis - E-commerce Database
-- PURPOSE: All analysis queries required by the assignment:
--   a. SELECT, WHERE, ORDER BY
--   b. GROUP BY + aggregate functions (SUM, AVG, COUNT)
--   c. JOINS - INNER, LEFT, RIGHT
--   d. Subqueries
--   e. Views
--   f. Indexes + query optimization (EXPLAIN QUERY PLAN)
-- =====================================================================


-- =====================================================================
-- SECTION A: SELECT, WHERE, ORDER BY
-- =====================================================================

-- A1. List all products under Rs. 1000, cheapest first
SELECT product_name, category_id, price, stock_quantity
FROM products
WHERE price < 1000
ORDER BY price ASC;

-- A2. Find all customers who signed up from India, most recent first
SELECT customer_id, first_name, last_name, city, signup_date
FROM customers
WHERE country = 'India'
ORDER BY signup_date DESC;

-- A3. Products that are out of stock
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity = 0;

-- A4. All completed orders placed in 2024, latest first
SELECT order_id, customer_id, order_date, status
FROM orders
WHERE status = 'Completed'
  AND order_date >= '2024-01-01'
ORDER BY order_date DESC;


-- =====================================================================
-- SECTION B: GROUP BY + AGGREGATE FUNCTIONS (SUM, AVG, COUNT)
-- =====================================================================

-- B1. Total revenue and number of items sold per product
SELECT
    p.product_name,
    SUM(oi.quantity)                       AS total_units_sold,
    SUM(oi.quantity * oi.unit_price)       AS total_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;

-- B2. Average order value per customer (only completed orders)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name     AS customer_name,
    COUNT(DISTINCT o.order_id)             AS num_orders,
    ROUND(AVG(order_totals.order_total), 2) AS avg_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) order_totals ON order_totals.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, customer_name
ORDER BY avg_order_value DESC;

-- B3. Revenue by product category
SELECT
    cat.category_name,
    COUNT(DISTINCT oi.order_id)            AS orders_containing_category,
    SUM(oi.quantity)                       AS units_sold,
    SUM(oi.quantity * oi.unit_price)       AS category_revenue
FROM order_items oi
JOIN products p    ON p.product_id = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
GROUP BY cat.category_id, cat.category_name
ORDER BY category_revenue DESC;

-- B4. Order count and status breakdown per month
SELECT
    strftime('%Y-%m', order_date)          AS order_month,
    status,
    COUNT(*)                               AS num_orders
FROM orders
GROUP BY order_month, status
ORDER BY order_month, status;

-- B5. Average product rating (only products with at least 2 reviews)
SELECT
    p.product_name,
    COUNT(r.review_id)                     AS num_reviews,
    ROUND(AVG(r.rating), 2)                AS avg_rating
FROM reviews r
JOIN products p ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(r.review_id) >= 2
ORDER BY avg_rating DESC;


-- =====================================================================
-- SECTION C: JOINS - INNER, LEFT, RIGHT
-- =====================================================================

-- C1. INNER JOIN: orders with customer details (only orders that have
--     a matching customer - i.e. all of them, since customer_id is
--     NOT NULL, but this is the canonical inner-join pattern)
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.status
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- C2. LEFT JOIN: every customer, and their orders if any exist.
--     Customers with no orders (e.g. Arjun Nair) still appear, with
--     NULL order fields - useful for finding inactive customers.
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

-- C2b. Practical use of the LEFT JOIN above: customers who have NEVER
--      placed an order
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- C3. RIGHT JOIN: every employee, and orders they've handled (if any).
--     Employees who have never processed an order still appear.
--     (SQLite 3.39+ / PostgreSQL / MySQL 8+ all support RIGHT JOIN;
--      for older MySQL, flip table order and use LEFT JOIN instead.)
SELECT
    e.employee_id,
    e.full_name,
    e.department,
    o.order_id,
    o.order_date
FROM orders o
RIGHT JOIN employees e ON e.employee_id = o.employee_id
ORDER BY e.employee_id;

-- C4. Multi-table JOIN: full order detail report (order -> customer ->
--     order_items -> product -> category)
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.product_name,
    cat.category_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price)      AS line_total,
    o.order_date,
    o.status
FROM orders o
JOIN customers c    ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
JOIN categories cat  ON cat.category_id = p.category_id
ORDER BY o.order_id;


-- =====================================================================
-- SECTION D: SUBQUERIES
-- =====================================================================

-- D1. Scalar subquery: products priced above the overall average price
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

-- D2. Subquery in FROM (derived table): top 5 customers by total spend
SELECT customer_name, total_spent
FROM (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(oi.quantity * oi.unit_price)   AS total_spent
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, customer_name
) AS customer_spend
ORDER BY total_spent DESC
LIMIT 5;

-- D3. Correlated subquery: products that have never been ordered
SELECT product_name, price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);

-- D4. Subquery with IN: customers who bought from the 'Electronics'
--     category
SELECT DISTINCT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name
FROM customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    JOIN categories cat  ON cat.category_id = p.category_id
    WHERE cat.category_name = 'Electronics'
);

-- D5. Correlated subquery: each product's revenue compared to its
--     category's average product revenue (find over-performers)
SELECT
    p.product_name,
    cat.category_name,
    (SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0)
       FROM order_items oi WHERE oi.product_id = p.product_id) AS product_revenue
FROM products p
JOIN categories cat ON cat.category_id = p.category_id
WHERE (SELECT COALESCE(SUM(oi.quantity * oi.unit_price), 0)
         FROM order_items oi WHERE oi.product_id = p.product_id)
      > (SELECT AVG(rev) FROM (
            SELECT COALESCE(SUM(oi2.quantity * oi2.unit_price), 0) AS rev
            FROM products p2
            LEFT JOIN order_items oi2 ON oi2.product_id = p2.product_id
            WHERE p2.category_id = p.category_id
            GROUP BY p2.product_id
        ))
ORDER BY product_revenue DESC;


-- =====================================================================
-- SECTION E: VIEWS
-- =====================================================================

-- E1. View: order summary (one row per order with total value)
DROP VIEW IF EXISTS vw_order_summary;
CREATE VIEW vw_order_summary AS
SELECT
    o.order_id,
    o.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.unit_price)   AS order_total
FROM orders o
JOIN customers c    ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, customer_name, o.order_date, o.status;

-- Query the view like a normal table:
SELECT * FROM vw_order_summary ORDER BY order_total DESC;

-- E2. View: monthly revenue report
DROP VIEW IF EXISTS vw_monthly_revenue;
CREATE VIEW vw_monthly_revenue AS
SELECT
    strftime('%Y-%m', o.order_date)    AS month,
    COUNT(DISTINCT o.order_id)         AS num_orders,
    SUM(oi.quantity * oi.unit_price)   AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY month;

SELECT * FROM vw_monthly_revenue ORDER BY month;

-- E3. View: customer lifetime value (CLV), builds on vw_order_summary
DROP VIEW IF EXISTS vw_customer_ltv;
CREATE VIEW vw_customer_ltv AS
SELECT
    customer_id,
    customer_name,
    COUNT(order_id)         AS total_orders,
    SUM(order_total)        AS lifetime_value,
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM vw_order_summary
WHERE status = 'Completed'
GROUP BY customer_id, customer_name;

SELECT * FROM vw_customer_ltv ORDER BY lifetime_value DESC;


-- =====================================================================
-- SECTION F: INDEXES + QUERY OPTIMIZATION
-- =====================================================================

-- F1. Check the query plan BEFORE adding indexes (likely a full table
--     scan on orders and order_items)
EXPLAIN QUERY PLAN
SELECT o.order_id, o.order_date, c.first_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.customer_id = 5;

EXPLAIN QUERY PLAN
SELECT * FROM order_items WHERE product_id = 10;

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';

-- F2. Create indexes on foreign keys and frequently filtered columns.
--     These are the columns used most often in WHERE / JOIN / ORDER BY
--     clauses throughout this analysis.
CREATE INDEX IF NOT EXISTS idx_orders_customer_id   ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_employee_id   ON orders(employee_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date    ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_status        ON orders(status);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id   ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_price       ON products(price);

CREATE INDEX IF NOT EXISTS idx_reviews_product_id  ON reviews(product_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer_id ON reviews(customer_id);

CREATE INDEX IF NOT EXISTS idx_customers_country ON customers(country);

-- F3. Re-run the SAME queries AFTER indexing - the query plan should
--     now show "SEARCH ... USING INDEX" instead of "SCAN" for the
--     indexed columns, confirming the optimizer is using them.
EXPLAIN QUERY PLAN
SELECT o.order_id, o.order_date, c.first_name
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.customer_id = 5;

EXPLAIN QUERY PLAN
SELECT * FROM order_items WHERE product_id = 10;

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE order_date BETWEEN '2024-01-01' AND '2024-01-31';

-- F4. List every index created, for documentation purposes
SELECT name, tbl_name, sql
FROM sqlite_master
WHERE type = 'index' AND sql IS NOT NULL
ORDER BY tbl_name;
