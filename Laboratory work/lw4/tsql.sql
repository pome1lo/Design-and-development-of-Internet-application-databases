USE PiRBDIP;

-- 6.  ���������� ��� ���������������� ������ �� ���� ��������
-- ��� ������ ��������� �������������� �������� � ������������ � ����� ���� ������������ ��� ������������� � ������� �������������� � ���������������� �������.

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'dbo'




-- 7.  ���������� SRID - ������������� ������� ���������
-- ������� SRID �������� SRID 4326, ������� ���������� ������� ��������� WGS 84 (������/�������), ������� ������������ ��� ���-���� � �������� Web Mercator.

SELECT SRID FROM dbo.geometry_columns






-- 8.  ���������� ������������ �������
-- �������� ���������� �� ��������� (���������������) �������������� ��������

SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE != 'geometry'






-- 9.  ������� �������� ���������������� �������� � ������� WKT
--  ��������� ������ ��� ������������� �������������� �������� � ������������

SELECT geom.STAsText() AS WKT_Description FROM Current_Speeds_Full_Year






-- 10.1.  ���������� ����������� ���������������� ��������;
-- ����������� �������, ����� ��� ���� ��� ����� ���������������� ��������.
SELECT a.geom.STIntersection(b.geom) AS ����������� FROM Current_Speeds_Full_Year a, Current_Speeds_Full_Year b
	WHERE a.qgs_fid = 20 AND b.qgs_fid = 20

SELECT a.geom.STIntersection(b.geom) AS ����������� FROM Current_Speeds_Full_Year a, Current_Speeds_Full_Year b
	WHERE a.qgs_fid = 11 AND b.qgs_fid = 8

SELECT a.geom.STIntersection(b.geom) AS ����������� FROM Current_Speeds_Full_Year a, Current_Speeds_Full_Year b
	WHERE a.qgs_fid = 3 AND b.qgs_fid = 5



-- 10.2.  ���������� ��������� ������ ����������������� ��������
SELECT geom.STPointN(1).ToString() AS ���������� FROM Current_Speeds_Full_Year
	WHERE qgs_fid = 7



-- 10.3  ���������� ������� ���������������� ��������;
-- ������� (Area): ��������� ������� ��������� ��������, ����� ��� ��������.
SELECT geom.STArea() AS ObjectArea FROM Current_Speeds_Full_Year
	WHERE qgs_fid = 2







-- 11.  �������� ���������������� ������ � ���� ����� (1) /����� (2) /�������� (3).

-- �����
DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(5 5)', 4326);

SELECT @pointGeometry AS PointGeometry;


-- �����
DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(10 15, 15 27, 39 29)', 4326);

SELECT @lineGeometry AS LineGeometry;


-- �������
DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((25 10, 67 57, 17 7, 27 1, 25 10))', 4326);

SELECT @polygonGeometry AS PolygonGeometry;





-- 12.  �������, � ����� ���������������� ������� �������� ��������� ���� �������

-- ����� � �������

DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(5 5)', 4326);
SELECT * FROM Current_Speeds_Full_Year WHERE geom.STContains(@point) = 1;

-- ������ � �������
DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(47 -17, 37 -17, 37 -17)', 4326);
SELECT * FROM Current_Speeds_Full_Year WHERE geom.STContains(@line) = 1;

DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((35 -15, 35 -14, 36 -10, 35 -15))', 4326);
SELECT * FROM Current_Speeds_Full_Year WHERE geom.STContains(@polygon) = 1;





--13.	����������������� �������������� ���������������� ��������.
-- �������� ����������������� �������
-- �������� ����������������� �������
CREATE SPATIAL INDEX IX_Current_Speeds_Full_Year_geom
ON [dbo].[Current_Speeds_Full_Year]([geom])
USING GEOMETRY_GRID
WITH (BOUNDING_BOX = (0, 0, 1000, 1000)); -- ������� ������ �������

-- ������������ ���������� ��� �������
UPDATE STATISTICS [dbo].[Current_Speeds_Full_Year] WITH FULLSCAN;


-- �������� ������� ��� ������������
CREATE TABLE [dbo].[Current_Speeds_Full_Year_demo] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [geom] GEOGRAPHY
);


DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((35 -15, 35 -14, 36 -10, 35 -15))', 4326);
SELECT * FROM Current_Speeds_Full_Year WHERE geom.STContains(@polygon) = 1;









DROP TABLE [Current_Speeds_Full_Year_demo]

CREATE TABLE [dbo].[Current_Speeds_Full_Year_demo] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [geom] GEOGRAPHY
);


INSERT INTO [dbo].[Current_Speeds_Full_Year_demo] ([geom])
VALUES (geography::Point(47.6062, -122.3321, 4326)), 
       (geography::Point(40.7128, -74.0060, 4326)),  
       (geography::Point(34.0522, -118.2437, 4326)); 


DECLARE @point GEOGRAPHY = geography::Point(37.7749, -122.4194, 4326);

SELECT TOP 1 * FROM [dbo].[Current_Speeds_Full_Year_demo]
	ORDER BY [geom].STDistance(@point);



CREATE SPATIAL INDEX MEGA_INDEX
ON [dbo].[Current_Speeds_Full_Year_demo]([geom])
USING GEOGRAPHY_GRID;

-- ������������ ���������� ��� �������
UPDATE STATISTICS [dbo].[Current_Speeds_Full_Year_demo] WITH FULLSCAN;

INSERT INTO [dbo].[Current_Speeds_Full_Year_demo] ([geom])
VALUES (geography::Point(47.6062, -122.3321, 4326)), 
       (geography::Point(40.7128, -74.0060, 4326)),  
       (geography::Point(34.0522, -118.2437, 4326)); 


DECLARE @point GEOGRAPHY = geography::Point(37.7749, -122.4194, 4326); 

SELECT TOP 1 * FROM [dbo].[Current_Speeds_Full_Year_demo]
	ORDER BY [geom].STDistance(@point);













--14.	������������ �������� ���������, ������� ��������� ���������� ����� � ���������� ���������������� ������, � ������� ��� ����� ��������.
CREATE OR ALTER PROCEDURE GetGeometryFromPoint
    @latitude FLOAT,
    @longitude FLOAT,
    @resultGeometry GEOMETRY OUTPUT
AS
BEGIN
    DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(' + CAST(@longitude AS NVARCHAR(20)) + ' ' + CAST(@latitude AS NVARCHAR(20)) + ')', 4326);
    SET @resultGeometry = (SELECT TOP 1 geom FROM Current_Speeds_Full_Year WHERE geom.STContains(@point) = 1);
END;

DECLARE @latitude FLOAT = 30.0;
DECLARE @longitude FLOAT = 30.0;
DECLARE @result GEOMETRY;

EXEC GetGeometryFromPoint @latitude, @longitude, @result OUTPUT;
select @result; 

-- @result ������ �������� ������ GEOMETRY
SELECT @result AS PointGeometry;
