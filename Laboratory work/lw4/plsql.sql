
SELECT * FROM NE_10M_ADMIN_0_BOUNDARY_LINES_;

-- TASK №6

SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'NE_10M_ADMIN_0_BOUNDARY_LINES_' AND COLUMN_NAME = 'GEOM';


-- TASK №7
SELECT SRID FROM USER_SDO_GEOM_METADATA
    WHERE TABLE_NAME = 'NE_10M_ADMIN_0_BOUNDARY_LINES_';


-- TASK №8
SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'NE_10M_ADMIN_0_BOUNDARY_LINES_';


SELECT * FROM NE_10M_ADMIN_0_BOUNDARY_LINES_;


-- TASK №9

SELECT SDO_UTIL.TO_WKTGEOMETRY(GEOM) FROM NE_10M_ADMIN_0_BOUNDARY_LINES_;


-- TASK №10

-- # 10.1

SELECT  SDO_GEOM.SDO_INTERSECTION(a.geom, b.geom, 0.005) as intersection
    FROM NE_10M_ADMIN_0_BOUNDARY_LINES_ a, NE_10M_ADMIN_0_BOUNDARY_LINES_ b
        WHERE SDO_ANYINTERACT(a.geom, b.geom) = 'TRUE';

-- # 10.2

SELECT A.X, A.Y FROM NE_10M_ADMIN_0_BOUNDARY_LINES_ T
    CROSS JOIN TABLE (SDO_UTIL.GETVERTICES (T.GEOM)) A;


-- # 10.3
SELECT SDO_GEOM.SDO_AREA(GEOM, 0.005) as area FROM NE_10M_ADMIN_0_BOUNDARY_LINES_;


-- TASK №11
-- ТОЧКА.
INSERT INTO NE_10M_ADMIN_0_BOUNDARY_LINES_ (GEOM)
VALUES (
  SDO_GEOMETRY(
    2001,
    4326,
    SDO_POINT_TYPE(37.7749, -122.4194, NULL),  -- X, Y coordinates
    NULL,
    NULL
  )
);

-- ЛИНИЯ.
INSERT INTO NE_10M_ADMIN_0_BOUNDARY_LINES_ (GEOM)
VALUES (
  SDO_GEOMETRY(
    2002,
    4326,
    NULL,
    SDO_ELEM_INFO_ARRAY(1,2,1),
    SDO_ORDINATE_ARRAY(37.7749, -122.4194, 34.0522, -118.2437)
  )
);

-- ПОЛИГОН.
INSERT INTO NE_10M_ADMIN_0_BOUNDARY_LINES_ (GEOM)
VALUES (
  SDO_GEOMETRY(
    2003,  -- SDO_GTYPE for polygon
    4326,  -- SRID for WGS84 latitude/longitude
    NULL,
    SDO_ELEM_INFO_ARRAY(1,1003,1),
    SDO_ORDINATE_ARRAY(37.7749, -122.4194, 34.0522, -118.2437, 33.7490, -84.3880, 37.7749, -122.4194)
  )
);

SELECT SDO_UTIL.TO_WKTGEOMETRY(GEOM) FROM NE_10M_ADMIN_0_BOUNDARY_LINES_;

-- TASK №12 №№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№

SELECT SDO_UTIL.TO_WKTGEOMETRY(A.GEOM), SDO_UTIL.TO_WKTGEOMETRY(B.GEOM) FROM NE_10M_ADMIN_0_BOUNDARY_LINES_ A, NE_10M_ADMIN_0_BOUNDARY_LINES_ B
    WHERE SDO_GEOM.RELATE(A.GEOM, 'anyinteract', B.GEOM, 0.005) = 'TRUE';

-- TASK №12 №№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№№

-- TASK №13

drop INDEX geom_spatial_idx;
CREATE INDEX geom_spatial_idx ON NE_10M_ADMIN_0_BOUNDARY_LINES_(GEOM)  INDEXTYPE IS MDSYS.SPATIAL_INDEX;



-- TASK №14
CREATE OR REPLACE PROCEDURE GetSpatialObjectForPoint(
    p_lat IN NUMBER,
    p_lon IN NUMBER,
    p_spatial_object OUT MDSYS.SDO_GEOMETRY
)
AS
BEGIN
    SELECT GEOM INTO p_spatial_object
    FROM NE_10M_ADMIN_0_BOUNDARY_LINES_
    WHERE SDO_CONTAINS(GEOM, MDSYS.SDO_GEOMETRY(2001, 4326, MDSYS.SDO_POINT_TYPE(p_lon, p_lat, NULL), NULL, NULL)) = 'TRUE';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Данные не найдены для заданных координат.');
END;
/



DECLARE
    v_spatial_object MDSYS.SDO_GEOMETRY;
BEGIN
    GetSpatialObjectForPoint(37.7749, -122.4194, v_spatial_object);
    DBMS_OUTPUT.PUT_LINE('Spatial Object: ' || SDO_UTIL.TO_WKTGEOMETRY(v_spatial_object));
END;
/
