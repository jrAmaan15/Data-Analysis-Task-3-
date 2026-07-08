# 🛒 SQL for Data Analysis — E-commerce Database

A complete SQL data analysis project built on a realistic e-commerce schema. Covers filtering, aggregation, all join types, subqueries, views, and query optimization with indexes — using SQLite (portable to MySQL/PostgreSQL with minor tweaks).

## 📌 Objective

Use SQL queries to extract and analyze data from a relational database, demonstrating core data analysis skills: filtering, joining, aggregating, and optimizing queries for performance.

## 🧰 Tools Used

- **SQLite 3** (primary — zero setup, single-file database)
- Portable to **MySQL** / **PostgreSQL** (see [Porting Notes](#-porting-to-mysql--postgresql))

## 🗂️ Schema Overview

7 tables modeling a typical e-commerce store:

| Table | Description |
|---|---|
| `customers` | Customer profiles (name, email, city, country, signup date) |
| `categories` | Product categories |
| `products` | Product catalog (price, stock, category) |
| `employees` | Sales/support staff who process orders |
| `orders` | Order header (customer, employee, date, status) |
| `order_items` | Order line items (product, quantity, unit price at time of sale) |
| `reviews` | Product reviews and ratings |

```
customers ──┬──< orders >──┬── employees
            │               │
            └──< reviews    └──< order_items >── products ── categories
```

**Sample data:** 15 customers · 6 categories · 4 employees · 20 products · 25 orders · 33 order line items · 14 reviews

## 📁 Project Structure

```
├── 01_schema.sql                     # Table definitions (PK/FK constraints)
├── 02_seed_data.sql                  # Sample data inserts
├── 03_analysis_queries.sql           # All analysis queries (Sections A–F)
├── ecommerce_sql_analysis_FULL.sql   # All three files combined into one
├── ecommerce.db                      # Pre-built SQLite database, ready to query
├── 04_query_output.txt               # Captured real output of every query
└── README.md
```

## 📊 What's Covered

`03_analysis_queries.sql` is organized into six sections:

| Section | Topic | Examples |
|---|---|---|
| **A** | `SELECT`, `WHERE`, `ORDER BY` | Products under ₹1000, out-of-stock items, recent orders |
| **B** | `GROUP BY` + aggregates | Revenue per product, avg order value, category revenue, monthly trends, avg ratings |
| **C** | `INNER` / `LEFT` / `RIGHT JOIN` | Orders with customers, customers with zero orders, employees with zero processed orders, full 5-table order report |
| **D** | Subqueries | Scalar, derived table, correlated `NOT EXISTS`, `IN`, nested correlated |
| **E** | Views | `vw_order_summary`, `vw_monthly_revenue`, `vw_customer_ltv` |
| **F** | Indexes & optimization | `EXPLAIN QUERY PLAN` before/after indexing — shows `SCAN` → `SEARCH USING INDEX` |

## 🚀 Quick Start

```bash
# Clone or download this repo, then:
sqlite3 ecommerce.db ".read 01_schema.sql"
sqlite3 ecommerce.db ".read 02_seed_data.sql"
sqlite3 -header -column ecommerce.db ".read 03_analysis_queries.sql"
```

Or just open the pre-built `ecommerce.db` directly — no setup needed:

```bash
sqlite3 ecommerce.db
```

**GUI options:**
- [DB Browser for SQLite](https://sqlitebrowser.org/) — open `ecommerce.db` and browse visually
- VS Code — install the **SQLite Viewer** or **SQLTools + SQLTools SQLite Driver** extension

## 💡 Sample Query

```sql
-- Top 5 customers by total completed spend
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
```

## ⚡ Query Optimization Example

Before indexing, filtering `order_items` by `product_id` does a full table scan:
```
QUERY PLAN
`--SCAN order_items
```

After adding `CREATE INDEX idx_order_items_product_id ON order_items(product_id);`:
```
QUERY PLAN
`--SEARCH order_items USING INDEX idx_order_items_product_id (product_id=?)
```

## 🔄 Porting to MySQL / PostgreSQL

The SQL is ~95% portable. Three changes needed:

| SQLite | PostgreSQL | MySQL |
|---|---|---|
| `INTEGER PRIMARY KEY AUTOINCREMENT` | `SERIAL PRIMARY KEY` | `INT AUTO_INCREMENT PRIMARY KEY` |
| `strftime('%Y-%m', order_date)` | `TO_CHAR(order_date, 'YYYY-MM')` | `DATE_FORMAT(order_date, '%Y-%m')` |
| `EXPLAIN QUERY PLAN` | `EXPLAIN ANALYZE` | `EXPLAIN` |

## 🎯 Key Design Choices

- **Arjun Nair** (customer_id 15) has zero orders — makes the "customers with no orders" LEFT JOIN meaningful.
- **Blender** and **Herbal Shampoo** are out of stock — makes stock-filtering queries non-trivial.
- Order statuses include `Completed` / `Pending` / `Cancelled` / `Returned` for realistic status breakdowns.
- `order_items.unit_price` stores the price **at time of purchase**, not a live lookup — mirrors real systems where historical order totals shouldn't change if a product's price changes later.

## 📈 Outcome

This project demonstrates the ability to manipulate and query structured relational data using SQL — from basic filtering through multi-table joins, subqueries, reusable views, and index-based query optimization.

## 📄 License

Free to use for learning purposes.
