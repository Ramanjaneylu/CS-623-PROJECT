-- Database: CS 623 PROJECT

-- DROP DATABASE IF EXISTS "CS 623 PROJECT";

CREATE DATABASE "CS 623 PROJECT"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- Create a new database
CREATE DATABASE gis_analysis;

-- Connect to the new database
\c gis_analysis;

-- Enable the PostGIS extension in the current database
CREATE EXTENSION postgis;

-- Create a table to store spatial data (points)
CREATE TABLE spatial_data (
    id SERIAL PRIMARY KEY,   -- Unique identifier for each record
    name VARCHAR(50),        -- Name or label for the point
    geom GEOMETRY(Point, 4326)  -- Point geometry with SRID 4326 (WGS 84)
);

-- Insert sample data into the spatial_data table
INSERT INTO spatial_data (name, geom)
VALUES
    ('Point A', ST_GeomFromText('POINT(-74.0059 40.7128)', 4326)),
    ('Point B', ST_GeomFromText('POINT(-73.9866 40.7484)', 4326)),
    ('Point C', ST_GeomFromText('POINT(-73.9814 40.7549)', 4326));

-- Retrieve locations of specific features (e.g., 'Point A')
SELECT *
FROM spatial_data
WHERE name = 'Point A';

-- Calculate distance between points
SELECT
    name AS point1,
    LEAD(name) OVER (ORDER BY id) AS point2,
    ST_Distance(geom, LEAD(geom) OVER (ORDER BY id)) AS distance
FROM spatial_data
ORDER BY id;

-- Calculate areas of interest using the 'name' column for demonstration
SELECT
    name,
    ST_Area(ST_Collect(geom)) AS total_area
FROM spatial_data
GROUP BY name;

-- Sort and limit executions, retrieving the first 2 rows ordered by name
SELECT *
FROM spatial_data
ORDER BY name
LIMIT 2;

-- Create a spatial index on the 'geom' column to optimize spatial queries
CREATE INDEX spatial_data_geom_idx ON spatial_data USING GIST(geom);
