


/*
drop view if exists simplify_dp_3d;
drop view if exists simplify_vw_3d;
drop table if exists figurer_3d;
*/

/*Simplifieringsfunktioner i PostGIS*/

/*Denna sida visar att ST_SimplifyVW-funktionen påverkas av z-värdet medan ST_Simplify inte gör det*/

set search_path to 'lab', 'public';

create table figurer_3d (geom geometry(linestringz,32633), gid serial primary key);

insert into figurer_3d(geom) values 
(st_setsrid(st_geomfromtwkb('\x0208010582f627fe88b5069003466a135688014f3c7e13265c09'),32633));

/*Den gamla hederliga
	Douglas-Peucker*/
Create or replace view simplify_dp_3d as
select st_simplify(geom, 5) geom, gid from figurer_3d;

/*Den nya Visvalingam-Whyatt implementeringen*/
Create or replace view simplify_vw_3d as
select st_simplifyvw(geom, 25) geom, gid,st_seteffectivearea(geom) ea_3d,st_seteffectivearea(st_force2d(geom)) ea_2d from figurer_3d;


select st_npoints(geom) from figurer_3d;
select st_npoints(geom) from simplify_dp_3d;
select st_npoints(geom) from simplify_vw_3d;

with p as
(select (st_dumppoints(ea_2d)).geom g1,(st_dumppoints(ea_3d)).geom g2 from simplify_vW_3d)
select st_x(g1) X, st_y(g1) Y, st_z(g1) "Z 2D", st_m(g1) "M 2D", st_z(g2) "Z 3D", st_m(g2) "M 3D" from p


