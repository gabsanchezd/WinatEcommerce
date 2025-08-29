/*
=========================================================================================================
Stored Procedure: Load Bronze Layer (Source ->Bronze)
=========================================================================================================
Script Purpose:
  The stored procedure loads data into the `bronze` schema layer from external CSV files.
  It performs the functions:
    -Truncates the bronze tables before loading data.
    -Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Usage Example:
  EXEC bronze.load_bronze;

========================================================================================================
*/  

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
	PRINT '=============================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '=============================================================';

	PRINT '-------------------------------------------------------------';
	PRINT 'Loading bronze.ChannelDim';
	PRINT '-------------------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>>>>Truncating Table: bronze.ChannelDim';
	TRUNCATE TABLE bronze.ChannelDim;

	PRINT '>>>>Inserting Data Into: bronze.ChannelDim';
	BULK INSERT bronze.ChannelDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\ChannelDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.CustomerDim';
	TRUNCATE TABLE bronze.CustomerDim;

	PRINT '>>>>Inserting Data Into: CustomerDim';
	BULK INSERT bronze.CustomerDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\CustomerDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.EmployeeDim';
	TRUNCATE TABLE bronze.EmployeeDim;

	PRINT '>>>>Inserting Data Into: EmployeeDim';
	BULK INSERT bronze.EmployeeDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\EmployeeDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: InventoryFact';
	TRUNCATE TABLE bronze.InventoryFact;

	PRINT '>>>>Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.InventoryFact
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\InventoryFact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: LocationDim';
	TRUNCATE TABLE bronze.LocationDim;

	PRINT '>>>>Inserting Data Into: LocationDim';
	BULK INSERT bronze.LocationDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\LocationDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.MarketingFact';
	TRUNCATE TABLE bronze.MarketingFact;

	PRINT '>>>>Inserting Data Into: bronze.MarketingFact';
	BULK INSERT bronze.MarketingFact
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\MarketingFact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: ProductDim';
	TRUNCATE TABLE bronze.ProductDim;

	PRINT '>>>>Inserting Data Into: bronze.ProductDim';
	BULK INSERT bronze.ProductDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\ProductDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';


	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.ReturnsFact';
	TRUNCATE TABLE bronze.ReturnsFact;

	PRINT '>>>>Inserting Data Into: bronze.ReturnsFact';
	BULK INSERT bronze.ReturnsFact
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\ReturnsFact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.SalesFact';
	TRUNCATE TABLE bronze.SalesFact;

	PRINT '>>>>Inserting Data Into: bronze.SalesFact';
	BULK INSERT bronze.SalesFact
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\SalesFact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.ShipmentFact';
	TRUNCATE TABLE bronze.ShipmentFact;

	PRINT '>>>>Inserting Data Into: bronze.ShipmentFact';
	BULK INSERT bronze.ShipmentFact
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\ShipmentFact.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.SupplierDim';
	TRUNCATE TABLE bronze.SupplierDim;

	PRINT '>>>>Inserting Data Into: bronze.SupplierDim';
	BULK INSERT bronze.SupplierDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\SupplierDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

	SET @start_time =GETDATE();
	PRINT '>>>>Truncating Table: bronze.TimeDim';
	TRUNCATE TABLE bronze.TimeDim;

	PRINT '>>>>Inserting Data Into: bronze.TimeDim';
	BULK INSERT bronze.TimeDim
	FROM 'C:\Users\Patrick Sanchez\Downloads\mytruckpoint\TimeDim.csv'
	WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);

	SET @end_time = GETDATE();
	PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>> ----------------';

		SET @batch_end_time = GETDATE();
		PRINT '================================================================='
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '     - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '================================================================='
	END TRY
	BEGIN CATCH
		PRINT '================================================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================='
	END CATCH
END
