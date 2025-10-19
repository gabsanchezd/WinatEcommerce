 **Repository Structure**
| Folder               | Contents                                                 |
| -------------------- | ---------------------------------------------------------|
| datasets             | contains data of gold, silver, and bronze layer          |
| docs                 | contains catalog for dimension and fact tables           | 
| scripts              | contains DDL scripts for bronze, silver, and gold layer  | 
| Visualization        | contains exported charts and dashboard images            | 

 **MyTruckPoint Analytics**

 End-to-end analytics for **mytruckpoint.ca** (Canada; e-commerce + physical store) using a star schema, SQL views, and a Power BI dashboard.  
- **ETL (Bronze/Silver)**: load CSVs, trim blanks, standardize dates/currency (CAD), enforce keys.
- **Data Quality**: fix/null-normalize 2–5%, dedupe by surrogate keys, brand/subcategory inference from ProductName, sign corrections on returns.
- **Dimensional Modeling (Gold)**: star schemas for Sales, Returns, Shipment, Inventory, Marketing
- **KPI SQL Views**: exec & cross-star views (GMV, Net Revenue, Gross Profit/GM%, AOV, Units, Return Rates, ROAS/CPA/CVR, Shipping KPIs, GMROI/Turnover).
- **Power BI**: role-based pages (Executive, Sales & Pricing, Returns & Fitment, Marketing Efficiency, Channel & Store, Delivery & Inventory Health) with DAX measures & slicers.
- **Governance**: recommendations(30/60/90 days), forecasting, data dictionary, assumptions/caveats, drift-normalized views for mix-adjusted trend reading.


