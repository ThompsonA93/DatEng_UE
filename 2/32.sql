/**
Write a query querying myFiles, that returns the name and ownernameof all groups, where Hanna Schmidtis a member.
  The result should be a standard relation(no JSON).
**/

/* For nesting, check 'Addressing JSON in SQL'
-> :: Get key+value
->> :: Get value
#> :: On arrays, get key+value
#>> :: On arrays, get key

https://www.postgresql.org/docs/9.4/functions-json.html
jsonb_array_elements(jsonb): Expands a JSON array to a set of JSON values.
*/

-- Variant a
select grp.groups->'name' as groupname, grp.groups->'owner' as owner -- select groups and owners
from (select jsonb_array_elements(content->'groups') as groups from myfiles) as grp -- unnest groups to group
where 'Schmidt Hanna' in (select jsonb_array_elements(grp.groups->'members')->>'name'); -- unnest group to member


