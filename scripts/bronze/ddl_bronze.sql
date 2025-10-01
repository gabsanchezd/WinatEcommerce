/*
==============================================================================
DDL Script: Create Bronze Tables
This script creates tables in the 'bronze' schema layer architecture, dropping
existing tables if they already exist.

Run this script to redefine the DDL structure of 'bronze' layer tables.
==============================================================================
*/

IF OBJECT_ID ('bronze.CarrierDim' , 'U') IS NOT NULL
    DROP TABLE bronze.CarrierDim;
CREATE TABLE bronze.CarrierDim (
    CarrierID    INT            NOT NULL PRIMARY KEY,
    CarrierName  NVARCHAR(100)  NULL,
    ServiceLevel NVARCHAR(50)   NULL
);

IF OBJECT_ID ('bronze.ChannelDim' , 'U') IS NOT NULL
    DROP TABLE bronze.ChannelDim;
CREATE TABLE bronze.ChannelDim (
    ChannelID        INT           NOT NULL PRIMARY KEY,
    SalesChannel     VARCHAR(20)   NULL,     
    CampaignID       NVARCHAR(50)  NULL,
    SourceMedium     NVARCHAR(100) NULL,
    AffiliatePartner NVARCHAR(100) NULL
);

IF OBJECT_ID ('bronze.CustomerDim' , 'U') IS NOT NULL
    DROP TABLE bronze.CustomerDim;

CREATE TABLE bronze.CustomerDim (
    CustomerID       INT           NOT NULL PRIMARY KEY,
    CustomerName     NVARCHAR(100) NULL,
    Gender           VARCHAR(10)   NULL,     
    Age              INT           NULL,
    Segment          VARCHAR(20)   NULL,      
    City             NVARCHAR(100) NULL,
    State            NVARCHAR(100) NULL,
    Country          NVARCHAR(100) NULL,
    ZipCode          NVARCHAR(20)  NULL,
    AcquisitionChannel NVARCHAR(50) NULL,
    LoyaltyTier      NVARCHAR(50)  NULL,
    CLV              DECIMAL(12,2) NULL,

);

IF OBJECT_ID ('bronze.EmployeeDim' , 'U') IS NOT NULL
    DROP TABLE bronze.EmployeeDim;
CREATE TABLE bronze.EmployeeDim (
    EmployeeID     INT            NOT NULL PRIMARY KEY,
    EmployeeName   NVARCHAR(100)  NULL,
    [Role]         NVARCHAR(50)   NULL,
    Department     NVARCHAR(50)   NULL,
    SalesRegion    NVARCHAR(100)  NULL,
    CommissionRate DECIMAL(5,2)   NULL
);

IF OBJECT_ID ('bronze.InventoryFact' , 'U') IS NOT NULL
    DROP TABLE bronze.InventoryFact;
CREATE TABLE bronze.InventoryFact (
    InventoryFactID BIGINT        NOT NULL PRIMARY KEY,
    DateID          INT           NULL,
    ProductID       INT           NULL,
    WarehouseID     INT           NULL,
    SupplierID      INT           NULL,
    StockLevel      INT           NULL,
    ReorderPoint    INT           NULL,
    DaysOnHand      INT           NULL
);

IF OBJECT_ID ('bronze.LocationDim' , 'U') IS NOT NULL
    DROP TABLE bronze.LocationDim;
CREATE TABLE bronze.LocationDim (
    LocationID    INT            NOT NULL PRIMARY KEY,
    City          NVARCHAR(100)  NULL,
    State         NVARCHAR(100)  NULL,
    Country       NVARCHAR(100)  NULL,
    ZipCode       NVARCHAR(20)   NULL,
    MarketSegment VARCHAR(20)    NULL
);

IF OBJECT_ID ('bronze.MarketingFact' , 'U') IS NOT NULL
    DROP TABLE bronze.MarketingFact;
CREATE TABLE bronze.MarketingFact (
    MarketingFactID BIGINT        NOT NULL PRIMARY KEY,
    DateID          INT           NULL,
    ChannelID       INT           NULL,
    CampaignID      NVARCHAR(50)  NULL,
    AdSpend         DECIMAL(12,2) NULL,
    Impressions     BIGINT        NULL,
    Clicks          BIGINT        NULL,
    Conversions     BIGINT        NULL,
    ROI             DECIMAL(8,2)  NULL
);

IF OBJECT_ID ('bronze.ProductDim' , 'U') IS NOT NULL
    DROP TABLE bronze.ProductDim;
