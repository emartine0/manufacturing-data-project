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
    ProductionID            		NVARCHAR(50),
    Date                    		DATE,
    ProductType                		NVARCHAR(50),
    MachineID                 		NVARCHAR(50),
    Shift                   		NVARCHAR(50),
    UnitsProduced             		FLOAT,
    Defects                 		FLOAT,
    ProductionTimeHours         	FLOAT,
    MaterialCostPerUnit         	FLOAT,
    LabourCostPerHour           	FLOAT,
    EnergyConsumptionkWh      		FLOAT,
    OperatorCount             		FLOAT,
    MaintenanceHours               	FLOAT,
    DowntimeHours                	FLOAT,
    ProductionVolumeCubicMeters	    FLOAT,
    ScrapRate              		    FLOAT,
    ReworkHours                	    FLOAT,
    QualityChecksFailed   		    FLOAT,
    AverageTemperatureC   		    FLOAT,
    AverageHumidityPercent    	    FLOAT
);
GO
