/**
Create an SQL query that exports all groups with their group owners and their members in the following XML format
<groups>
    <group name=”CSI Miami” owner=”OwnerName”>
        <membername=”someMemberName” email=”someMemberEmail”>
        ...
    </group>
    ...
</groups>

Beispiel: Publishing SQL as XML Example 4
  **/

select xmlelement(name groups, xmlagg(pq.pe)) -- The Groups-Tag
from
(
    select xmlelement( name group, xmlattributes(g.name,p.vorname || ' ' || p.nachname as owner), -- The Group tag
        (SELECT xmlagg(xmlelement(name member, xmlattributes(p.vorname || ' ' || p.nachname as name, iig.email))) -- The members
        from istingruppe iig join person p on p.email = iig.email where iig.gruppename = g.name)) as pe -- aggregate the singular group on members and owners within group
    from person p, gruppe g, istingruppe iig
    where p.email = g.emailowner and iig.gruppename = g.name) as pq; -- aggregate the groups

