/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and separetes data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension Table: gold.dim_production
-- =============================================================================
IF OBJECT_ID('gold.dim_production', 'V') IS NOT NULL
    DROP VIEW gold.dim_production;
GO

CREATE VIEW gold.dim_production AS
SELECT
    production_id,
    date                AS production_date,
    shift               AS production_shift,
    operator_count,
    product_type,
    machine_id
FROM silver.manufacturing_data;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_production
-- =============================================================================
IF OBJECT_ID('gold.fact_production', 'V') IS NOT NULL
    DROP VIEW gold.fact_production;
GO

CREATE VIEW gold.fact_production AS
SELECT
    production_id,
    date                                AS production_date,
    units_produced                      AS total_units_produced,
    production_volume_cubic_meters,
    rework_hours                        AS total_rework_hours,
    average_temperature_C               AS average_temperature_celsius,
    average_humidity_percent            AS average_relative_humidity_percent,
    quality_checks_failed,
    defects                             AS total_defective_units,
    scrap_rate                          AS scrap_rate_precent,
    production_time_hours,
    material_cost_per_unit,
    labour_cost_per_hour,
    energy_consumption_kwh,
    maintenance_hours,
    down_time_hours
FROM silver.manufacturing_data;
GO
