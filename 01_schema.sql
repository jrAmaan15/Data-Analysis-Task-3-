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
