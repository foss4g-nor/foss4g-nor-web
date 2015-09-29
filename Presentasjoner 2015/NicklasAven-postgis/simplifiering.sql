
/* 	preparering*/

/*Vi gör ett eget schema för våra försök*/
--CREATE SCHEMA lab;

/*Lägg till PostGIS i databasen om det inte redan är gjort/*
--CREATE EXTENSION postgis;

/*För att köra det sista exemplet så må också postgis_topology läggas till*/
--CREATE EXTENSION postgis_topology;


/*Bara för att det skall gå lättare att börja om ....
/*
drop table if exists simplify_dp;
drop table if exists simplify_vw;
drop table if exists simplify_topo_dp;
drop table if exists simplify_dp_preserve;
drop table if exists snap_to_grid;
drop table if exists figurer;
SELECT topology.DropTopology('topo');
*/



/*Vi sätter search_path. Då vi sätter schemaet lab först så är det dit nya objekt skrivs om vi inte preciserar vart de skall.
Schema public måste också vara med för att databasen skall hitta PostGIS-funktionerna som ligger i det schemaet*/
set search_path to 'lab', 'public';


/*Vi gör en tabell som vi skall ha våra demo-figurer i*/
create table figurer 
(
	geom geometry(polygon,32633), 
	gid serial primary key
);

/*Så lägger vi till 2 figurer. */
insert into figurer(geom) values 
(st_setsrid(st_geomfromtwkb('\x03000114f6e625c2e6c1069c419c48de8302cf19eca002d1d101a12cab5e8739a809a12cd212ad50d4048f16be66e613e421cf19a617994f008547e321f337bd03fd069e33d10b8c2ba517d40ba517e70c8939cf19b71ff822'),32633)),
(st_setsrid(st_geomfromtwkb('\x0300011480b625ae82c106f6309464b81ff7228a39d019a617e80ca617d30bd20b8b2bfe069d33f437be038647e4219a4f00d019a517e513e3219016bd66ae50d304a22cd1128839a709901dd112bf8f03873989f801f8e801'),32633));

/*Här gör vi lite tabeller. Bara att öppna i QGIS och ta en titt på hur de blir och jämföra med orginalet (figurer)*/

/*Den gamla hederliga
	Douglas-Peucker*/
Create table simplify_dp as
select st_simplify(geom, 1200) geom, gid from figurer;

/*Den nya Visvalingam-Whyatt implementeringen*/
Create table simplify_vw as
select st_simplifyvw(geom, 5000000) geom, gid from figurer;


/*Här är antalet punkter efter de olika alternativen av simplifiering. */
select st_npoints(geom) from figurer;
select st_npoints(geom) from simplify_dp;
select st_npoints(geom) from simplify_vw;


/*simplifyPreserveTopology*/
Create table simplify_dp_preserve as
select st_simplifypreservetopology(geom, 1200) geom, gid from figurer;

/*SnapToGrid*/
Create table snap_to_grid as
select st_snaptogrid(geom, 3000) geom, gid from figurer;


select st_npoints(geom) from snap_to_grid;

/*Ok, inget av ovanstående alternativ ger ett tillfredsställande resultat
med avseende på topologi.
För att polygonerna skall hänga ihop med sina grannar så behöver vi skapa 
topologier med postgis topology*/

/*Vi ändrar först lite på search_path så vi får med topologi-schemaet.
Det skapades upp när extension postgis_topolofy kördes i början av sidan*/
set search_path to 'lab', 'public', 'topology';


/*Skapa en ny topologi som vi kallar för topo
(ett nytt schema skapas med namnet vi väler för topologien)*/
select CreateTopology('topo', 32633, 1);


/*Lägg till en ny kolumn till vår ursprunliga tabell som innehåller topologierna (eller egentligen referenser till de delar som bygger upp topologien)*/
select addtopogeometrycolumn('topo','lab','figurer', 'topo', 'polygon');

/*Lägg till våra 2 geoemtrier som topologier i våran nya topo-kolumn
Det som sker är att geoemtrierna delas upp i edges och nodes och läggs i tabeller i topologi-schemaet.
I vår tabell figurer lagras bara referenser till dessa linjer och punkter så att en yta kan byggas upp*/
update figurer set topo = totopogeom(geom, 'topo', 1,1);


select topo::geometry from figurer;


/*ST_Simplify mot en topologi använder Douglas-Peucker-algoritmen mot topologiens edges.
Och i vårat exempel så delar båda polygonerna den gemensamma linjen (edgen) mellan sig 
Så den simplifieras bara en gång och används till att bygga upp båda geometrierna
vilket resulterar i att de hänger perfekt ihop.*/
--drop table simplify_topo_dp;
Create table simplify_topo_dp as
select st_simplify(topo, 1200) geom, gid from figurer;




/************************** Effectivearea ***********************************/
/*Effective Area är den area som Visvalingam-Whyatt algoritmen räknar ut att varje vertex-punkt "är värd".
Den kan lagras i m-koordinaten med funktionen ST_SetEffectiveArea för senare snabb simplifiering genom filtrering med tröskelvärde*/
with p as(
select 
(st_dumppoints(ST_SetEffectiveArea(geom))).geom g from figurer where gid = 1 )
select st_x(g) "X", st_y(g) "Y", round(st_m(g)) "M" from p