## Table of Contents
- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
  - [Sales and Pricing](#sales-and-pricing)
  - [Returns & Fitment](#returns--fitment)
  - [Marketing Efficiency](#marketing-efficiency)
  - [Channel & Store](#channel--store)
  - [Delivery & Inventory Health](#delivery--inventory-health)
- [Recommendations](#recommendations)
- [Forecast (90 days)](#forecast-90-days)
- [Data Model (Star Schema)](#data-model-star-schema)  
- [Assumptions and Caveats](#assumptions-and-caveats)

---

## Project Background
MyTruckPoint is a Canada-based truck and SUV accessories retailer with a hybrid model: a national e-commerce site (mytruckpoint.ca) and a physical store offering assisted sales and professional installation. Profitability is constrained by high return rates (driven by fitment/installation issues), margin erosion from heavy discounting and a shift toward lower-take marketplace channels, inefficient marketing spend (uneven ROAS/CVR), and delivery costs and timelines that depress conversion. As a result, net revenue is not scaling with ad spend, and gross margin remains below target despite steady traffic. This project delivers a unified analytics layer and role-based dashboards that turn raw sales, returns, marketing, shipment, and inventory data into clear actions—tightening pricing and mix, reducing avoidable returns, reallocating media to high-ROAS channels, and improving delivery and inventory health to drive profitable growth.

---

## Executive Summary
MyTruckPoint is a Canada-based auto accessories retailer (mytruckpoint.ca) with a physical store and installation services. Leadership sees healthy top-line potential but inconsistent profitability across all departments. The team commissioned a data project to create a unified view of performance, diagnose profit leaks, and guide 30/60/90-day interventions.

![Executive Summary](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Executive_Summary.png?raw=true "Executive Summary title")
![Executive Summary2](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Executive_Summary2.png?raw=true "Executive Summary2 title")

**Current state (Jan 2023 – Dec 2024)**
- GMV: $53.23M; Net Revenue: $46.01M (↓ 0.3pp vs 2023).
- Gross Profit: $9.06M; GM%: 19.85% (↓ 1.3pp vs 2023).
- AOV: $1.28k (flat YoY), indicating discounts did not materially lift basket size.
- Discount Rate: 13.59% of GMV.
- Ad Spend: $74.93k (↓ 3.5pp vs 2023).
- Conversion Rate: 4.76% (↓ 2.8pp vs 2023) | Desktop CVR: 3.4% vs Mobile CVR: 1.3% (gap suggests mobile UX and fitment friction)..
- Return Rate (Qty): 10.26k of units; fitment categories (tonneau, liners, racks) at 10–12% vs 5–6% elsewhere.
- Return Amt: $4.25M (↑ 2.4pp vs 2023), despite the decrease in return qty, the return amount is increasing.
- Avg. CPA: $247.05 (↑ 5.3pp vs 2023), an increase in CPA indicates the competition for the top keywords in ads.
- Avg Ship Cost% Sales: 1.45% (↑ 2.3pp vs 2023), freight cost increases for huge products.
- Top reasons: Wrong fit/compatibility (~41% of return $), changed mind (~23%), damage (~12%).
- Desktop CVR: 3.3% vs Mobile CVR: 1.2% (gap suggests mobile UX and fitment friction).


### Sales and Pricing
![Pricing and Mixing](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Pricing%20and%20Mixing.png?raw=true "Pricing and Mixing title")
- The sales–pricing story shows healthy demand but margin strain tied to promo depth and mix. On the left, Net Revenue is volatile month-to-month while GM% hovers ~18–22% and dips during several revenue spikes—classic sign that we’re “buying” volume with margin or higher discounts.
- The middle scatter (GM% vs Discount Rate, colored by channel) clusters between 12–16% discount and 18–24% GM%, with a mild negative slope: higher discount months tend to sit on the lower end of GM%. Points colored In-Store generally sit a bit higher on GM% than Marketplace/MobileApp, hinting that guided or non-fee channels realize price better.
- The channel mix by month shifts visibly—months with larger Marketplace/MobileApp bands align with GM% softness, whereas stronger Web/In-Store share coincides with firmer margins.


### Returns & Fitment
![Returns&Fitment](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Returns%26Fitment.png?raw=true "Returns&Fitment title")
- The returns picture is getting slightly worse in dollars while flat in units: $4.35M (852 units) in 2023 → $4.46M (852 units) in 2024. By category, Suspension and Towing are the clearest risers (both value and qty up), Lighting ticks up modestly, Exterior is roughly flat, and Performance improves (value and qty down). 
- The subcategory view shows where to focus: Running Boards, LED Lighting, Tonneau Covers, Cold-Air Intakes, Trailer Hitches, Exhaust, Lift Kits, and Floor Mats drive the bulk of return dollars—many are fitment-sensitive or install-dependent. 
- Treemap return reasons spreads across Changed Mind / Better Price Found (expectation/price confidence), Damage / Missing Parts / Late Delivery (ops/packaging/logistics), and Wrong Item / Ordered by Mistake / Not as Described (PDP clarity/selection). Taken together, the pattern says we’re not just dealing with one problem: fitment & selection clarity, fulfillment quality, and price reassurance all matter.


### Marketing Efficiency
![Marketing Efficiency](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Marketing%20Efficiency.png?raw=true "Marketing Efficiency title")
- Performance is uneven across Channel×CVR cells, meaning we can improve results without raising budget.
- The marketing funnel looks healthy at the top—about 15M impressions driving ~1M clicks (CTR ≈ 6.7%)—but the post-click stage still has headroom, with conversions landing near ~0.2% of impressions (≈3% CVR from click to purchase).
- Spend mix is mismatched to outcomes: the donut shows the largest budget on MobileApp (~33%) while channels showing stronger conversion (notably Marketplace, then In-Store) get far less. Meanwhile, ROAS is volatile month-to-month while conversions are comparatively steady, which usually points to targeting, promo depth, and channel mix shifts rather than demand changes.


### Channel & Store
![Channel and Store](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Channel%20and%20Store.png?raw=true "Channel and Store title")
- In the waterfall, the biggest positive and negative steps across years are tied to Web/MobileApp—so mix shifts inside those two channels largely explain the portfolio swings.
- The stacked area confirms Web is the largest revenue layer, MobileApp the second, with modest contributions from In-Store and a thin Marketplace band; there’s mild seasonality with a soft patch late in the year. On the risk side, the Return $ by channel bar chart shows Web and MobileApp account for the majority of return dollars, In-Store somewhat lower, and Marketplace the least. That pattern is consistent with fitment/expectation issues online and better guided selection in store.
- The channel story shows that most of the year-over-year movement in Net Revenue is coming from Web and MobileApp, while In-Store is comparatively steady and Marketplace is small but stable.


### Delivery & Inventory Health
![Delivery & Inventory Health](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Delivery%20and%20Inventory%20Health.png?raw=true "Delivery & Inventory Health title")
- Delivery and inventory point to cost-to-serve pressure in heavy/fitment categories and uneven capital productivity. On shipping, Towing and Suspension show the highest ship cost per unit, which is consistent with oversized/weight-based surcharges; Interior/Lighting sit mid-pack and Exterior/Performance lower.
- Inventory signals are mixed: Avg DOH hovers ~44–46 days with spikes (e.g., Feb, Aug, Nov/Dec), implying seasonal buys ran ahead of demand in some months—slow turns that tie up cash and raise clearance risk.
- The GMROI vs Inventory Value plot shows Towing (and parts of Interior) carrying the most inventory value with the weakest GMROI—cash trapped in slow movers—while Performance earns the best GMROI at moderate inventory, and Exterior is acceptable but not great.


## Recommendations

  ### 0–30 days: Quick wins
  - Cap promo depth by BrandTier × Category; replace site-wide %-off with bundle offers on top sellers.
  - Ship “Will this fit?” widget on high-return subs (Running Boards, Tonneau, Lift Kits, Hitches). Add “what’s in the box” and install notes.
  - Reallocate 20–30% budget from low-ROAS Channel×Month cells (cold heatmap) to warm cells (incl. Marketplace cohorts with strong CVR).
  - Promote Install/BOPIS badges on fitment PDPs; geo-target store radius.
  - Towing/Suspension shipping policy tweak by raising free-ship thresholds for oversize; enable dimensional-weight rules.

  ### 31–60 days: Scale what works, Fix structural frictions
  - Small list-price lifts on premium brands (channels with higher GM%); keep bundles for value tiers.
  - Compatibility normalization (structured Year/Make/Model/Trim) for top 50 SKUs in the worst subs; enforce vehicle selection before add-to-cart.
  - Fitment-centric LPs for Search/Social; enable vehicle memory and speed fixes on mobile; add Apple/Google Pay + guest-first.
  - Do a Marketplace feed enrichment by adding full compatibility attributes and price floors that include fees.
  - Lane/Carrier micro-routing: move the worst SLA lanes (from matrix) to better carriers; reinforce packing for long/heavy boxes.

  ### 61–90 days: Institutionalize gains, Push contributions
  - Promo governance playbook (guardrails, approval matrix, reporting) + automated “drift-normalized GM%” view to separate mix from price effects.
  - Scale fitment program to all fitment subs; add verified-fit UGC; start return policy clarity pilots on marketplace (shorter windows/restock for opened fitment items where compliant).
  - Do a budget rebalancer (monthly) by pruning bottom quartile, reinvest in top quartile; creative rotation is a must to avoid frequency fatigue.
  - Implement an assisted selling program by scripted Point of Sale (POS) upsells (liners, seals), BOPIS install scheduling; marketplace limited to value lines.

## Forecast (90 days)
- Net Revenue: +$14% → $4.33M (from $3.80M baseline)
- Gross Margin %: +1.4 pp → 21.2% (from 19.8%)
- Gross Profit: ~$0.92M (=$4.33M × 21.2%; up from ~$0.75M)
- AOV: +$5% → $1345 (from $1280)
- CVR: +1.0 pp → 5.7% (from 4.7%)
- Return Rate (Value): –2.0 pp → 7.0% (from 9.0%)
- ROAS (NetRev/Spend): ~3.60 (from 3.17) assuming $7.70k monthly ad spend


## Data Model (Star Schema)

### **Dimension Table** and **Fact Table**

![MyTruckPoint_Schema_Diagram](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/MyTruckPoint_Schema_Diagram.png?raw=true "MyTruckPoint_Schema_Diagram title")


### **Gold Star Layer**
You can view here the [catalog](https://github.com/gabsanchezd/WinatEcommerce/blob/main/docs/datacatalog.md) for **'gold star'** schema layer. The **'gold star'** layer is the business-level data representation, structured to support analytical and reporting use cases.

![Star_Schema_Diagram](https://github.com/gabsanchezd/WinatEcommerce/blob/main/visualizations/Star_Schema_Diagram.png?raw=true "Star_Schema_Diagram title")
- Sales star (FullDate, Year, Month, SalesChannel, Category, NetRevenue, Discount, GrossProfit, Units, GMV, GM%, DiscountRate, ASP, AOV, Active Customers)
- Returns star (FullDate, Year, Month, SalesChannel, Category, ReturnAmt, ReturnQty, ReturnRate_Value, ReturnRate_Qty)
- Inventory star (FullDate, Year, Month, Category, AvgStock, AvgDOH, StockoutRate, AvgUnitCost, AvgInventoryValue, InventoryTurnover, GMROI)
- Shipment star( FullDate, Year, Month, Category, ShipCost, AvgDeliveryDays, ShipCostPerUnit, ShipCostPerOrder, ShipCostPerSales)
- Marketing star (Year, Month, SalesChannel, AdSpend, Impressions, Clicks, Conversions, CTR, CVR, CPC, CPM, CPA, ROAS)


## Tech Stack

| Layer                        | Tools and Libraries                         |
| ---------------------------- | --------------------------------------------|
| Data Extraction              | Google Ads & GA4 / Shopify / SAP / Meta     |
| Cleaning                     | MySQL / Python (Panda, Numpy)               | 
| Visualization                | PowerBI                                     | 


## Assumptions and Caveats

### Nulls & Inference
- Minimal nulls preserved. Target was 2–5% NULL to reflect real data; critical reporting fields were imputed only when needed for joins or KPIs.
- Text trims & blanks. Empty strings → NULL post-trim.
- Brand inference from ProductName. If Brand was NULL, we used case/regex rules (e.g., “weathertech”, “husky”, “bak/bakflip”, “truxedo”, “k&n”, etc.).
- SubCategory inference from ProductName + Category. Used a conservative CASE WHEN mapping (e.g., names containing “tonneau” → SubCategory = Tonneau Covers) only when Category context matched.
- WarrantyPeriod normalization. Free text mapped to buckets: Limited Lifetime, 5-Year, 3-Year, 2-Year, 1-Year; anything else left as-is to avoid overfitting.
- Compatibility parsing. Free-text fitment (“Ford F150 2015–2022”) normalized into Year/Make/Model where unambiguous; ambiguous strings left intact and flagged.

### Outliers & Anomalies
- Negative ReturnAmount/ReturnQty converted to absolute values with a flag, to standardize KPIs.
- Extreme prices/discounts. Outliers beyond P99/P1 reviewed: if obviously erroneous (e.g., Price < Cost/10, Discount > GMV), winsorized or quarantined.
- Shipping costs. Very high per-unit costs in oversize categories retained (they’re real drivers) but labeled so they don’t skew unrelated SKUs.

### Data Drift & Seasonality
- Mix-adjusted margin. Where we reported “drift-normalized” GM%, we re-weighted channel shares to a baseline month to separate pricing effects from mix.
- Peaks around holidays were not “de-seasonalized”; recommendations considered that promo depth usually rises in peaks (confound with margin).




