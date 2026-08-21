# Google Merchandise Store — Product & Growth Analytics

Product and growth analytics project using GA4 ecommerce data, BigQuery, Python and BI.

## Project Objective

Analyze user behavior across the ecommerce journey to identify conversion friction, evaluate product and acquisition performance, and uncover potential growth opportunities.

## Dataset

Google Analytics 4 public ecommerce sample dataset available in BigQuery.

Dataset coverage:

- 4,295,584 events
- 270,154 pseudonymous users
- 92 days of activity
- November 2020 to January 2021

> `user_pseudo_id` represents a pseudonymous browser/app-instance identifier and should not be interpreted as a confirmed individual customer across devices.

## Technologies Used

- **Languages:** SQL, Python
- **Data Platform:** BigQuery
- **Analysis:** pandas
- **Visualization:** Google Looker
- **Version Control:** Git, GitHub

## Analysis Completed

- Dataset and event audit
- User-level funnel exploration
- Device segmentation
- Acquisition source and medium analysis
- Sequential session funnel
- Product performance analysis
- Acquisition quality analysis

## In Progress

- Python and pandas analysis
- Statistical validation
- Data visualization
- Dashboard
- Final business recommendations

## Preliminary Findings

### Conversion Funnel

The analysis identified substantial drop-off across the ecommerce journey.

A sequential session-level funnel was created to improve the interpretation of the user journey by requiring funnel events to occur in sequence within the same session.

Sequential session funnel:

- View → Cart conversion: approximately **16.73%**
- Cart → Checkout conversion: approximately **34.31%**
- Checkout → Purchase conversion: approximately **52.33%**

The largest observed drop-off occurred before users progressed from product views to cart activity.

### Device Performance

Mobile and desktop showed relatively similar conversion performance.

This suggests that device type does not appear to be a major driver of the observed conversion differences.

### Acquisition Performance

Referral traffic showed stronger purchase conversion than CPC and organic traffic in the initial acquisition analysis.

Organic traffic generated substantially more user volume, while referral users showed stronger conversion efficiency.

Further validation revealed that users could be associated with more than one acquisition medium, so the attribution methodology was revised before drawing final conclusions.

### Product Performance

Among products with at least 1,000 unique viewers:

- Median View-to-Purchase conversion was approximately **1.00%**.
- Median revenue per viewer was approximately **0.16**.
- **Google Campus Bike** substantially outperformed the benchmark, with a **4.83% View-to-Purchase conversion** and approximately **2.19 revenue per viewer**.
- **Google Tonal Tee Spearmint** received more than 1,100 unique viewers but converted only **0.18%** of viewers into buyers.
- **Candy Cane Android Cardboard Sculpture** received 2,275 unique viewers but generated only one buyer, indicating very weak monetization of product interest.
- **Google Tracking Hat** recorded substantial product views but no add-to-cart or purchase activity and was flagged as an anomaly requiring further validation.

The analysis showed that products with similar levels of traffic can generate very different business outcomes.

### Acquisition Quality

A validation check found **41,164 users associated with more than one acquisition medium** in the raw event data.

To create mutually exclusive acquisition groups, each user was assigned to their **first observed medium within the available 92-day sample**, and purchase behavior and revenue were then calculated at user level.

After correcting the attribution methodology:

- **Referral** showed the strongest performance among identifiable channels, with approximately **1.86% purchase rate** and **1.55 revenue per user**.
- **Organic** generated the largest user volume and total revenue but lower revenue per user than referral.
- **CPC** achieved approximately **1.53% purchase rate** and **1.28 revenue per user**, performing much closer to organic than suggested by the initial analysis.

This demonstrated that acquisition attribution methodology materially affected the interpretation of channel performance.

## Methodological Notes

- Acquisition analysis uses the user's **first observed medium within the 92-day sample**, which should not be interpreted as the user's confirmed historical first acquisition channel.
- `traffic_source.medium` is used as an acquisition attribute rather than a session-level source for individual purchases.
- Product identifiers were not consistent across all ecommerce event types. Product-level funnel metrics were therefore matched using `item_name` rather than `item_id`.
- The sequential funnel uses first observed event timestamps within each session and should be interpreted as an analytical approximation of the purchase journey.
- The dataset is an obfuscated GA4 sample, so findings should be interpreted within the limitations of the available data.

## Repository Structure


sql/
├── 01_data_audit.sql
├── 02_funnel_exploration.sql
├── 03_sequential_session_funnel.sql
├── 04_product_performance.sql
└── 05_acquisition_quality.sql

python/
└── analysis.ipynb          # In progress

README.md
