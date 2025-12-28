/* =========================================================
   CHECKOUT FUNNEL & REPEATED CHECKOUT FAILURE ANALYSIS
   Dataset: GA4 Obfuscated E-commerce Sample (BigQuery)
   ========================================================= */


/* ---------------------------------------------------------
   1. USER-LEVEL BEHAVIOR SUMMARY (BACKBONE TABLE)
   ---------------------------------------------------------
   Aggregates event-level GA4 data into user-level metrics
   used across funnel, segmentation, and revenue analysis
---------------------------------------------------------- */

CREATE OR REPLACE TABLE `green-jet-480504-h8.funnel_analysis.user_behavior_summary` AS
SELECT
  user_pseudo_id,
  device.category AS device_category,
  COUNTIF(event_name = 'view_item') AS view_item_count,
  COUNTIF(event_name = 'add_to_cart') AS add_to_cart_count,
  COUNTIF(event_name = 'begin_checkout') AS begin_checkout_count,
  COUNTIF(event_name = 'purchase') AS purchase_count,
  SUM(ecommerce.purchase_revenue) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id, device_category;



/* ---------------------------------------------------------
   2. FUNNEL BASE USERS
   ---------------------------------------------------------
   Defines the valid funnel entry point:
   users who viewed at least one product
---------------------------------------------------------- */

CREATE OR REPLACE TABLE `green-jet-480504-h8.funnel_analysis.funnel_base_users` AS
SELECT *
FROM `green-jet-480504-h8.funnel_analysis.user_behavior_summary`
WHERE view_item_count >= 1;



/* ---------------------------------------------------------
   3. FUNNEL STEP METRICS (RATE-BASED FUNNEL)
   ---------------------------------------------------------
   Calculates step-wise user counts and conversion rates
---------------------------------------------------------- */

CREATE OR REPLACE TABLE `green-jet-480504-h8.funnel_analysis.funnel_step_metrics` AS
SELECT
  1 AS step_order,
  'Viewed Item' AS step,
  COUNT(*) AS users,
  1.0 AS conversion_rate
FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`

UNION ALL

SELECT
  2 AS step_order,
  'Add to Cart' AS step,
  COUNT(*) AS users,
  COUNT(*) * 1.0 / (
    SELECT COUNT(*)
    FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
  ) AS conversion_rate
FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
WHERE add_to_cart_count >= 1

UNION ALL

SELECT
  3 AS step_order,
  'Begin Checkout' AS step,
  COUNT(*) AS users,
  COUNT(*) * 1.0 / (
    SELECT COUNT(*)
    FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
    WHERE add_to_cart_count >= 1
  ) AS conversion_rate
FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
WHERE begin_checkout_count >= 1

UNION ALL

SELECT
  4 AS step_order,
  'Purchase' AS step,
  COUNT(*) AS users,
  COUNT(*) * 1.0 / (
    SELECT COUNT(*)
    FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
    WHERE begin_checkout_count >= 1
  ) AS conversion_rate
FROM `green-jet-480504-h8.funnel_analysis.funnel_base_users`
WHERE purchase_count >= 1;



/* ---------------------------------------------------------
   4. CHECKOUT USER SEGMENTATION
   ---------------------------------------------------------
   Identifies repeated checkout failures among
   checkout-intent users
---------------------------------------------------------- */

CREATE OR REPLACE TABLE `green-jet-480504-h8.funnel_analysis.checkout_user_segments` AS
SELECT
  user_pseudo_id,
  device_category,
  begin_checkout_count,
  purchase_count,
  COALESCE(total_revenue, 0) AS total_revenue,
  CASE
    WHEN begin_checkout_count >= 3 AND purchase_count = 0
      THEN 'Repeated Checkout Failure'
    ELSE 'Other Checkout Users'
  END AS checkout_segment
FROM `green-jet-480504-h8.funnel_analysis.user_behavior_summary`
WHERE begin_checkout_count >= 1;
