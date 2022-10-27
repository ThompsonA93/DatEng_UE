/**
Write a query querying myFiles, that returns the title and owner name of all groups,
where Hanna Schmidt is a member. The result should be a standard relation (no JSON).
  **/

/* For nesting, check 'Addressing JSON in SQL'
-> :: Get key+value
->> :: Get value
#> :: On arrays, get key+value
#>> :: On arrays, get key
https://www.postgresql.org/docs/9.4/functions-json.html
jsonb_array_elements(jsonb): Expands a JSON array to a set of JSON values.
*/

-- Test to see where Hanna is
SELECT * from istingruppe where email = 'Hanna.Schmidt@gmx.net';

-- Query from myFiles/jsonb
SELECT grp.groups->'title' AS title, grp.groups->'owner' AS owner -- select groups and owners
FROM (
    SELECT jsonb_array_elements(content->'groups') AS groups FROM myfiles
) AS grp -- unnest groups to group
WHERE 'Schmidt Hanna' IN (
    SELECT jsonb_array_elements(grp.groups->'members')->>'name'
); -- unnest group to member