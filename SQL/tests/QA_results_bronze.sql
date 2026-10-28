/*
===============================================================================
Quality Checks
===============================================================================
Purpose:
    Run some scripts to perform various quality checks for data consistency, accuracy, 
    and standardization across the 'bronze' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run some checks after data loading Bronze Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

--###################################################################
--##################### DATABASE EXPLORATION ########################
--###################################################################

-- ProductionID column

/* the production id looks like a date --> format and cast to INT */

-- Date column

/* the dates are out of range --> change the date (-2 years) */

-- ProductType column

/* N/A */

-- MachineID column

/* cast to INT */

-- Shift column,

/* N/A */

-- UnitsProduced column,

/* cast to INT */

-- Defects column,

/* 299 nulls - cast to INT */

-- ProductionTimeHours column,

/* N/A */

-- MaterialCostPerUnit column,

/* N/A */

-- LabourCostPerHour column,

/* N/A */

-- EnergyConsumptionkWh column,

/* N/A */

-- OperatorCount column,

/* cast to INT */

-- MaintenanceHours column,

/* 300 nulls */

-- DowntimeHours column,

/* 300 nulls */

-- ProductionVolumeCubicMeters column,

/* N/A */

-- ScrapRate column,

/* N/A */

-- ReworkHours column,

/* 300 nulls */

-- QualityChecksFailed column,

/* cast to INT */

-- AverageTemperatureC column,

/* N/A */

-- AverageHumidityPercent column

/* N/A */

--------------------------------------------------------------------
