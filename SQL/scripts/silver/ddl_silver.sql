/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('silver.manufacturing_data', 'U') IS NOT NULL
    DROP TABLE silver.manufacturing_data;
GO

CREATE TABLE silver.manufacturing_data (
    production_id           		    INT,
    date                    		    DATE,
    product_type            		    NVARCHAR(50),
    machine_id              		    INT,
    shift                   		    NVARCHAR(50),
    units_produced          		    INT,
    defects                 		    INT,
    production_time_hours       	  FLOAT,
    material_cost_per_unit         	FLOAT,
    labour_cost_per_our           	FLOAT,
    energy_consumption_kwh  		    FLOAT,
    operator_count          		    INT,
    maintenance_hours           	  FLOAT,
    down_time_hours             	  FLOAT,
    production_volume_cubic_meters	FLOAT,
    scrap_rate              		    FLOAT,
    rework_hours                	  FLOAT,
    quality_checks_failed   		    INT,
    average_temperature_C   		    FLOAT,
    average_humidity_percent    	  FLOAT
);
GO
