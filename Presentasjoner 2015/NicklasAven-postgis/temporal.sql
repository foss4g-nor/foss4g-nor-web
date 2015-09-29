
/*Ok vi gör ett schema spor och sätter search_path  så det pekar dit*/
create schema spor;
set search_path = 'spor','public';


/*
drop table sporlinjer;
create table sporlinjer as select trackid, st_setsrid(st_makeline(st_makepointm(st_x(geom), st_y(geom), extract(epoch from time))),32633) geom from
 (select * from sbskog."SBLOGG_SPORLOGGSOL_EVW" where trackid in (15269550,97303782,14229262) order by trackid, time) a group by trackid;

create table spor_punkter as 
select trackid, time, geom from sbskog."SBLOGG_SPORLOGGSOL_EVW" where trackid in (15269550,97303782,14229262);
*/


--drop table closestline;
create table closestline as
with m_table as(
	select st_closestpointofapproach(a.geom, b.geom) m, 
		a.geom geoma, 
		b.geom geomb 
	from sporlinjer a, sporlinjer b 
	where a.trackid = 15269550 and b.trackid in (97303782,14229262))
select to_timestamp(m) klockslag, 
	st_setsrid(
		st_makeline(
			ST_GeometryN(st_locatealong(geoma, m),1), 
			ST_GeometryN(st_locatealong(geomb, m),1))
		,32633) geom 
from m_table;

--drop table spor_bitar;
create table spor_bitar as
with linje as(
	select 
		trackid, 
		ST_SimplifyVW(
			ST_MakeLine(
				ST_MakePointM(
					ST_X(geom),
					ST_Y(geom),
					extract(epoch from time))
			),1) geom 
	from 
	(select * from spor_punkter order by trackid, time) a
	group by trackid),
punkter as(
	select trackid, 
		(st_dumppoints(geom)).geom geom 
	from linje)
select 
	trackid, 
	st_setsrid(
		st_makeline(
			geom,
			lag(geom) over (partition by trackid order by st_m(geom)))
		,32633) geom 
from punkter;

--drop table close_enough;
create table close_enough as
select 
	st_shortestline(a.geom, b.geom) geom 
from spor_bitar a, spor_bitar b 
where st_cpawithin(a.geom, b.geom, 30) and a.trackid != b.trackid;

