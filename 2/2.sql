/**
Create an SQL query that exports all groups with their group owners and all members in the
following JSON format:

{
    “groups” : [
        {“title”: “CSI Miami”, “owner”: ”OwnerName”, “members” : [
        {“name” : “someMemberName”, “email” : “someMemberEmail”},
        …
        ]
    },
    …
    ]
}
  **/
-- Selection example of all persons
SELECT to_json(p) from person p;

-- Wrapping groups
SELECT to_json(qry)
FROM(
    SELECT json_agg(grps) as groups
    FROM(
        SELECT g.name as title, p.vorname || ' ' || p.nachname as owner
        FROM gruppe g, person p
        GROUP BY g.name, p.email
    ) as grps
) AS qry;

-- Adding members to groups
SELECT to_json(qry)
FROM (
    SELECT json_agg(grps) AS groups
    FROM (
        SELECT g.name AS title,  p1.nachname || ' ' || p1.vorname AS owner, json_agg(mems) AS members
	    FROM gruppe g, istingruppe iig, person p1, (SELECT p.vorname ||' '|| p.nachname as name, p.email as mail from person p) as mems
	    WHERE mems.mail = iig.email and iig.gruppename = g.name
	    group by g.name, p1.nachname, p1.vorname
	 ) as grps
) as qry;