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
