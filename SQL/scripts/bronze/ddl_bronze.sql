/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' tables.
===============================================================================
*/

IF OBJECT_ID('bronze.manufacturing_data', 'U') IS NOT NULL
    DROP TABLE bronze.manufacturing_data;
GO

CREATE TABLE bronze.manufacturing_data (
    production_id           NVARCHAR(50),
    date                    DATE,
    product_type            NVARCHAR(50),
    machine_id              NVARCHAR(50),
    shift                   NVARCHAR(50),
    units_produced          FLOAT,
    defects                 FLOAT,
    production_time_h       FLOAT,
    material_cost_u         FLOAT,
    labour_cost_h           FLOAT,
    energy_consumption_kWh  FLOAT,
    operator_count          FLOAT,
    maintenance_h           FLOAT,
    down_time_h             FLOAT,
    production_vol          FLOAT,
    scrap_rate              FLOAT,
    rework_h                FLOAT,
    quality_checks_failed_u FLOAT,
    average_temperature_c   FLOAT,
    average_humidity_pct    FLOAT
);
GO
