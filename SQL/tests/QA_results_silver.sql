/*
===============================================================================
Quality Checks
===============================================================================
Purpose:
    Run the necessary scripts to performs quality checks to validate the integrity,
    consistency, and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.dim_production'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 

-- DIMENSIONS
    -- production_id          
    -- date
    -- product_type      
    -- machine_id           
    -- shift                   		
    -- operator_count          	


-- ====================================================================
-- Checking 'gold.fact_production'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions

-- PRODUCED UNITS RELATED FACTS
    -- production_id           	   
    -- units_produced          
    -- rework_hours                
    -- production_volume_cubic_meters	

-- AMBIENT RELATED FACTS
    -- average_temperature_C   
    -- average_humidity_percent    

-- DEFECTS RELATED FACTS
    -- quality_checks_failed  
    -- defects               
    -- scrap_rate   

-- COST RELATED FACTS
    -- production_time_hours       	
    -- material_cost_per_unit       
    -- labour_cost_per_our           
    -- energy_consumption_kwh  	
    -- maintenance_hours           
    -- down_time_hours             



