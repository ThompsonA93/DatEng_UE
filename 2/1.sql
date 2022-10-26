/**
Create an SQL query that exports all groups with their group owners and their members in
the following XML format:

<groups>
    <group title=”CSI Miami” owner=”OwnerName”>
        <member name=”someMemberName” email=”someMemberEmail”>
    …
    </group>
    …
</groups>

Beispiel: Publishing SQL as XML Example 4
  **/

-- Aggregate all members (Example 2)
SELECT xmlelement(
    name member,
    xmlattributes (p.vorname || ' ' || p.nachname as name, p.email as email)
           ) from person p;

-- Wrap all members using group and groups (Example 3)
SELECT xmlelement(
    name groups,
    xmlelement(
        name group,
        xmlagg(
            xmlelement(
                name member,
                xmlattributes(p.vorname || ' ' || p.nachname as name, p.email as email )
                )
            )
        )
    ) from person p, gruppe g;

-- Correctly group the groups
SELECT xmlelement(NAME groups, xmlagg(pq.pe))
FROM (
    SELECT xmlelement(
        NAME group,
        XMLATTRIBUTES(g.name as title, p.vorname || ' ' || p.nachname AS owner)
    ) AS pe
    FROM gruppe g, person p, istingruppe ig
    WHERE p.email = g.emailowner
    AND ig.gruppename = g.name
) AS pq;


-- Add members to each group (Example 4)
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