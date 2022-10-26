/**
Create a new table myFiles(key,content), where key is a unique string and content is of type jsonb.
Insert a new file into myfiles with key = groups and content is the result of the query from Exercise 2.
**/

drop table if exists myFiles;

create table myFiles(
    key varchar(255) unique,
    content jsonb
);

insert into myFiles (key, content) values ('groups',(select to_json(gruppe)
from  (
    select json_agg(gr) as groups from(SELECT g.name,  p1.nachname || ' ' || p1.vorname as owner,
    json_agg(json_build_object('name', p2.nachname || ' ' || p2.vorname,'email', p.email)) as members
    from gruppe g join person p1 on p1.email = g.emailowner, istingruppe p join person p2 on p2.email = p.email
    where g.name = p.gruppename
    group by g.name, owner) as gr) as gruppe) );

select * from myFiles;