# Data Dictionary for 'gold' Layer


## Overview
 The 'gold' layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension** tables and **fact** tables for specific business metrics.

### 1. gold.sales_star
- Purpose: Rollup of commerce performance by channel and category.
- Answers to: How much we sold (GMV/Net Revenue), at what price (ASP/AOV), and how profitable (Gross Profit/GM%).
- Columns:
  
| Column          | Data Type     | Description                                             |
| --------------- | ------------- | ------------------------------------------------------- |
| FullDate        | DATE          | Full date includes (Day/Month/Year) format.             |
| Year            | INT           | Calendar year of the month.                             |
| Month           | INT           | Calendar month name (e.g. Jan, Feb, etc.)               |
| SalesChannel    | VARCHAR(50)   | Web, MobileApp, Marketplace, InStore, etc.              |
| Category        | VARCHAR(100)  | Product category (e.g., Tonneau Covers, Floor Mats).    |
| NetRevenue      | DECIMAL(12,2) | Revenue after discounts.                                |
| Discount        | DECIMAL(12,2) | Total discount amount applied.                          |
| GrossProfit     | DECIMAL(12,2) | Profit after product cost (not including shipping/ads). |
| Units           | INT           | Total units sold.                                       |
| GMV             | DECIMAL(12,2) | Gross merchandise value = NetRevenue + Discount.        |
| GM_Pct          | DECIMAL(6,4)  | Gross profit margin = GrossProfit / NetRevenue.         |
| DiscountRate    | DECIMAL(6,4)  | Discount$ / GMV.                                        |
| ASP             | DECIMAL(12,2) | Avg. selling price = NetRevenue / Units.                |
| AOV             | DECIMAL(12,2) | Avg. order value = NetRevenue / OrdersProxy.            |
| ActiveCustomers | INT           | Distinct customers purchasing in the month.             |


### 2. gold.returns_star
- Purpose: Returns aligned to the same sales slices (channel × category) for like-for-like rates.
- Answers to: How much value/qty came back and where (Return Rate Value/Qty), which areas are problematic.
- Columns:

| Column           | SQL Type      | Description                                        |
| ---------------- | ------------- | -------------------------------------------------- |
| FullDate         | DATE          | Full date includes (Day/Month/Year) format.        |
| Year             | INT           | Calendar year.                                     |
| Month            | INT           | Calendar month name (e.g. Jan, Feb, etc.)          |
| SalesChannel     | VARCHAR(50)   | Sales channel for the returned orders.             |
| Category         | VARCHAR(100)  | Product category of returned items.                |
| ReturnAmt        | DECIMAL(12,2) | Dollar value of returns.                           |
| ReturnQty        | INT           | Quantity of items returned.                        |
| ReturnRate_Value | DECIMAL(6,4)  | ReturnAmt / NetRevenue (from matched sales table). |
| ReturnRate_Qty   | DECIMAL(6,4)  | ReturnQty / Units (from matched sales table).      |


### 3. gold.marketing_star
- Purpose: Funnel metrics by channel with efficiency ratios tied back to sales (ROAS).
- Answers to: Are we buying efficient traffic? (Impressions → Clicks → Conversions; CPC/CPA/CPM; ROAS).
- Columns:

| Column         | SQL Type      | Description                                             |
| -------------- | ------------- | ------------------------------------------------------- |
| Year           | INT           | Calendar year.                                          |
| Month          | INT           | Calendar month name (e.g. Jan, Feb, etc.)               |
| SalesChannel   | VARCHAR(50)   | Channel associated with spend (Web/Mobile/etc.).        |
| AdSpend        | DECIMAL(12,2) | Marketing spend in the month.                           |
| Impressions    | BIGINT        | Ad impressions.                                         |
| Clicks         | BIGINT        | Ad clicks.                                              |
| Conversions    | BIGINT        | Conversions attributed to the channel.                  |
| CTR            | DECIMAL(6,4)  | Click-through rate = Clicks / Impressions.              |
| CVR            | DECIMAL(6,4)  | Conversion rate = Conversions / Clicks.                 |
| CPC            | DECIMAL(12,4) | Cost per click = AdSpend / Clicks.                      |
| CPM            | DECIMAL(12,4) | Cost per 1k impressions = 1000 × AdSpend / Impressions. |
| CPA            | DECIMAL(12,4) | Cost per acquisition = AdSpend / Conversions.           |
| ROAS           | DECIMAL(12,4) | Return on ad spend = NetRevenue / AdSpend (from Sales). |


### 4. gold.shipment_star
- Purpose: Fulfillment KPIs by product category (all channels combined) with sales denominators.
- Answers to: Delivery performance ( Avg Delivery Days) and cost-to-serve (Ship Cost / Unit/Order, Ship Cost % Sales).
- Columns:

| Column           | SQL Type      | Description                                 |
| ---------------- | ------------- | ------------------------------------------- |
| FullDate         | DATE          | Full date includes (Day/Month/Year) format. |
| Year             | INT           | Calendar year.                              |
| Month            | INT           | Calendar month name (e.g. Jan, Feb, etc.)   |
| Category         | VARCHAR(100)  | Product category shipped.                   |
| ShipCost         | DECIMAL(12,2) | Total shipping cost incurred.               |
| AvgDeliveryDays  | DECIMAL(6,2)  | Average delivery time in days.              |
| ShipCostPerUnit  | DECIMAL(12,4) | ShipCost / Units (from sales table).        |
| ShipCostPerOrder | DECIMAL(12,4) | ShipCost / OrdersProxy (from sales table)   |
| ShipCostPctSales | DECIMAL(6,4)  | ShipCost / NetRevenue (from sales table )   |


### 5. gold.inventory_star
- Purpose: Inventory health by category with productivity proxies.
- Answers to: Do we have the right stock? (Avg Stock, Avg DOH, Stockout Rate) and how productive is it (GMROI).
- Columns:

| Column             | SQL Type      | Description                              |
| ------------------ | ------------- | ------------------------------------------ |
| FullDate           | DATE          | Full date includes (Day/Month/Year) format.|
| Year               | INT           | Calendar year.                             |
| Month              | INT           | Calendar month number (1–12).              |
| Category           | VARCHAR(100)  | Product category.                          |
| AvgStock           | DECIMAL(18,4) | Avg stock level (units).                   |
| AvgDOH             | DECIMAL(18,4) | Avg days on hand (inventory).              |
| StockoutRate       | DECIMAL(6,4)  | % of days StockLevel ≤ 0.                  |
| AvgUnitCost        | DECIMAL(12,4) | Average unit cost (from ProductDim).       |
| AvgInventoryValue$ | DECIMAL(18,4) | AvgStock × AvgUnitCost.                    |
| InventoryTurnover  | DECIMAL(12,4) | Proxy turnover (COGS/AvgInventoryValue).   |
| GMROI              | DECIMAL(12,4) | Gross profit return on inventory.          |