CREATE TABLE bronze.ProductDim (
    ProductID      INT            NOT NULL PRIMARY KEY,
    SKU            NVARCHAR(50)   NULL UNIQUE,
    PartNumber     NVARCHAR(50)   NULL,
    ProductName    NVARCHAR(200)  NULL,
    Brand          NVARCHAR(100)  NULL,
    Category       NVARCHAR(100)  NULL,
    SubCategory    NVARCHAR(100)  NULL,
    Compatibility  NVARCHAR(MAX)  NULL, 
    Price          DECIMAL(10,2)  NULL,
    Cost           DECIMAL(10,2)  NULL,
    WarrantyPeriod NVARCHAR(50)   NULL
);

IF OBJECT_ID ('bronze.ReturnReasonDim' , 'U') IS NOT NULL
    DROP TABLE bronze.ReturnReasonDim;
CREATE TABLE bronze.ReturnReasonDim (
    ReasonID        INT            NOT NULL PRIMARY KEY,
    ReasonName      NVARCHAR(100)  NULL
);

IF OBJECT_ID ('bronze.ReturnsFact' , 'U') IS NOT NULL
    DROP TABLE bronze.ReturnsFact;
CREATE TABLE bronze.ReturnsFact (
    ReturnsFactID BIGINT         NOT NULL PRIMARY KEY,
    DateID        INT            NULL,
    CustomerID    INT            NULL,
    ProductID     INT            NULL,
    ChannelID     INT            NULL,
    ReasonID      INT            NULL,
    ReturnQty     INT            NULL,
    ReturnAmount  DECIMAL(12,2)  NULL
);

IF OBJECT_ID ('bronze.SalesFact' , 'U') IS NOT NULL
    DROP TABLE bronze.SalesFact;
CREATE TABLE bronze.SalesFact (
    SalesFactID   BIGINT         NOT NULL PRIMARY KEY,
    DateID        INT            NULL,
    CustomerID    INT            NULL,
    ProductID     INT            NULL,
    ChannelID     INT            NULL,
    EmployeeID    INT            NULL,
    LocationID    INT            NULL,
    SupplierID    INT            NULL,
    Quantity      INT            NULL,
    SalesAmount   DECIMAL(12,2)  NULL,
    Discount      DECIMAL(12,2)  NULL,
    ProfitMargin  DECIMAL(12,2)  NULL

);

IF OBJECT_ID ('bronze.ShipmentFact' , 'U') IS NOT NULL
    DROP TABLE bronze.ShipmentFact;
CREATE TABLE bronze.ShipmentFact (
    ShipmentFactID    BIGINT        NOT NULL PRIMARY KEY,
    DateID            INT           NULL,
    CustomerID        INT           NULL,
    ProductID         INT           NULL,
    WarehouseID       INT           NULL,
    CarrierID         INT           NULL,
    LocationID        INT           NULL,
    ShippingCost      DECIMAL(12,2) NULL,
    DeliveryTimeDays  INT           NULL,

);

IF OBJECT_ID ('bronze.SupplierDim' , 'U') IS NOT NULL
    DROP TABLE bronze.SupplierDim;
CREATE TABLE bronze.SupplierDim (
    SupplierID       INT            NOT NULL PRIMARY KEY,
    SupplierName     NVARCHAR(150)  NULL,
    ContactInfo      NVARCHAR(200)  NULL,
    CountryOfOrigin  NVARCHAR(100)  NULL,
    LeadTimeDays     INT            NULL,
    ReliabilityScore DECIMAL(5,2)   NULL,
    PaymentTerms     NVARCHAR(50)   NULL
);

IF OBJECT_ID ('bronze.TimeDim' , 'U') IS NOT NULL
    DROP TABLE bronze.TimeDim;
CREATE TABLE bronze.TimeDim (
    DateID       INT          NOT NULL PRIMARY KEY,
    FullDate     VARCHAR(25),
);

IF OBJECT_ID ('bronze.WarehouseDim' , 'U') IS NOT NULL
    DROP TABLE bronze.WarehouseDim;
CREATE TABLE bronze.WarehouseDim (
    WarehouseID   INT            NOT NULL PRIMARY KEY,
    WarehouseName NVARCHAR(120)  NULL,
    City          NVARCHAR(100)  NULL,
    State         NVARCHAR(100)  NULL,
    Country       NVARCHAR(100)  NULL,
    ZipCode       NVARCHAR(20)   NULL
);

