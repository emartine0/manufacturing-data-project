/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME; 
    BEGIN TRY
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		-- Loading silver.manufacturing_data
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.manufacturing_data';
		TRUNCATE TABLE silver.manufacturing_data;
		PRINT '>> Inserting Data Into: silver.manufacturing_data';
		INSERT INTO silver.manufacturing_data (
			production_id,
			date,
			product_type,
			machine_id,
			shift,
			units_produced,
			defects,
			production_time_hours,
			material_cost_per_unit,
			labour_cost_per_our,
			energy_consumption_kwh,
			operator_count,
			maintenance_hours,
			down_time_hours,
			production_volume_cubic_meters,
			scrap_rate,
			rework_hours,
			quality_checks_failed,
			average_temperature_C,
			average_humidity_percent
		)
		SELECT 
		   CASE 
			WHEN CAST(REPLACE(ProductionID, '-', '') AS INT) = 2998 THEN 19080316
			WHEN CAST(REPLACE(ProductionID, '-', '') AS INT) = 2999 THEN 19080317
			WHEN CAST(REPLACE(ProductionID, '-', '') AS INT) = 3000 THEN 19080318
			ELSE CAST(REPLACE(ProductionID, '-', '') AS INT)
		   END AS production_id,
		   DATEADD(year, -2, Date) AS date,
		   ProductType,
		   MachineID,
		   Shift,
		   UnitsProduced,
		   Defects,
		   ProductionTimeHours,
		   MaterialCostPerUnit,
		   LabourCostPerHour,
		   EnergyConsumptionkWh,
		   OperatorCount,
		   MaintenanceHours,
		   DowntimeHours,
		   ProductionVolumeCubicMeters,
		   ScrapRate,
		   ReworkHours,
		   QualityChecksFailed,
		   AverageTemperatureC,
		   AverageHumidityPercent
		FROM bronze.manufacturing_data
		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
