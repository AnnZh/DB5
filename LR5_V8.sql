USE AdventureWorks2012;
GO

--1)
CREATE FUNCTION Production.getProductCount (@subcategoryID INT)
RETURNS INT AS 
BEGIN
DECLARE @productsCount INT
SELECT @productsCount = COUNT(*) 
FROM Production.Product AS product
WHERE product.ProductSubcategoryID = @subcategoryID
RETURN @productsCount
END
GO

--2)
CREATE FUNCTION Production.getProductList(@subcategoryID INT)
RETURNS TABLE AS
RETURN
(SELECT *
FROM
Production.Product AS product
WHERE
product.ProductSubcategoryID = @subcategoryID 
AND product.StandardCost > 1000)
GO

--3)
SELECT * 
FROM Production.ProductSubcategory
CROSS APPLY Production.getProductList(ProductSubcategory.ProductSubcategoryID)
GO

SELECT * 
FROM Production.ProductSubcategory
OUTER APPLY Production.getProductList(ProductSubcategory.ProductSubcategoryID)
GO

--4)
CREATE FUNCTION Production.getProductList_Multistatement(@subcategoryID INT)
RETURNS @SubcategoryList TABLE (
ProductID INT NOT NULL,
Name NVARCHAR(50) NOT NULL,
ProductNumber NVARCHAR(25) NOT NULL,
MakeFlag dbo.Flag NOT NULL,
FinishedGoodsFlag dbo.Flag NOT NULL,
Color NVARCHAR(15) NULL,
SafetyStockLevel SMALLINT NOT NULL,
ReorderPoint SMALLINT NOT NULL,
StandardCost MONEY NOT NULL,
ListPrice MONEY NOT NULL,
Size NVARCHAR(5) NULL,
SizeUnitMeasureCode NCHAR(3) NULL,
WeightUnitMeasureCode NCHAR(3) NULL,
Weight DECIMAL(8,2) NULL,
DaysToManufacture INT NOT NULL,
ProductLine NCHAR(2) NULL,
Class NCHAR(2) NULL,
Style NCHAR(2) NULL,
ProductSubcategoryID INT NULL,
ProductModelID INT NULL,
SellStartDate DATETIME NOT NULL,
SellEndDate DATETIME NULL,
DiscontinuedDate DATETIME NULL,
rowguid UNIQUEIDENTIFIER NOT NULL,
ModifiedDate DATETIME NOT NULL
) AS BEGIN
INSERT INTO @SubcategoryList (
ProductID,
Name,
ProductNumber,
MakeFlag,
FinishedGoodsFlag,
Color,
SafetyStockLevel,
ReorderPoint,
StandardCost,
ListPrice,
Size,
SizeUnitMeasureCode,
WeightUnitMeasureCode,
Weight,
DaysToManufacture,
ProductLine,
Class,
Style,
ProductSubcategoryID,
ProductModelID,
SellStartDate,
SellEndDate,
DiscontinuedDate,
rowguid,
ModifiedDate
)
SELECT
ProductID,
Name,
ProductNumber,
MakeFlag,
FinishedGoodsFlag,
Color,
SafetyStockLevel,
ReorderPoint,
StandardCost,
ListPrice,
Size,
SizeUnitMeasureCode,
WeightUnitMeasureCode,
Weight,
DaysToManufacture,
ProductLine,
Class,
Style,
ProductSubcategoryID,
ProductModelID,
SellStartDate,
SellEndDate,
DiscontinuedDate,
rowguid,
ModifiedDate
FROM
Production.Product AS product
WHERE
product.ProductSubcategoryID = @subcategoryID 
AND product.StandardCost > 1000
RETURN
END
GO