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
    Production ID           		NVARCHAR(50),
    Date                    		DATE,
    Product Type            		NVARCHAR(50),
    Machine ID              		NVARCHAR(50),
    Shift                   		NVARCHAR(50),
    Units Produced          		FLOAT,
    Defects                 		FLOAT,
    Production Time Hours       	FLOAT,
    Material Cost Per Unit         	FLOAT,
    Labour Cost Per Hour           	FLOAT,
    Energy Consumption kWh  		FLOAT,
    Operator Count          		FLOAT,
    Maintenance Hours           	FLOAT,
    Down time Hours             	FLOAT,
    Production Volume Cubic Meters	FLOAT,
    Scrap Rate              		FLOAT,
    Rework Hours                	FLOAT,
    Quality Checks Failed   		FLOAT,
    Average Temperature C   		FLOAT,
    Average Humidity Percent    	FLOAT
);
GO
