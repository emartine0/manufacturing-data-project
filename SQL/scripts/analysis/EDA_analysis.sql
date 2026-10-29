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

SELECT DISTINCT 
	production_date,
	production_shift
FROM gold.dim_production
ORDER BY 1,2 ASC

/* OBSERVATION: Just one production shift produce all the items during the day */

SELECT DISTINCT 
	production_date,
	machine_id
FROM gold.dim_production
ORDER BY 1,2 ASC

/* OBSERVATION: Just one machine works per day/shift */

SELECT DISTINCT 
	production_shift,
	product_type
FROM gold.dim_production
ORDER BY 1,2 ASC

/* OBSERVATION: It can be produced different product types for each production shift */

SELECT DISTINCT
	machine_id,
	operator_count
FROM gold.dim_production
ORDER BY 1, 2 ASC

/* OBSERVATION: A machine can be operated by up to 4 operators in a shift/day */

SELECT DISTINCT
	machine_id,
	product_type
FROM gold.dim_production
ORDER BY 1, 2 ASC

/* OBSERVATION: machine_id from 1 to 4 produce automotive products,
machine_id from 5 to 8 produce only textil products,
machine_id from 9 to 12 produce only appliance products,
machine_id 13 to 16 produce only electronic products and
machine_id from 17 to 20 produce only furniture prodcuts */

--########################################################
--################### DATE EXPLORATION ###################
--########################################################

SELECT
	MIN(production_date) AS oldest_record,
	MAX(production_date) AS newest_record,
	DATEDIFF(year, MIN(production_date), MAX(production_date)) AS records_years
FROM gold.fact_production

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


-- Grand total of produced units

SELECT
	SUM(total_units_produced) AS grand_total_production 
FROM gold.fact_production

-- Grand total of defective units

SELECT
	SUM(total_defective_units) AS grand_total_defective_units 
FROM gold.fact_production

-- Grand total of production hours

SELECT
	SUM(production_time_hours) AS grand_total_production_time 
FROM gold.fact_production

-- Grand total of maintenance hours

SELECT
	SUM(maintenance_hours) AS grand_tota_maintenance_hours
FROM gold.fact_production

-- Grand total of downtime hours

SELECT
	SUM(down_time_hours) AS grand_tota_downtime_hours
FROM gold.fact_production

-------------------------------------------------------------
----- Generate a report that shows all the key metrics ------
-------------------------------------------------------------

SELECT 'Grand Total Produced Units' AS Quantity_Name, SUM(total_units_produced) AS Quantity_Value FROM gold.fact_production
UNION ALL
SELECT 'Grand Total Defective Units', SUM(total_defective_units) FROM gold.fact_production
UNION ALL
SELECT 'Grand Total Production Hours', ROUND(SUM(production_time_hours),2) FROM gold.fact_production
UNION ALL
SELECT 'Grand Total Downtime Hours', ROUND(SUM(down_time_hours),2) FROM gold.fact_production
UNION ALL
SELECT 'Grand Total Maintenance Hours', ROUND(SUM(maintenance_hours),2) FROM gold.fact_production


--############################################################
--################### MAGNITUD ANALYSIS ######################
--############################################################

-- Calculate the total production hours for the total production each year

SELECT
	YEAR(production_date) AS year,
	ROUND(SUM(production_time_hours),2) AS total_production_hours,
	SUM(total_units_produced) AS total_production_units
FROM gold.fact_production
GROUP BY YEAR(production_date)
ORDER BY YEAR(production_date)

-- Calculate production units by shift, through the years

SELECT
	YEAR(dprod.production_date) AS year,
	production_shift,
	SUM(total_units_produced) AS total_produced_units_per_shift
FROM gold.dim_production dprod
LEFT JOIN gold.fact_production fprod
ON dprod.production_id = fprod.production_id
GROUP BY YEAR(dprod.production_date), production_shift
ORDER BY YEAR(dprod.production_date), production_shift

-- Calculate defective units by machine, through the years

SELECT
	YEAR(dprod.production_date) AS year,
	machine_id,
	SUM(total_defective_units) AS total_defective_units_per_machine
FROM gold.dim_production dprod
LEFT JOIN gold.fact_production fprod
ON dprod.production_id = fprod.production_id
GROUP BY YEAR(dprod.production_date), machine_id
ORDER BY YEAR(dprod.production_date), machine_id

-- Calculate maintenance hours by machine, through the years

SELECT
	YEAR(dprod.production_date) AS year,
	machine_id,
	SUM(maintenance_hours) AS total_maintenance_hours_per_machine
FROM gold.dim_production dprod
LEFT JOIN gold.fact_production fprod
ON dprod.production_id = fprod.production_id
GROUP BY YEAR(dprod.production_date), machine_id
ORDER BY YEAR(dprod.production_date), machine_id

-- Calculate downtime hours by month, through the years

SELECT
	YEAR(dprod.production_date) AS year,
	MONTH(dprod.production_date) AS month,
	SUM(down_time_hours) AS total_downtime_hours
FROM gold.dim_production dprod
LEFT JOIN gold.fact_production fprod
ON dprod.production_id = fprod.production_id
GROUP BY YEAR(dprod.production_date), MONTH(dprod.production_date)
ORDER BY YEAR(dprod.production_date), MONTH(dprod.production_date)

--################################################################
--------------- RANKING ANALYSIS: TOP N - BOTTOM N ---------------
--################################################################

-- Find the TOP 3 machines that produce the most

SELECT  TOP 3
	machine_id,
	SUM(total_units_produced) AS total_production_per_year
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(total_units_produced) DESC

-- Find the TOP 3 machines that produce the least

SELECT TOP 3
	machine_id,
	SUM(total_units_produced) AS total_production_per_year
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(total_units_produced) ASC

-- Find the TOP 3 machines that accumulates more maintenance hours

SELECT TOP 3
	machine_id,
	SUM(maintenance_hours) AS total_maintenance_hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(maintenance_hours) DESC

-- Find the TOP 3 machines that that accumulates less maintenance hours

SELECT TOP 3
	machine_id,
	SUM(maintenance_hours) AS total_maintenance_hours
FROM gold.dim_production dp
LEFT JOIN gold.fact_production fp
ON dp.production_id = fp.production_id
GROUP BY machine_id
ORDER BY SUM(maintenance_hours) ASC
