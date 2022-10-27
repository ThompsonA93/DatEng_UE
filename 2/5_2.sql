/**
Create a query that returns the total number of people employed in each
department including all employees of its sub-departments.
**/

-- Only show sum for one given department
WITH RECURSIVE employeecount(deptId, name, parentId, numEmpl) AS (
        SELECT d."deptId", name, "parentId", "numEmpl"
        FROM department d
        WHERE "deptId"=2
        UNION
            SELECT dd."deptId", dd.name, dd."parentId", dd."numEmpl"
            FROM department dd, employeecount ec
            WHERE dd."parentId"=ec.deptId
    ) SELECT sum(employeecount.numEmpl) FROM employeecount;

-- WORKING Example with CROSS JOIN LATERAL
-- Lateral required for reference of inner recursive function to outerdept
SELECT * FROM department outerDept CROSS JOIN LATERAL(
    WITH RECURSIVE department_children("deptId", "numEmpl") AS (
        SELECT "deptId", "numEmpl"
        FROM department d1
        WHERE d1."deptId" = outerDept."deptId"
        UNION
            SELECT nextDept."deptId", nextDept."numEmpl"
            FROM department_children lastDept, department nextDept
            WHERE nextDept."parentId" = lastDept."deptId"
    )
    select SUM("numEmpl") as totalEmployees from department_children
) innerSum;



-- Test: Get total sum of all employees over all departments
WITH RECURSIVE employeecount(deptId, name, parentId, numEmpl) AS
    (
        SELECT d."deptId", name, "parentId", "numEmpl"
        FROM department d
        WHERE d."deptId"=1
        UNION
            SELECT dd."deptId", dd.name, dd."parentId", dd."numEmpl"
            FROM department dd, employeecount ec
            WHERE dd."parentId"=ec.deptId
    )
SELECT sum(numEmpl) FROM employeecount;


-- Runs into endless recursion aswell
WITH RECURSIVE deptEmplEnum(deptId, name, parentId, numEmpl) AS (
        SELECT "deptId", name, "parentId", "numEmpl"
        FROM department
        UNION
            SELECT dd."deptId", dd.name, dd."parentId", dd."numEmpl"+ec.numEmpl
            FROM department dd, deptEmplEnum ec
            WHERE dd."parentId"=ec.deptId
    )
SELECT deptId, sum(numEmpl) FROM deptEmplEnum
GROUP BY deptId
ORDER BY deptId;


-- Running bottom up using parent-id also stuck in endless recursion
WITH RECURSIVE cte as (
    SELECT department."deptId", department."numEmpl", "parentId"
    FROM department
    UNION ALL
        SELECT department."deptId", department."numEmpl", cte."parentId"
        FROM cte JOIN department ON department."parentId" = cte."deptId"
)
SELECT "parentId", sum("numEmpl")
FROM cte
GROUP BY "parentId";

-- Also stuck in endless recursion
WITH RECURSIVE children AS (
    SELECT "deptId", "numEmpl", "parentId"
    FROM department
    UNION ALL
        SELECT department."deptId", children."numEmpl", department."parentId"
        FROM children JOIN department ON children."parentId" = department."deptId"
)
SELECT "deptId", sum("numEmpl") FROM children
GROUP BY "deptId";


-- Stuck in endless recursion as it seems
WITH RECURSIVE cte AS (
    SELECT "deptId", "numEmpl", "parentId"
    FROM department
    UNION ALL
        SELECT d."deptId", cte."numEmpl", d."parentId"
        FROM cte
        JOIN department d ON cte."parentId" = d."deptId"
)
SELECT cte."deptId", sum(cte."numEmpl")
FROM cte
GROUP BY cte."deptId"
ORDER BY "deptId";



