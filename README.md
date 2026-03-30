# ecommerce-sql-powerbi-analysis
End-to-end e-commerce data analysis project using SQL and Power BI to extract business insights on sales, customer behavior, delivery performance, and payment trends.

# 📊 E-Commerce Sales Analysis using SQL, Python & Power BI

---

## 📌 Overview

This project presents an end-to-end data analysis workflow on an e-commerce dataset (Brazil, 2016–2018). The project involves data ingestion using Python, data analysis using SQL, and interactive visualization using Power BI to derive business insights.

---

## 🎯 Problem Statement

As a data analyst, the objective was to analyze the dataset to extract meaningful insights and provide actionable recommendations related to:

* Sales trends
* Customer distribution
* Delivery performance
* Payment behavior

---

## 🔄 Data Pipeline (Python + SQL)

To efficiently handle the dataset, a data pipeline was built using Python:

* Automated loading of multiple CSV files into MySQL database
* Used `pandas` for data handling
* Used `SQLAlchemy` for database connection
* Handled encoding issues during file ingestion

### ⚙️ Key Steps:

* Read all CSV files from directory
* Dynamically created tables in MySQL
* Uploaded data using `to_sql()` method

---

## 🧮 SQL Analysis

### 🔍 Exploratory Data Analysis

* Checked schema and data types
* Identified order date ranges
* Counted cities and states

### 📈 Trend Analysis

* Yearly and monthly order trends
* Seasonality analysis
* Time-of-day ordering patterns

### 🌍 Regional Analysis

* Orders by state (month-on-month)
* Customer distribution across regions

### 💰 Economic Impact

* Revenue calculation using payment data
* Freight and order cost analysis
* Year-over-year cost comparison (2017 vs 2018)

### 🚚 Delivery Analysis

* Calculated delivery time
* Compared estimated vs actual delivery
* Identified fastest and slowest states

### 💳 Payment Analysis

* Orders by payment type
* Orders by installment count

---

## 📊 Power BI Dashboard

An interactive dashboard was built to visualize insights:

### 🔹 Features

* 📈 Order Trend Over Time
* 🌍 Orders by State (Map Visualization)
* 🏆 Top 10 States by Orders
* 💳 Revenue by Payment Method
* 📊 KPIs:

  * Total Orders
  * Total Revenue
  * Average Delivery Days
  * Average Order Value

### 🎛️ Filters

* Date range
* State
* Payment type

---

## 📸 Dashboard Preview

<img width="1728" height="967" alt="image" src="https://github.com/user-attachments/assets/46f8823e-9a03-4b56-9f74-ed6c6f4c1a33" />


---

## 🧠 Key Insights

* São Paulo contributes the highest number of orders
* Credit cards dominate revenue generation
* Orders show consistent growth from 2016 to 2018
* Peak activity observed in late 2017
* Average delivery time is approximately 12.5 days

---

## 🛠️ Tools & Technologies

* Python (Pandas, SQLAlchemy)
* SQL (MySQL)
* Power BI
* DAX

---

## 📁 Project Structure

* `dataLoad.ipynb` → Python script for data ingestion
* `dashboard.pbix` → Power BI dashboard
* `screenshots/` → Dashboard preview
* SQL queries (included separately)

---

## 💡 Learnings

* Built an end-to-end data pipeline (Python → SQL → Power BI)
* Automated data ingestion using Python
* Performed complex SQL-based analysis
* Designed interactive dashboards in Power BI
* Derived actionable business insights

---

## 🚀 Future Improvements

* Add predictive analysis (sales forecasting)
* Implement ETL pipelines using advanced tools
* Enhance dashboard UI/UX

---
