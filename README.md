# Checkout Funnel Drop-Off & Repeated Checkout Failure Analysis

## Project Overview
E-commerce checkout abandonment is often analyzed only through high-level funnel drop-off rates.  
This approach hides **high-intent users** who repeatedly attempt checkout but fail to complete a purchase.

This project goes beyond basic funnel analysis to:
- Identify **persistent checkout friction**
- Isolate users with **repeated checkout failures**
- Quantify the **business impact** of this friction using a conservative revenue estimate

---

## Business Problem
An e-commerce platform observed a significant drop-off during checkout but lacked clarity on:
- Where the funnel breaks most severely
- Whether drop-offs represent low intent or persistent friction
- The potential revenue impact of unresolved checkout issues

The goal was to convert raw user interaction data into **actionable insights** that help prioritize checkout improvements.

---

## Dataset
- **Source:** Google Analytics 4 (GA4) Obfuscated E-commerce Sample Dataset  
- **Type:** Event-level user interaction data  
- **Platform:** BigQuery  

Each row represents a user event such as product views, cart actions, checkout initiation, or purchase.

---

## Tools & Technologies
- **SQL (BigQuery):** Funnel construction, aggregation, segmentation  
- **Python (Pandas):** Metric validation, conservative estimation, BI-ready summaries  
- **Power BI:** Stakeholder-facing dashboards and insights  

---

## Methodology

### 1. Funnel Definition
A clean checkout funnel was defined using the following events:
1. View Item  
2. Add to Cart  
3. Begin Checkout  
4. Purchase  

A **rate-based funnel** was used to identify step-wise friction.

---

### 2. Repeated Checkout Failure Identification
To isolate high-intent friction, a new segment was defined:

**Repeated Checkout Failure User**
- `begin_checkout_count ≥ 3`
- `purchase_count = 0`

This filters out one-time abandonment and focuses on persistent checkout issues.

---

### 3. Segmentation & Normalization
Checkout-intent users were segmented by:
- Device category (Desktop, Mobile, Tablet)

Failure **rates** (not just counts) were used to normalize risk across devices.

---

### 4. Revenue at Risk Estimation
Since failed users generate no revenue, a **conservative estimation approach** was used:
- Average purchase value calculated from successful checkout users
- Multiplied by the number of repeated checkout failure users

This provides a realistic estimate of **recoverable revenue**, not overstated loss.

---

## Key Insights
- ~18% of checkout-intent users repeatedly attempt checkout without purchasing
- The largest funnel drop-off occurs **after checkout initiation**
- Desktop users show the **highest repeated checkout failure rate**
- Repeated checkout failures represent approximately **143k in recoverable revenue**

---

## Dashboard Summary (Power BI)
The Power BI dashboard is structured into three focused views:

1. **Checkout Funnel Overview**  
   Identifies where the funnel breaks

2. **Repeated Checkout Failures**  
   Isolates high-intent users and compares failure rates across devices

3. **Revenue at Risk**  
   Quantifies the financial impact and highlights prioritization areas

---

## Assumptions & Limitations
- Checkout attempts are used as a proxy for purchase intent
- Revenue-at-risk is an estimate, not actual lost revenue
- GA4 data may contain tracking gaps (e.g., purchases without checkout events)

---

## Outcome
This project demonstrates how moving beyond surface-level funnel metrics can uncover **high-impact friction points**, enabling data-driven prioritization of checkout improvements with clear business justification.

---

## 📂 Repository Structure
