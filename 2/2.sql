/**
Create an SQL query that exports all groups with their group owners and all members in the following JSON format:
{
    "groups”:[
        {“title”: “CSI Miami”,“owner”: ”OwnerName”, “members”: [
            {“name” : “someMemberName”, “email” : “someMemberEmail”},
            ...
            ]
        },
        ...
    ]
}
  **/

select to_json(groupsq)
from (
select json_agg(gr) as groups
from (select g.name,  p1.nachname || ' ' || p1.vorname as owner, json_agg(gq) as members
	 from gruppe g, istingruppe iig, person p1, (select p.vorname||' '||p.nachname as name, p.email from person p) as gq
	 where gq.email = iig.email and iig.gruppename = g.name
	 group by g.name, p1.nachname, p1.vorname) as gr
) as groupsq;

/**
Creates:
-- Something.

**/