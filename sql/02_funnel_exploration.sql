-- 1. Exploratory user-level funnel
-- Grain: one row per pseudonymous user

WITH user_funnel AS (
    SELECT
        user_pseudo_id,

        MAX(CASE WHEN event_name = 'view_item'
                 THEN 1 ELSE 0 END) AS viewed,

        MAX(CASE WHEN event_name = 'add_to_cart'
                 THEN 1 ELSE 0 END) AS added_to_cart,

        MAX(CASE WHEN event_name = 'begin_checkout'
                 THEN 1 ELSE 0 END) AS checkout_started,

        MAX(CASE WHEN event_name = 'purchase'
                 THEN 1 ELSE 0 END) AS purchased

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE user_pseudo_id IS NOT NULL
    GROUP BY user_pseudo_id
)
SELECT
    SUM(viewed) AS users_viewed,
    SUM(added_to_cart) AS users_added_to_cart,
    SUM(checkout_started) AS users_checkout,
    SUM(purchased) AS users_purchased,

    SAFE_DIVIDE(SUM(added_to_cart), SUM(viewed)) * 100
        AS view_to_cart_conversion,

    SAFE_DIVIDE(SUM(checkout_started), SUM(added_to_cart)) * 100
        AS cart_to_checkout_conversion,

    SAFE_DIVIDE(SUM(purchased), SUM(checkout_started)) * 100
        AS checkout_to_purchase_conversion

FROM user_funnel;

- 2. Funnel segmentation by device
-- Grain: one row per user + device

WITH user_funnel AS (
   SELECT
       user_pseudo_id,
       device.category AS device,
       max(
        case
            when event_name = 'view_item' then 1
            else 0
            end 
    ) AS viewed,
      max(
        case
            when event_name = 'add_to_cart' then 1
            else 0
            end 
    ) AS added_to_cart
      max(
        case
            when event_name = 'begin_checkout' then 1
            else 0
            end 
       )AS started_checkout,
      max(
        case
            when event_name = 'purchase' then 1
            else 0
            end 
    ) AS purchased
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    GROUP BY user_pseudo_id,
             device
)  


-- Create user-level funnel flags
   SELECT
      device,
      SUM(added_to_cart) as users_added_to_cart,
      SUM(viewed) as users_viewed,
      SUM(started_checkout) as users_started_checkout,
      SUM(purchased) as users_purchased,
      SAFE_DIVIDE(
      SUM(added_to_cart),
      SUM(viewed)) * 100 AS view_to_cart_conversion,
      SAFE_DIVIDE(
      SUM(started_checkout),
      SUM(added_to_cart)) * 100 AS cart_to_checkout_conversion,
      SAFE_DIVIDE(
      SUM(purchased),
      SUM(started_checkout)) * 100 as purchased_conversion
     FROM user_funnel
     GROUP BY device
     ORDER BY users_viewed DESC;

-- 3. Funnel segmentation by acquisition source and medium

WITH user_acquisition_funnel AS (
    SELECT
        user_pseudo_id,
        traffic_source.source AS acquisition_source,
        traffic_source.medium AS acquisition_medium,

        MAX(CASE WHEN event_name = 'view_item'
                 THEN 1 ELSE 0 END) AS viewed,

        MAX(CASE WHEN event_name = 'add_to_cart'
                 THEN 1 ELSE 0 END) AS added_to_cart,

        MAX(CASE WHEN event_name = 'begin_checkout'
                 THEN 1 ELSE 0 END) AS started_checkout,

        MAX(CASE WHEN event_name = 'purchase'
                 THEN 1 ELSE 0 END) AS purchased

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    WHERE user_pseudo_id IS NOT NULL
    GROUP BY
        user_pseudo_id,
        traffic_source.source,
        traffic_source.medium
)
  
SELECT
    acquisition_source,
    acquisition_medium,
    SUM(viewed) AS users_viewed,
    SUM(added_to_cart) AS users_added_to_cart,
    SUM(started_checkout) AS users_checkout,
    SUM(purchased) AS users_purchased,

    SAFE_DIVIDE(SUM(added_to_cart), SUM(viewed)) * 100
        AS view_to_cart_conversion,

    SAFE_DIVIDE(SUM(started_checkout), SUM(added_to_cart)) * 100
        AS cart_to_checkout_conversion,

    SAFE_DIVIDE(SUM(purchased), SUM(started_checkout)) * 100
        AS checkout_to_purchase_conversion

FROM user_acquisition_funnel
GROUP BY
    acquisition_source,
    acquisition_medium
ORDER BY users_viewed DESC;

     
