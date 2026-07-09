CREATE DATABASE electronics_analytics;
USE electronics_analytics;

-- 1. CUSTOMERS
CREATE TABLE customers (
    CustomerKey       INT PRIMARY KEY,
    Gender            VARCHAR(10),
    Name              VARCHAR(100),
    City              VARCHAR(100),
    State_Code        VARCHAR(10),
    State             VARCHAR(100),
    Zip_Code          VARCHAR(20),
    Country           VARCHAR(100),
    Continent         VARCHAR(50),
    Birthday          DATE
);

--  2. PRODUCTS 
CREATE TABLE products (
    ProductKey        INT PRIMARY KEY,
    Product_Name      VARCHAR(200),
    Brand             VARCHAR(100),
    Color             VARCHAR(50),
    Unit_Cost_USD     DECIMAL(10,2),
    Unit_Price_USD    DECIMAL(10,2),
    SubcategoryKey    INT,
    Subcategory       VARCHAR(100),
    CategoryKey       INT,
    Category          VARCHAR(100)
);

--  3. STORES 
CREATE TABLE stores (
    StoreKey          INT PRIMARY KEY,
    Country           VARCHAR(100),
    State             VARCHAR(100),
    Square_Meters     INT,
    Open_Date         DATE
);

--  4. EXCHANGE RATES 
CREATE TABLE exchange_rates (
    Date              DATE,
    Currency          VARCHAR(10),
    Exchange          DECIMAL(10,6)
);

--  5. SALES (import this LAST) 
CREATE TABLE sales (
    Order_Number      VARCHAR(20),
    Line_Item         INT,
    Order_Date        DATE,
    Delivery_Date     DATE,
    CustomerKey       INT,
    StoreKey          INT,
    ProductKey        INT,
    Quantity          INT,
    Currency_Code     VARCHAR(10),
    FOREIGN KEY (CustomerKey) REFERENCES customers(CustomerKey),
    FOREIGN KEY (StoreKey)    REFERENCES stores(StoreKey),
    FOREIGN KEY (ProductKey)  REFERENCES products(ProductKey)
);