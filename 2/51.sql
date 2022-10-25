/**
Create a recursive SQL query that returns the name and number of employees of all F\&E departments(F\&E department and all its descendants).
**/


with recursive employeeoverview(deptId, name, parentId, numEmpl) as
    (
        select d."deptId", d.name, d."parentId", d."numEmpl" from department d where d.name='F&E'
        union
        select dd."deptId", dd.name, dd."parentId", dd."numEmpl" from department dd, employeeoverview eo where dd."parentId" = eo.deptId
    ) select * from employeeoverview;


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