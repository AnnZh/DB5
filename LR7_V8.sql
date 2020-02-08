USE AdventureWorks2012;
GO 
 
SELECT
Addr.AddressID AS '@ID',
Addr.City AS 'City',
Province.StateProvinceID AS 'Province/@ID',
Province.CountryRegionCode AS 'Province/Region'
FROM Person.Address AS Addr
JOIN Person.StateProvince AS Province
ON Addr.StateProvinceID = Province.StateProvinceID
FOR XML PATH ('Address'), ROOT ('Addresses');

IF OBJECT_ID('dbo.GetAddressesFromXmlVariable', 'P') IS NOT NULL
	DROP PROCEDURE [dbo].[GetAddressesFromXmlVariable];
GO

CREATE PROCEDURE dbo.GetAddressesFromXmlVariable (@XMLvar XML)
AS
BEGIN
SELECT
X.value('@ID', 'int') AS AddressID,
X.value('City[1]', 'nvarchar(30)') AS City,
X.value('Province[1]/@ID', 'int') AS StateProvinceID,
X.value('Province[1]/Region[1]', 'nvarchar(3)') AS CountryRegionCode
FROM @XMLvar.nodes('//Address') AS T(X)
END;
GO

DECLARE @XMLvariable XML;
SET @XMLvariable = ( 
SELECT
Addr.AddressID AS '@ID',
Addr.City AS 'City',
Province.StateProvinceID AS 'Province/@ID',
Province.CountryRegionCode AS 'Province/Region'
FROM Person.Address AS Addr
JOIN Person.StateProvince AS Province
ON Addr.StateProvinceID = Province.StateProvinceID
FOR XML PATH ('Address'), ROOT ('Addresses'));

SELECT @XMLvariable;

DECLARE @AddressTable TABLE (
AddressID INT NOT NULL,
City NVARCHAR(30) NOT NULL,
StateProvinceID INT NOT NULL,
CountryRegionCode NVARCHAR(3) NOT NULL);

INSERT INTO @AddressTable 
EXECUTE dbo.GetAddressesFromXmlVariable @XMLvariable;

SELECT * 
FROM @AddressTable;