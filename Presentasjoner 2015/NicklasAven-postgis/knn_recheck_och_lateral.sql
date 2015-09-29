
/*Frågeställning. Hur långt är det i genomsnitt till närmaste av de 1044081 vägarna från de 933 turisthyttorna*/

--Vi har alltså spørringen här att utgå från som hittar den närmaste vägen till en punkt (tex en hytta):
select * from n50.n50_vegsti order by geometri <-> ST_SetSrid('POINT(327256 6726180)'::geometry,32633) limit 1

--Spörringen ovan kunde lika gärna ha använts på en linje eller polygon, men det a inte det som är problemet.
--Av någon anledning så fungerar det bara med en konstant som ena parameter. Båda kaninte komma från tabeller.
--Då fungerar inte indexen


select distinct on (t.ogc_fid) * from n50.n50_vegsti as v,(select * from n50.n50_turisthytte where ogc_fid = 1) as t order by t.ogc_fid, v.geometri <-> t.geometri


/*Här är lösningen
	Vi gör en join lateral*/
select avg(st_distance(v.geometri, t.geometri)) --,max(st_distance(v.geometri, t.geometri)),min(st_distance(v.geometri, t.geometri) ) 
from 
	n50.n50_turisthytte t  
cross join lateral 
	(select * from n50.n50_vegsti order by geometri <->t.geometri limit 1) v;



select count(*) from n50.n50_vegsti;


select count(*) from n50.n50_turisthytte;


