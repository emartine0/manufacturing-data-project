/*
=================================================================================
Production Shift-Machine Report 2018-2025
=================================================================================
Script Purpose:
    This report (VIEW) consolidates key production metrics, details and evaluations
    related to machines.

Highlights:
    1. Gathers essential fields such as shift, machine ID and production details.
    2. Aggregates production at shift-machine-level metrics.
        -- total produced units
        -- total defective units
        -- total downtime hours
        -- total maintenance hours
    3. Calculates valuable production KPI's
        -- average produced units per machine
        -- average defective units per machine
        -- average material cost per product type
        -- average labour cost per product type
    4. Segments machines into 2 categories: those which need a detailed 
       inspection and those that don't, based on if the machine were below 
       the average for the product type machine. All of the previous evaluations
       based on maintenance hours, material cost and labour cost.
=================================================================================
*/
IF OBJECT_ID('gold.report_shif_machine', 'V') IS NOT NULL
    DROP VIEW gold.report_shif_machine;
GO

CREATE VIEW gold.report_shift_machine AS 
WITH base_query AS (
---------------------------------------------------------------------------------
/*              BASE QUERY: RETRIEVES CORE COLUMNS FROM TABLES                 */
---------------------------------------------------------------------------------
SELECT
    f.production_id,
    f.production_date,
    f.total_units_produced,
    f.total_defective_units,
    f.material_cost_per_unit,
    f.labour_cost_per_hour,
    f.maintenance_hours,
    f.down_time_hours,
    d.production_shift,
    d.product_type,
    d.machine_id
FROM gold.fact_production f
LEFT JOIN gold.dim_production d
ON f.production_id = d.production_id
WHERE YEAR(f.production_date) != 2026)
, production_aggregation AS (
---------------------------------------------------------------------------------
/*         PRODUCTION AGGREGATIONS: KEY METRIC AT PRODUCTION LEVEL             */
---------------------------------------------------------------------------------
SELECT
    production_shift,
    product_type,
    machine_id,
    SUM(total_units_produced) AS total_production_units,
    SUM(total_defective_units) AS total_defective_units,
    SUM(maintenance_hours) AS total_maintenance_hours,
    SUM(down_time_hours) AS total_downtime_hours,
    SUM(material_cost_per_unit) AS total_mat_cost_unit,
    SUM(labour_cost_per_hour) AS total_labour_cost_hour
FROM base_query
GROUP BY machine_id, product_type, production_shift)
---------------------------------------------------------------------------------
/*         CATEGORIZATION OF MACHINES: MAINTENANCE, MATERIAL AND LABOUR        */
---------------------------------------------------------------------------------
SELECT
    production_shift,
    product_type,
    machine_id,
    total_production_units,
    total_defective_units,
    total_maintenance_hours,
    total_downtime_hours,
    ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY machine_id, product_type),2) AS avg_maint_machine_product,
    ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY product_type),2) AS avg_maint_product,
    CASE WHEN ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY machine_id, product_type),2) - ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY product_type),2) > 0 
         THEN 'test passed'
         WHEN ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY machine_id, product_type),2) - ROUND(AVG(total_maintenance_hours) OVER(PARTITION BY product_type),2) < 0 
         THEN 'test not passed'
         ELSE 'manageable'
    END AS machine_evaluation,
    ROUND(AVG(total_production_units) OVER(PARTITION BY machine_id, product_type),2) AS avg_produced_machine_product,
    ROUND(AVG(total_defective_units) OVER(PARTITION BY machine_id, product_type),2) AS avg_defective_machine_product,
    total_mat_cost_unit,
    ROUND(AVG(total_mat_cost_unit) OVER(PARTITION BY product_type),2) AS avg_mat_cost_product,
    CASE WHEN total_mat_cost_unit - ROUND(AVG(total_mat_cost_unit) OVER(PARTITION BY product_type),2) > 0 THEN 'test passed'
         WHEN total_mat_cost_unit - ROUND(AVG(total_mat_cost_unit) OVER(PARTITION BY product_type),2) < 0 THEN 'test not passed'
         ELSE 'manageable'
         END AS material_cost_evaluation,
    total_labour_cost_hour,
    ROUND(AVG(total_labour_cost_hour) OVER(PARTITION BY product_type),2) AS avg_labour_cost_product,
    CASE WHEN total_labour_cost_hour - ROUND(AVG(total_labour_cost_hour) OVER(PARTITION BY product_type),2) > 0 THEN 'test passed'
         WHEN total_labour_cost_hour - ROUND(AVG(total_labour_cost_hour) OVER(PARTITION BY product_type),2) < 0 THEN 'test not passed'
         ELSE 'manageable'
    END AS labour_cost_evaluation
FROM production_aggregation
