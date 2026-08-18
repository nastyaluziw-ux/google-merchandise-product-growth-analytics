-- Sequential session funnel
-- Grain: one row per pseudonymous user + session
--
-- Each stage is counted only when it occurs after the
-- previous funnel stage within the same session.

WITH session_events AS (
    SELECT
        user_pseudo_id,
        (
            SELECT value.int_value
            FROM UNNEST(event_params)
            WHERE key = 'ga_session_id'
        ) AS ga_session_id,

        MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END)
            AS viewed_sessions,

        MIN(CASE WHEN event_name = 'view_item'
                 THEN event_timestamp END) AS first_view_ts,

        MIN(CASE WHEN event_name = 'add_to_cart'
                 THEN event_timestamp END) AS first_added_to_cart_ts,

        MIN(CASE WHEN event_name = 'begin_checkout'
                 THEN event_timestamp END) AS first_started_checkout_ts,

        MIN(CASE WHEN event_name = 'purchase'
                 THEN event_timestamp END) AS first_purchased_ts

    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

    GROUP BY
        user_pseudo_id,
        ga_session_id
),
sequential_funnel AS (
    SELECT
        user_pseudo_id,
        ga_session_id,
        viewed_sessions,

        CASE
            WHEN first_added_to_cart_ts > first_view_ts
            THEN 1 ELSE 0
        END AS sequential_added,

        CASE
            WHEN first_added_to_cart_ts > first_view_ts
             AND first_started_checkout_ts > first_added_to_cart_ts
            THEN 1 ELSE 0
        END AS sequential_checkout,

        CASE
            WHEN first_added_to_cart_ts > first_view_ts
             AND first_started_checkout_ts > first_added_to_cart_ts
             AND first_purchased_ts > first_started_checkout_ts
            THEN 1 ELSE 0
        END AS sequential_purchase

    FROM session_events
)
SELECT
    SUM(viewed_sessions) AS view_sessions,
    SUM(sequential_added) AS cart_sessions,
    SUM(sequential_checkout) AS checkout_sessions,
    SUM(sequential_purchase) AS purchase_sessions,

    SAFE_DIVIDE(
        SUM(sequential_added),
        SUM(viewed_sessions)
    ) * 100 AS view_to_cart_conversion,

    SAFE_DIVIDE(
        SUM(sequential_checkout),
        SUM(sequential_added)
    ) * 100 AS cart_to_checkout_conversion,

    SAFE_DIVIDE(
        SUM(sequential_purchase),
        SUM(sequential_checkout)
    ) * 100 AS checkout_to_purchase_conversion

FROM sequential_funnel;
