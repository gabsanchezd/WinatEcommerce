# MyTruckPoint Analytics

> End-to-end analytics for **mytruckpoint.ca** (Canada; e-commerce + physical store) using a star schema, SQL views, and a Power BI dashboard.  
> This README explains the dataset, KPIs, views, and how to reproduce the analysis.

---

## Table of Contents
- [Goals](#goals)
- [Dataset](#dataset)
- [Data Model (Star Schema)](#data-model-star-schema)
- [Key KPIs](#key-kpis)
- [Data Quality & Cleaning](#data-quality--cleaning)
- [BI Views (Monthly Grain)](#bi-views-monthly-grain)
- [Power BI Dashboard](#power-bi-dashboard)
- [How to Reproduce](#how-to-reproduce)
- [Repository Structure](#repository-structure)
- [License](#license)

---

## Goals
- Build a **repeatable analytics stack** for Sales, Returns, Marketing, Inventory, and Shipment.
- Deliver **role-based dashboards** (Executive, Manager, Operations).
- Provide **clean KPI definitions** at a **monthly** grain with consistent date fields for BI.

---

## Dataset
Synthetic but realistic Canadian e-commerce + store data for truck parts/accessories, aligned to **mytruckpoint.ca**.

**Files (CSV)**
- **Dimensions:** `CustomerDim.csv`, `ProductDim.csv`, `TimeDim.csv`, `ChannelDim.csv`, `EmployeeDim.csv`, `LocationDim.csv`, `SupplierDim.csv`, `WarehouseDim.csv`, `CarrierDim.csv`, `ReturnReasonDim.csv`
- **Facts:** `SalesFact.csv`, `ReturnsFact.csv`, `InventoryFact.csv`, `ShipmentFact.csv`, `MarketingFact.csv`

**Notes**
- IDs start at random **3-digit** ranges (not 1).
- Intentional **nulls (2–5%)**, **duplicates**, **typos**, **outliers**, **data drift** for realism.
- Product names reflect real assortment (e.g., tonneau covers, floor liners, racks).

---

## Data Model (Star Schema)
**Facts**
- `SalesFact(DateID, CustomerID, ProductID, ChannelID, EmployeeID, LocationID, SupplierID, Quantity, SalesAmount, Discount, ProfitMargin)`
- `ReturnsFact(DateID, CustomerID, ProductID, ChannelID, ReasonID, ReturnQty, ReturnAmount)`
- `InventoryFact(DateID, ProductID, WarehouseID, SupplierID, StockLevel, ReorderPoint, DaysOnHand)`
- `ShipmentFact(DateID, CustomerID, ProductID, WarehouseID, CarrierID, LocationID, ShippingCost, DeliveryTimeDays, DelayFlag)`
- `MarketingFact(DateID, ChannelID, CampaignID, AdSpend, Impressions, Clicks, Conversions, ROI)`

**Dimensions**
- `TimeDim(DateID, FullDate, Day, Week, Month, Quarter, Year, IsHoliday, FiscalPeriod)`
- `ProductDim(ProductID, SKU, PartNumber, ProductName, Brand, Category, SubCategory, Compatibility, Price, Cost, WarrantyPeriod)`
- `ChannelDim(ChannelID, SalesChannel, CampaignID, SourceMedium, AffiliatePartner)`
- `CustomerDim`, `EmployeeDim`, `LocationDim`, `SupplierDim`, `WarehouseDim`, `CarrierDim`, `ReturnReasonDim`

> BI views expose **`MonthStartDate = DATEFROMPARTS(Year, Month, 1)`** for stable time axes in Power BI.

---

## Key KPIs
**Sales**
- **GMV** = NetRevenue + Discount  
- **GM%** = GrossProfit / NetRevenue  
- **AOV** = NetRevenue / Orders (orders proxy used)  
- **ASP** = NetRevenue / Units

**Returns**
- **Return Rate (Qty)** = ReturnQty / Units  
- **Return Rate (Value)** = ReturnAmount / NetRevenue

**Marketing**
- **ROAS** = NetRevenue / AdSpend  
- **CTR** = Clicks / Impressions  
- **CVR** = Conversions / Clicks  
- **CPC**, **CPA**, **CPM**

**Shipment**
- **On-Time Rate** = 1 − AVG(DelayFlag)  
- **Avg Delivery Days**, **Ship Cost / Unit**, **Ship Cost / Order**, **Ship Cost % Sales**

**Inventory**
- **Avg DOH**, **ROP Breach Rate**, **Stockout Rate**  
- **Inventory Turnover** (proxy), **GMROI** = GrossProfit / AvgInventoryValue

**Composite**
- **NetRevenue_AfterReturns** = NetRevenue − ReturnAmount  
- **Contribution After Shipping** (optional extension)

---

## Data Quality & Cleaning
- **Nulls:** Trim blanks to `NULL`; infer Brand/SubCategory from `ProductName` where safe.
- **Duplicates:** De-dup on PKs; standardize near-dupes.
- **Outliers:** Flag extreme `Price`, `Discount`, `ShippingCost` (winsorize for visuals if needed).
- **Drift:** Monitor channel mix drift with recent vs prior 6-month shares.

Example check (SQL):
```sql
-- Negative quantities in Returns
SELECT * FROM dbo.ReturnsFact WHERE ReturnQty < 0;

-- Null % by column (example for ProductDim.Brand)
SELECT 100.0*SUM(CASE WHEN Brand IS NULL THEN 1 ELSE 0 END)/COUNT(*) AS NullPct
FROM dbo.ProductDim;
