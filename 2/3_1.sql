/**
Create a new table myFiles(key,content), where key is a unique string and content is
of type jsonb. Insert a new file into myfiles with key = groups and content is the
result of the query from Exercise 2
**/

drop table if exists myFiles;

create table myFiles(
    key varchar(255) unique,
    content jsonb
);

INSERT INTO myFiles (key, content) VALUES (
    'groups',
    (
        SELECT to_json(qry)
        FROM  (
            SELECT json_agg(gr) AS groups
            FROM (
                SELECT g.name AS title,  p1.nachname || ' ' || p1.vorname AS owner, json_agg(json_build_object('name', p2.nachname || ' ' || p2.vorname,'email', p.email)) AS members
                FROM gruppe g JOIN person p1 ON p1.email = g.emailowner, istingruppe p JOIN person p2 ON p2.email = p.email
                WHERE g.name = p.gruppename
                GROUP BY g.name, owner
            ) AS gr
        ) AS qry
    )
);

SELECT * FROM myFiles;