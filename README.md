# ☕🫘 Bean sales in Saudi Arabia - Comprehensive Coffee Analytics 

![Analytics Pipeline](https://img.shields.io/badge/Flow-EDA→Advanced→PowerBI-blueviolet)
![Data Scope](https://img.shields.io/badge/Years-2023%E2%80%932024-yellowgreen)
![License](https://img.shields.io/badge/License-Dual%20(MIT%20+%20SQL)-lightgrey)

```mermaid
flowchart LR
    A[ 🔍 EDA Foundation] --> B[🔬 Advanced SQL]
    B --> C[📊 Power BI]
    C --> D{{"Executive Dashboards"}}
    style A fill:#5C4033,stroke:#333,stroke-width:2px,color:white  
    style B fill:#A0522D,stroke:#333,stroke-width:2px,color:white  
    style C fill:#D2B48C,stroke:#333,stroke-width:2px,color:black  
    style D fill:#F5DEB3,stroke:#333,stroke-width:2px,color:black  
```

## 🌟 Overview
An end-to-end analytics solution combining exploratory data analysis, advanced time-series modeling, and interactive dashboards for Saudi coffee sales (Jan 2023-Dec 2024).

---


## 🔍 Analytical Components

### 1. Exploratory Analysis 

#### 📊 Sales Metrics
- **Total Sales**: 700,745 SAR (before discounts)
- **Discount Impact**: 71,097 SAR in discounts applied (10.1% of sales)
- **Average Order**: 26.1 units per transaction
- **Product Prices**: Ranging from 30 SAR (Brazilian) to 45 SAR (Ethiopian)

#### 🏆 Top Performers
- **Best-Selling Product**: Colombian coffee (144,776 SAR revenue)
- **Top City**: Hail (77,257 SAR revenue, 87 orders)
- **Highest-Spending Customer**: Customer ID 2 (14,334 SAR)

#### 📍 Geographic Distribution
- **Most Customers**: Hail (60 customers)
- **Least Customers**: Tabuk (45 customers)

---

### 2. Advanced Analysis
#### 🕰️ Temporal Trends
- **Annual Comparison**:
  - 2023 Sales: 313,149 SAR (9,498 units)
  - 2024 Sales: 316,499 SAR (9,541 units) - 1.1% growth
- **Monthly Patterns**:
  - Peak sales in March 2023 (32,211 SAR)
  - Lowest sales in December 2023 (23,566 SAR)

#### 📈 Cumulative Performance
- **Running Totals**:
  - 2023 year-end cumulative sales: 313,149 SAR
  - 2024 year-end cumulative sales: 316,499 SAR
- **Monthly Averages**:
  - Consistent ~26,000-27,000 SAR monthly average

#### 🏷️ Market Segmentation
##### Product Segmentation:
| Price Range | Product Count |
|-------------|---------------|
| 30-40 SAR   | 4             |
| 40-45 SAR   | 1             |

##### City Segmentation:
| Segment          | Cities                          |
|------------------|---------------------------------|
| Very High Demand | Hail, Jeddah                   |
| High Demand      | Riyadh, Mecca, Medina, Dammam  |
| Regular Demand   | Khobar, Buraidah, Abha         |
| Low Demand       | Tabuk                          |

#### 🧩 Contribution Analysis
##### Product Contribution:
| Product     | Revenue   | % of Total |
|-------------|-----------|------------|
| Colombian   | 144,776   | 22.99%     |
| Costa Rica  | 141,078   | 22.41%     |
| Ethiopian   | 134,154   | 21.31%     |

##### City Contribution:
| City    | Revenue   | % of Total |
|---------|-----------|------------|
| Hail    | 77,257    | 12.27%     |
| Jeddah  | 72,048    | 11.44%     |
| Riyadh  | 68,421    | 10.87%     |

--- 
### 3. Screenshoot From Final Report

![image](https://github.com/user-attachments/assets/b4947021-e8bd-4eb1-bacd-ced2e3af44df)

![image](https://github.com/user-attachments/assets/d8eb58de-6672-41da-baa5-2b69d24fcd65)


## 🖥️ Dashboard Components

### 1. Global Filters

![image](https://github.com/user-attachments/assets/b4a7dd4d-d33d-466c-913a-1ec6b66079cc)


- **Data Scope**: 
  - `All` - Complete dataset
  - `City` - City-specific analysis
  - `Date` - Date-specific analysis
- **Product Selection**: Toggle between 5 coffee types:
  - Brazilian | Colombian | Costa Rica | Ethiopian | Guatemala

### 2. Key Metrics Overview

![image](https://github.com/user-attachments/assets/e5a4798e-47be-4932-bf61-e4a8133939a3)


| Metric | Description |
|--------|-------------|
| Total Quantity Sold | Aggregate units purchased |
| Total Customers | Unique customer count |
| Total City | Unique city count|
| Total revenue| Aggregate sales|
| Total Product| Unique product count|

### 3. Core Visualizations

#### A. Temporal Analysis

![image](https://github.com/user-attachments/assets/f9bd6728-815c-4832-a788-501b812a28bd)


- **Time Period**: Jan 2023 - Oct 2024 (monthly granularity)
- **Metric**: Sales revenue (20K SAR increments)
- **Features**:
  - Small-period sales comparison
  - Year-over-year trend lines

#### B. Product Performance
![image](https://github.com/user-attachments/assets/a90c46ed-ddc5-4ef3-aa1a-39a28f12cbbf)
![image](https://github.com/user-attachments/assets/71d19888-4995-4564-b775-f7f5e91c5f9b)

#### C. Product Perfromance by City 
![image](https://github.com/user-attachments/assets/ba5c647e-0c83-40b6-b7bb-6f047bb0642a)
![image](https://github.com/user-attachments/assets/16bdc210-ace9-474f-bae0-0c5e4e3c3ab0)

### 📸 Dashborad Full Sreenshot
![image](https://github.com/user-attachments/assets/d90443be-b7fe-46b0-87f4-86d1030f0ce7)

### 🎥 Dashboard brief Video



https://github.com/user-attachments/assets/cf45afe1-1fea-4a6c-8da8-ece442d4d3dd



## 🎯Key Conclusions & Recommendations
### 1. Product Strategy
  ✅ Premium focus: Promote Ethiopian coffee (highest price at 45 SAR).
  
  ✅ Bundle deals: Pair Colombian & Costa Rica (top sellers).
  
  ⚠️ Reposition Brazilian coffee: Lowest revenue despite mid-tier pricing.

### 2. Geographic Expansion
  📈 Double down on Hail & Jeddah (high growth, high demand).
  
  🔄 Turnaround plan for Tabuk: Investigate low sales , Test localized promotions.
  

### 3. Seasonal Adjustments
  📅 Boost Q1 sales (post-holiday slump).
  
  ☀️ Summer loyalty program (peak demand period).

---

## ℹ️ [Dataset Reference ](https://www.kaggle.com/datasets/halaturkialotaibi/coffee-bean-sales-dataset)

