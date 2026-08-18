-- 1. Dataset size and coverage

SELECT
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_pseudo_id) AS total_users,
    COUNT(DISTINCT event_date) AS total_days
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

-- 2. Event distribution
SELECT
    event_name,
    count(*) as total_events,
    count(distinct(user_pseudo_id)) as  total_users
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
Group by event_name
Order by total_events DESC
Limit 20;

-- 3. Dataset date range

SELECT
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS start_date,
    MAX(PARSE_DATE('%Y%m%d', event_date)) AS end_date
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;
