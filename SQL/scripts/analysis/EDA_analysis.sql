--########################################################
--################# DATABASE EXPLORATION #################
--########################################################

-- Explore all the obects in the database

SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all the columns in the tables

SELECT * FROM INFORMATION_SCHEMA.COLUMNS 

--#########################################################
--################# DIMENSION EXPLORATION #################
--#########################################################

    -- production_id,
    -- production_date,
    -- production_shift,
    -- operator_count,
    -- product_type,
    -- machine_id

-- Explore production-shifts, operator-counts, product-types and machines.

SELECT 'Production Shifts' AS Quantity_Name, COUNT(DISTINCT production_shift) AS Quantity_Value FROM gold.dim_production
UNION ALL
SELECT 'Max Operators per Day', MAX(operator_count) FROM gold.dim_production
UNION ALL
SELECT 'Types of Products', COUNT(DISTINCT product_type) FROM gold.dim_production
UNION ALL
SELECT 'Production Machines', COUNT(DISTINCT machine_id) FROM gold.dim_production

-- DESCRIPTIVE EXPLORATION production-shifts, operator-counts, product-types and machines.

SELECT DISTINCT production_shift FROM gold.dim_production ORDER BY production_shift
SELECT DISTINCT operator_count FROM gold.dim_production ORDER BY operator_count
SELECT DISTINCT product_type FROM gold.dim_production ORDER BY product_type
SELECT DISTINCT machine_id FROM gold.dim_production ORDER BY machine_id

-- Explore production dates

SELECT 'Oldest Record' AS Quantity_Name, CAST(MIN(production_date) AS VARCHAR) AS Quantity_Value FROM gold.dim_production
UNION ALL
SELECT 'Newest Record', CAST(MAX(production_date) AS VARCHAR) FROM gold.dim_production
UNION ALL
SELECT 'Range of Records (years)', CAST(DATEDIFF(year,MIN(production_date),MAX(production_date)) AS VARCHAR) FROM gold.dim_production
UNION ALL
SELECT 'Range of Records (months)', CAST(DATEDIFF(month,MIN(production_date),MAX(production_date)) AS VARCHAR) FROM gold.dim_production

--########################################################
--############ MEASURES EXPLORATION: BIG NUMBERS #########
--########################################################

    -- production_id,
    -- production_date,
    -- total_units_produced,
    -- production_volume_cubic_meters,
    -- total_rework_hours,

    -- average_temperature_celsius,
    -- average_relative_humidity_percent,

    -- quality_checks_failed,
    -- total_defective_units,
    -- scrap_rate_precent,

    -- production_time_hours,
    -- material_cost_per_unit,
    -- labour_cost_per_hour,
    -- energy_consumption_kwh,
    -- maintenance_hours,
    -- down_time_hours

-- Explore the total produced units, the total rework hours,
-- the total defective units, the maintenance hours and the downtime hours.

SELECT 'Produced Units' AS Grand_Totals, SUM(total_units_produced) AS Value FROM gold.fact_production
UNION ALL
SELECT 'Rework Hours', SUM(total_rework_hours) FROM gold.fact_production
UNION ALL
SELECT 'Defective Units', SUM(total_defective_units) FROM gold.fact_production
UNION ALL
SELECT 'Maintenance Hours', ROUND(SUM(maintenance_hours),2) FROM gold.fact_production
UNION ALL
SELECT 'Down-Time Hours', ROUND(SUM(down_time_hours),2) FROM gold.fact_production

-- ############################################################
-- ------------------- MAGNITUD ANALYSIS ----------------------
-- ############################################################

-- Calculate the total produced units by shift and product type

SELECT
    production_shift,
    SUM(total_units_produced) AS total_units_produced
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY production_shift

SELECT
    product_type,
    SUM(total_units_produced) AS total_units_produced
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY product_type

-- Calculate the total defective units by machine

SELECT
    machine_id,
    SUM(total_defective_units)
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(total_defective_units) DESC

-- Calculate the total maintenance hours by machine

SELECT
    machine_id,
    SUM(maintenance_hours) AS Maintenance_Hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(maintenance_hours) DESC

-- Calculate the total downtime hours by shift

SELECT
    production_shift,
    SUM(down_time_hours) AS Downtime_Hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY production_shift
ORDER BY SUM(down_time_hours) DESC

-- Calculate the average production hours by shift

SELECT
    production_shift,
    ROUND(AVG(production_time_hours),2) AS Average_Production_Time
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY production_shift
ORDER BY AVG(production_time_hours)

--################################################################
--------------- RANKING ANALYSIS: TOP N - BOTTOM N ---------------
--################################################################

-- Find the TOP 3 machines that produced the most

SELECT  TOP 3
	machine_id  AS Machine_ID,
	SUM(total_units_produced) AS Total_Production_per_Year
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(total_units_produced) DESC

-- Find the TOP 3 machines that produced the least

SELECT TOP 3
	machine_id  AS Machine_ID,
	SUM(total_units_produced) AS Total_Production_per_Year
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(total_units_produced) ASC

-- Find the TOP 3 machines that accumulates more maintenance hours

SELECT TOP 3
	machine_id AS Machine_ID,
	SUM(maintenance_hours) AS Total_Maintenance_Hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(maintenance_hours) DESC

-- Find the TOP 3 machines that that accumulates less maintenance hours

SELECT TOP 3
	machine_id AS Machine_ID,
	SUM(maintenance_hours) AS Total_Maintenance_Hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(maintenance_hours) ASC
