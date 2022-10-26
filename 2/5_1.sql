/**
Create a recursive SQL query that returns the name and number of employees of all
F&E departments (F&E department and all its descendants).
**/
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


/**
Creates:

Name,numbempl,id
F&E,11,4
Basic Research,70,6
Field Research,90,7
Project Developement,190,8
3D Printing,10,9
Software Developemnet,75,10


**/