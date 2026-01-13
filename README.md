# Hospital ER Operations Dashboard

## 1. Executive Summary
This project analyzes 10,000 patient records to identify bottlenecks in Emergency Room (ER) operations. Using **MySQL** for data storage and **Power BI** for visualization, I identified that under-staffing during "Rush Hour" (6 PM - 10 PM) causes wait times to spike by 40%.

**Business Value:**
* **Wait Time Reduction:** Visualized the correlation between staffing levels and patient wait times to recommend shift adjustments.
* **Triage Compliance:** Monitored KPI targets for "Critical" (Level 1) patients to ensure life-threatening cases are handled <10 mins.
* **Resource Allocation:** Analyzed patient arrival modes (Ambulance vs. Walk-in) to predict resource strain.

## 2. Dashboard Features
<img width="1227" height="676" alt="Screenshot 2026-01-12 094815" src="https://github.com/user-attachments/assets/551196cd-1d88-446a-b779-c6a291451e31" />

* **Interactive Filtering:** Slicers for Triage Level, Insurance Type, and Day of Week allow deep-dives into specific patient cohorts.
* **Time-Series Analysis:** Line charts identify daily "Rush Hour" peaks.
* **Demographic Binning:** SQL-based binning groups patients by Age and Gender to identify core demographics.
* **Heatmap Logic:** Visualizes the intersection of High Volume vs. High Wait Times.

## 3. Technical Implementation
* **SQL Analysis:** Utilized `CASE` statements and Window Functions (`LAG`, `Over`) to calculate rolling growth and operational lags.
* **Data Modeling:** Created a Star Schema in Power BI connecting patient logs to dimension tables.
* **Python ETL:** Scripted a realistic data generator to simulate 1 year of hospital logs, uploaded directly to MySQL via SQLAlchemy.

## 4. Key Insights
* **Rush Hour:** Wait times peak between 19:00 and 21:00.
* **Staffing Efficiency:** Every additional nurse on duty reduces average wait time by ~8 minutes.
* **Triage Efficiency:** Critical patients (Level 1) are successfully seen in under 12 minutes on average.
