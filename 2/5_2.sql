/**
Create a query that returns the total number of people employed in each
department including all employees of its sub-departments.
**/



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

