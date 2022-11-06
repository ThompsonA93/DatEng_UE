# Assignment 2

- [X] XML Publishing
- [X] JSON Publishing
- [X] Querying JSON
  - [X] 3.1
  - [X] 3.2
- [X] Window Functions
- [X] Hierarchical Queries
  - [X] 5.1
  - [ ] 5.2

## Installation
For Ubuntu 20, install postgresql using
```
~$ sudo apt install postgresql
```
Afterwards, alter the root access to the DBMS
```
~$ sudo -u postgres psql
postgres# \password postgres
```


# Task 1
![Ex1](graphics/Ex1.png)


> Analogy from the example on the slides #2, ""Publishing SQL as XML Example 4"


![VO_XML_4](graphics/VO_XML_4.png)


```
SELECT xmlelement(NAME groups, xmlagg(pq.pe))
FROM (
    SELECT xmlelement(
        NAME group,
        XMLATTRIBUTES(g.name as title, p.vorname || ' ' || p.nachname AS owner),
        (
            SELECT xmlagg(
                xmlelement(
                    NAME member,
                    XMLATTRIBUTES(p.vorname || ' ' || p.nachname AS name, iig.email)
                    )
                ) -- The members
            FROM istingruppe iig
                JOIN person p ON p.email = iig.email
            WHERE iig.gruppename = g.name
        )
    ) AS pe
    FROM gruppe g, person p, istingruppe ig
    WHERE p.email = g.emailowner
    AND ig.gruppename = g.name
) AS pq;
```

# Task 2
![Ex2](graphics/Ex2.png)

> Analogy from the example on the slides #2, ""Publishing relational data as JSON 3"

![VO_JSON_3](graphics/VO_JSON_3.png)


```
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

```

# Task 3
![Ex3](graphics/Ex3.png)


> Creating a new table
```
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
```

> Query the table

```
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
```

# Task 4
![Ex4](graphics/Ex4.png)


> Analogy from the example on the slides #2, "Simple Window Functions 2"

![VO_WF_2](graphics/VO_WF_2.png)


```
SELECT d."deptId", d.name, d."numEmpl", d."parentId", max(d."numEmpl")
    over(partition by d."parentId") as max_employees -- Assuming: The maximum amount of employees per main department??
FROM public.department d
order by d."deptId" asc
```

# Task 5
![Ex5](graphics/Ex5.png)

> Analogy from the example on the slides #2, "Recursive Common Table Expressions"

![VO_RF](graphics/VO_RF.png)

```
-- Assuming: Name of the department + Employee count ?
WITH RECURSIVE emplEnum(deptId, name, parentId, numEmpl) AS
    ( -- Non-recursive part
    SELECT d."deptId", d.name, d."parentId", d."numEmpl"
    FROM department d
    WHERE d.name='F&E'
    UNION -- Recursive part
        SELECT dd."deptId", dd.name, dd."parentId", dd."numEmpl"
        FROM department dd, emplEnum eo -- Refer to recursion table expression
        WHERE dd."parentId" = eo.deptId
    )

select * from emplEnum;
```

```
-- Test: Get total sum of all employees over all departments
WITH RECURSIVE employeecount(deptId, name, parentId, numEmpl) AS
    (
        SELECT d."deptId", name, "parentId", "numEmpl"
        FROM department d
        UNION
            SELECT dd."deptId", dd.name, dd."parentId", dd."numEmpl"
            FROM department dd, employeecount ec
            WHERE dd."parentId"=ec.deptId
    )
SELECT sum(numEmpl) FROM employeecount;
```


