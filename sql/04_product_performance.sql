-- Product performance analysis
-- Grain: one row per product
--
-- Note:
-- item_id was not consistent across all event types,
-- so product-level metrics are grouped by item_name.
-- Only products with at least 1,000 unique viewers are included.

WITH product_metrics AS (

    SELECT
        item.item_name,

        COUNT(DISTINCT CASE
            WHEN event_name = 'view_item'
            THEN user_pseudo_id
        END) AS unique_viewers,

        COUNT(DISTINCT CASE
            WHEN event_name = 'add_to_cart'
            THEN user_pseudo_id
        END) AS unique_cart_users,

        COUNT(DISTINCT CASE
            WHEN event_name = 'purchase'
            THEN user_pseudo_id
        END) AS unique_buyers,

        SAFE_DIVIDE(
            COUNT(DISTINCT CASE
                WHEN event_name = 'add_to_cart'
                THEN user_pseudo_id
            END),
            COUNT(DISTINCT CASE
                WHEN event_name = 'view_item'
                THEN user_pseudo_id
            END)
        ) * 100 AS view_to_cart_conversion,

        SAFE_DIVIDE(
            COUNT(DISTINCT CASE
                WHEN event_name = 'purchase'
                THEN user_pseudo_id
            END),
            COUNT(DISTINCT CASE
                WHEN event_name = 'view_item'
                THEN user_pseudo_id
            END)
        ) * 100 AS view_to_purchase_conversion,

        SUM(
            CASE
                WHEN event_name = 'purchase'
                THEN COALESCE(item.item_revenue, 0)
                ELSE 0
            END
        ) AS product_revenue,

        SAFE_DIVIDE(
            SUM(
                CASE
                    WHEN event_name = 'purchase'
                    THEN COALESCE(item.item_revenue, 0)
                    ELSE 0
                END
            ),
            COUNT(DISTINCT CASE
                WHEN event_name = 'view_item'
                THEN user_pseudo_id
            END)
        ) AS revenue_per_viewer

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(items) AS item

    WHERE event_name IN ('view_item', 'add_to_cart', 'purchase')
      AND item.item_name != '(not set)'

    GROUP BY item.item_name

    HAVING COUNT(DISTINCT CASE
        WHEN event_name = 'view_item'
        THEN user_pseudo_id
    END) >= 1000
)



-- Product-level results


SELECT *
FROM product_metrics
ORDER BY view_to_purchase_conversion ASC;

SELECT
    AVG(view_to_purchase_conversion) AS avg_purchase_conversion,

    APPROX_QUANTILES(
        view_to_purchase_conversion, 100
    )[OFFSET(50)] AS median_purchase_conversion,

    AVG(revenue_per_viewer) AS avg_revenue_per_viewer,

    APPROX_QUANTILES(
        revenue_per_viewer, 100
    )[OFFSET(50)] AS median_revenue_per_viewer

FROM product_metrics;



Benchmark results for high-traffic products:

Average View-to-Purchase conversion: ~1.40%
Median View-to-Purchase conversion:  ~1.00%

Average Revenue per Viewer: ~0.352
Median Revenue per Viewer:  ~0.163
