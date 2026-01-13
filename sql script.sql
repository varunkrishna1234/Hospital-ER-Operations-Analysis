CREATE DATABASE hospital_analytics_db;

#At what time of day do our patients suffer the longest wait times? We need to schedule more doctors then

SELECT 
    hour_of_day,
    COUNT(visit_id) AS total_patients,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY hour_of_day
ORDER BY avg_wait_time DESC;


#Are we treating critical patients (Level 1) fast enough? Our target is < 10 minutes.

SELECT 
    triage_level,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time,
    -- Calculate % of patients waiting too long (Compliance)
    ROUND(SUM(CASE WHEN wait_time_minutes > 10 AND triage_level = 1 THEN 1 ELSE 0 END) 
          / COUNT(*) * 100, 1) AS pct_breaching_target
FROM er_visits
GROUP BY triage_level
ORDER BY triage_level;

#Who waits longer: People arriving by Ambulance or Walk-ins? Do we have a handover delay?

SELECT 
    admission_source,
    COUNT(*) AS patient_volume,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY admission_source
ORDER BY avg_wait_time DESC;


#How many patients are waiting more than 2 hours? This is a major dissatisfaction risk.

SELECT 
    COUNT(*) AS total_patients,
    SUM(CASE WHEN wait_time_minutes > 120 THEN 1 ELSE 0 END) AS extreme_wait_count,
    ROUND(SUM(CASE WHEN wait_time_minutes > 120 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS pct_extreme_wait
FROM er_visits;

#Does adding more staff actually reduce wait times? Show me the correlation.

SELECT 
    staff_on_duty,
    COUNT(visit_id) AS samples,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY staff_on_duty
HAVING samples > 50 -- Ignore outliers with few samples
ORDER BY staff_on_duty;


#Which shift handles patients fastest: Morning (6-14), Afternoon (14-22), or Night (22-6)?

SELECT 
    CASE 
        WHEN hour_of_day BETWEEN 6 AND 13 THEN 'Morning Shift'
        WHEN hour_of_day BETWEEN 14 AND 21 THEN 'Afternoon Shift'
        ELSE 'Night Shift'
    END AS work_shift,
    COUNT(*) AS volume,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY 1 -- Group by the first column (the CASE statement)
ORDER BY avg_wait_time DESC;


#Are we seeing more elderly patients? They usually require more time and resources.

SELECT 
    CASE 
        WHEN patient_age < 18 THEN 'Pediatric (0-17)'
        WHEN patient_age BETWEEN 18 AND 65 THEN 'Adult (18-65)'
        ELSE 'Senior (65+)'
    END AS age_group,
    COUNT(*) AS patient_count,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY age_group
ORDER BY patient_count DESC;


#What is the financial mix of our patients? (Private vs Medicare vs Uninsured)

SELECT 
    insurance_type,
    COUNT(*) AS visits,
    -- Calculate percentage share of total visits
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM er_visits), 1) AS market_share_pct
FROM er_visits
GROUP BY insurance_type;


#We need to approve vacation requests. Which day of the week is absolutely critical to be fully staffed?

SELECT 
    day_of_week,
    COUNT(*) AS total_visits,
    ROUND(AVG(wait_time_minutes), 1) AS avg_wait_time
FROM er_visits
GROUP BY day_of_week
ORDER BY total_visits DESC;

#Is the ER getting busier over time? Show me the monthly trend.


SELECT 
    DATE_FORMAT(visit_timestamp, '%Y-%m') AS month_year,
    COUNT(visit_id) AS monthly_visits,
    -- Compare to previous month (Growth)
    COUNT(visit_id) - LAG(COUNT(visit_id)) OVER (ORDER BY DATE_FORMAT(visit_timestamp, '%Y-%m')) AS growth_vs_last_month
FROM er_visits
GROUP BY DATE_FORMAT(visit_timestamp, '%Y-%m');


#Pulse Check


SELECT 
    COUNT(*) as total_patients,
    AVG(wait_time_minutes) as avg_wait_time,
    MAX(wait_time_minutes) as worst_case_wait
FROM er_visits;


select * from er_visits;