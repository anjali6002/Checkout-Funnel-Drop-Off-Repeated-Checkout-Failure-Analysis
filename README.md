# Checkout-Funnel-Drop-Off-Repeated-Checkout-Failure-Analysis
Business Problem

E-commerce platforms often analyze checkout abandonment at an aggregate level, which hides high-intent users who repeatedly attempt checkout but fail to complete a purchase.
This project aims to identify where the checkout funnel breaks, isolate persistent checkout failures, and estimate the business impact of this friction.

Dataset

Google Analytics 4 (GA4) obfuscated e-commerce sample dataset

Event-level user interaction data

Analysis performed using BigQuery

Approach

Defined a clean checkout funnel from product view to purchase

Built a rate-based funnel to identify the highest friction point

Identified users with repeated checkout attempts (≥3) and no purchases

Segmented checkout users by device to normalize failure risk

Estimated revenue at risk using a conservative average purchase value

Key Insights

~18% of checkout-intent users repeatedly attempt checkout without purchasing

The largest drop-off occurs after checkout initiation

Desktop users show the highest repeated checkout failure rate

Repeated checkout failures represent ~143k in recoverable revenue

Tools Used

SQL (BigQuery): aggregation, funnel logic, segmentation

Python (Pandas): validation, conservative estimation, BI-ready summaries

Power BI: stakeholder-ready dashboards

Assumptions & Limitations

Checkout attempts are used as a proxy for purchase intent

Revenue-at-risk is an estimate, not actual lost revenue

GA4 data may contain tracking gaps (e.g., purchases without checkout events)

Outcome

This analysis demonstrates how moving beyond surface-level funnel metrics can uncover high-impact friction points and inform data-driven prioritization of checkout improvements.
