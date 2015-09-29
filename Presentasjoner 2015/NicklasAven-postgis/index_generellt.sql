set search_path = 'lab', 'public';

/*
drop table the_box;
drop table found_by_index;
drop table found_by_index_boxes;
drop table found_by_st_intersects;
*/

/*Gör en bounding box*/
--create table the_box as
SELECT ST_SetSrid(ST_MakeBox2D(ST_Point(327000, 6726000), ST_Point(327600, 6726300)),32633) box;

/*lagra tabell med linjer som indexet har hittat*/
--create table found_by_index as
select ogc_fid, geometri from 
n50.n50_vegsti as v, the_box as b where geometri && b.box;

/*Bounding boxes för de linjer indexet har hittat*/
--create table found_by_index_boxes as
select ogc_fid, ST_Envelope(geometri) geom from 
n50.n50_vegsti as v, the_box as b where geometri && b.box;

/*De linjer som funktionen ST_Intersects har hittat*/
--create table found_by_st_intersects as
select ogc_fid, geometri from 
n50.n50_vegsti as v, the_box as b where ST_Intersects(geometri, b.box);


/*Test med ST_DWithin*/
select ogc_fid, geometri from 
n50.n50_vegsti as v, the_box as b where ST_Dwithin(geometri, b.box, 1000);


/*

CREATE OR REPLACE FUNCTION public.st_intersects(
    geom1 geometry,
    geom2 geometry)
  RETURNS boolean AS
'SELECT $1 && $2 AND _ST_Intersects($1,$2)'
  LANGUAGE sql IMMUTABLE;



CREATE OR REPLACE FUNCTION public._st_intersects(
    geom1 geometry,
    geom2 geometry)
  RETURNS boolean AS
'$libdir/postgis-2.2', 'intersects'
  LANGUAGE c IMMUTABLE STRICT;




CREATE OR REPLACE FUNCTION public.st_dwithin(
    geom1 geometry,
    geom2 geometry,
    double precision)
  RETURNS boolean AS
'SELECT $1 && ST_Expand($2,$3) AND $2 && ST_Expand($1,$3) AND _ST_DWithin($1, $2, $3)'
*/
