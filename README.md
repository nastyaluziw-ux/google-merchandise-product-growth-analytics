Product and growth analytics project using GA4 ecommerce data, BigQuery, Python and BI.
# Google Merchandise Store — Product & Growth Analytics

## Project Objective

Analyze user behavior across the ecommerce journey to identify
conversion friction and potential growth opportunities.

## Dataset

Google Analytics 4 public ecommerce sample dataset available in BigQuery.

Dataset coverage:
- 4,295,584 events
- 270,154 pseudonymous users
- 92 days of activity
- November 2020 to January 2021

## Technologies Used

- **Languages:** SQL, Python
- **Data Platform:** BigQuery
- **Analysis:** pandas
- **Visualization:** Google Looker
- **Version Control:** Git, GitHub

## Analysis Progress

Completed:
- Dataset and event audit
- User-level funnel exploration
- Device segmentation
- Acquisition source and medium analysis
- Sequential session funnel

In progress:
- Product performance analysis
- Acquisition quality analysis
- Statistical validation
- Python analysis
- Dashboard and business recommendations

## Preliminary Findings

### Product Performance

Among products with at least 1,000 unique viewers:

- Median View-to-Purchase conversion was approximately **1.00%**.
- Median revenue per viewer was approximately **0.16**.
- **Google Campus Bike** substantially outperformed the benchmark, with a **4.83% View-to-Purchase conversion** and approximately **2.19 revenue per viewer**.
- **Google Tonal Tee Spearmint** received more than 1,100 unique viewers but converted only **0.18%** of viewers into buyers.
- **Candy Cane Android Cardboard Sculpture** received 2,275 unique viewers but generated only one buyer, indicating very weak monetization of product interest.
- **Google Tracking Hat** recorded substantial product views but no add-to-cart or purchase activity and should be treated as a data/product anomaly requiring further validation.

### Data Quality Note

Product identifiers were not consistent across all ecommerce event types. Product-level funnel metrics were therefore matched using `item_name` rather than `item_id`.

## Repository Structure

```text
sql/
├── 01_data_audit.sql
├── 02_funnel_exploration.sql
└── 03_sequential_session_funnel.sql
