USE AdventureWorks2012;
GO

CREATE PROCEDURE dbo.WorkOrdersByMonths(@months NVARCHAR(110))
AS
BEGIN
	DECLARE @sqlQuery NVARCHAR(MAX);
	SET @sqlQuery = '
	SELECT [Year],' + @months + '
	FROM ( 
	    SELECT
		    YEAR(DueDate) AS [Year], 
			OrderQty, 
			DATENAME(MONTH, DueDate) AS [Month]			
		FROM
		    Production.WorkOrder
	) SourceTable
	PIVOT
	(
	    SUM(OrderQty)
	    FOR [Month]
	    IN (' + @months + ')
	) PivotTable';
	EXEC sp_executesql @sqlQuery;
END;
GO

EXECUTE dbo.WorkOrdersByMonths '[January],[February],[March],[April],[May],[June]';
GO