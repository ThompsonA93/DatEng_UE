/**
Create a query that returns the total number of people employed in each department including all employees of its sub-departments.
  **/
with recursive employeecount(deptId, name, parentId, numEmpl) as
    (
        select d."deptId", name, "parentId", "numEmpl" from department d where "deptId"=1
        union
        select dd."deptId", dd.name, dd."parentId", dd."numEmpl" from department dd, employeecount ec where dd."parentId"=ec.deptId
    ) select sum(employeecount.numEmpl) from employeecount;

