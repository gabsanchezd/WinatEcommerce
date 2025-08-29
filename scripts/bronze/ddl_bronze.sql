/*
==============================================================================
DDL Script: Create Bronze Tables
This script creates tables in the 'bronze' schema layer architecture, dropping
existing tables if they already exist.

Run this script to redefine the DDL structure of 'bronze' layer tables.
==============================================================================
*/

IF OBJECT_ID('bronze.ChannelDim', 'U') is not NULL
    DROP TABLE bronze.ChannelDim;
GO

CREATE TABLE bronze.ChannelDim (
    ChannelID INT PRIMARY KEY,
    SalesChannel VARCHAR(100),
    CampaignID VARCHAR(50),
    SourceMedium VARCHAR(100),
    AffiliatePartner VARCHAR(100)
);
GO

IF OBJECT_ID('bronze.CustomerDim', 'U') is not NULL
    DROP TABLE bronze.CustomerDim;
GO

CREATE TABLE bronze.CustomerDim (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Gender VARCHAR(100),
    Age INT,
    Segment VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    ZipCode VARCHAR(20),
    AcquisitionChannel VARCHAR(50),
    LoyaltyTier VARCHAR(50),
    CLV DECIMAL(12,2)
);
GO

IF OBJECT_ID('bronze.EmployeeDim', 'U') is not NULL
    DROP TABLE bronze.EmployeeDim;
GO

CREATE TABLE bronze.EmployeeDim (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Role VARCHAR(50),
    Department VARCHAR(50),
    SalesRegion VARCHAR(100),
    CommissionRate DECIMAL(5,2)
);
GO

IF OBJECT_ID('bronze.InventoryFact', 'U') is not NULL
    DROP TABLE bronze.InventoryFact;
GO

CREATE TABLE bronze.InventoryFact (
    InventoryFactID BIGINT PRIMARY KEY,
    DateID INT,
    ProductID INT,
    WarehouseID INT,
    SupplierID INT,
    StockLevel INT,
    ReorderPoint INT,
    DaysOnHand INT
);
GO

IF OBJECT_ID('bronze.LocationDim', 'U') is not NULL
    DROP TABLE bronze.LocationDim;
GO

CREATE TABLE bronze.LocationDim (
    LocationID INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    ZipCode VARCHAR(20),
    MarketSegment VARCHAR(100)
);
GO

IF OBJECT_ID('bronze.MarketingFact', 'U') is not NULL
    DROP TABLE bronze.MarketingFact;
GO

CREATE TABLE bronze.MarketingFact (
    MarketingFactID BIGINT PRIMARY KEY,
    DateID INT,
    ChannelID INT,
    CampaignID VARCHAR(50),
    AdSpend DECIMAL(12,2),
    Impressions BIGINT,
    Clicks BIGINT,
    Conversions BIGINT,
    ROI DECIMAL(8,2)
);
GO

IF OBJECT_ID('bronze.ProductDim', 'U') is not NULL
    DROP TABLE bronze.ProductDim;
GO

CREATE TABLE bronze.ProductDim (
    ProductID INT PRIMARY KEY,
    SKU VARCHAR(50),
    PartNumber VARCHAR(50),
    ProductName VARCHAR(200),
    Brand VARCHAR(100),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    Compatibility TEXT,
    Price DECIMAL(10,2),
    Cost DECIMAL(10,2),
    WarrantyPeriod VARCHAR(50)
);
GO

IF OBJECT_ID('bronze.ReturnsFact', 'U') is not NULL
    DROP TABLE bronze.ReturnsFact;
GO

CREATE TABLE bronze.ReturnsFact (
    ReturnsFactID BIGINT PRIMARY KEY,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    ChannelID INT,
    ReasonID INT,
    ReturnQty INT,
    ReturnAmount DECIMAL(12,2)
);
GO

IF OBJECT_ID('bronze.SalesFact', 'U') is not NULL
    DROP TABLE bronze.SalesFact;
GO

CREATE TABLE bronze.SalesFact (
    SalesFactID BIGINT PRIMARY KEY,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    ChannelID INT,
    EmployeeID INT,
    LocationID INT,
    SupplierID INT,
    Quantity INT,
    SalesAmount DECIMAL(12,2),
    Discount DECIMAL(12,2),
    ProfitMargin DECIMAL(12,2)
);
