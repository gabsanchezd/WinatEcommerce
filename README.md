# MyTruckPoint Analytics

> End-to-end analytics for **mytruckpoint.ca** (Canada; e-commerce + physical store) using a star schema, SQL views, and a Power BI dashboard.  
> This project covers from ETL -> 

---

## Table of Contents
- [Goals](#goals)
- [Project Background](#project-background)
- [Dataset](#dataset)
- [Data Model (Star Schema)](#data-model-star-schema)
- [Key KPIs](#key-kpis)
- [Data Quality & Cleaning](#data-quality--cleaning)
- [BI Views (Monthly Grain)](#bi-views-monthly-grain)
- [Power BI Dashboard](#power-bi-dashboard)
- [How to Reproduce](#how-to-reproduce)
- [Repository Structure](#repository-structure)
- [Goals](#goals)
- [License](#license)

---

## Project Background
MyTruckPoint is a Canada-based auto-accessories retailer operating a hybrid model: a national e-commerce site (mytruckpoint.ca) plus a physical store that offers assisted sales and installation. The catalog focuses on fitment-sensitive products (e.g., tonneau covers, floor liners, racks, towing gear), where correct vehicle compatibility and post-purchase experience (returns, shipping, installation) determine customer satisfaction and margin. This project aims to deliver a unified, decision-ready analytics layer and dashboards that translate raw sales, returns, and marketing data into clear actions for growth and profitability.

---

## Executive Summary
MyTruckPoint is a Canada-based auto accessories retailer (mytruckpoint.ca) with a physical store and installation services. Leadership sees healthy top-line potential but inconsistent profitability across all departments. The team commissioned a data project to create a unified view of performance, diagnose profit leaks, and guide 30/60/90-day interventions. 

Current state (Jan 2023 – Dec 2024)

-GMV: $24.8M; Net Revenue: $21.1M (after discounts)
-Gross Profit: $5.4M; GM%: 25.6% (↓ 1.8pp vs 2023)
-Discount Rate: 14.7% of GMV (↑ 3.9pp vs 2023), signaling promo pressure
-AOV: $187 (flat YoY), indicating discounts did not materially lift basket size
-Return Rate (Value): 8.9% of Net Revenue (↑ 1.6pp YoY)
-Return Rate (Qty): 7.4% of units; fitment categories (tonneau, liners, racks) at 10–12% vs 5–6% elsewhere
-Top reasons: Wrong fit/compatibility (~41% of return $), changed mind (~23%), damage (~12%)
-Desktop CVR: 3.3% vs Mobile CVR: 1.2% (gap suggests mobile UX and fitment friction)
-PDPs with structured Compatibility show ~20–25% lower return-qty vs PDPs with free-text notes
-Ad Spend: $74.93M

ROAS (blended): 2.1× (median), with large dispersion—bottom quartile ~0.8×, top quartile ~3.5×

CPA: $48 median; CTR: 1.7%; CVR (click→conversion): 2.2%

Channel drift: Marketplace share of Net Revenue rose from 22% (2023) to 34% (2024); Web is 54%, In-store 12%
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
