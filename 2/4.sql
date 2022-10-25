/**
Execute the script department.sql from the moodle course to create the department table.
Write an SQL query returning all department names, the number of employees and the average number of employees of all sister-departments.
Sister departments have the same parent. The number of employees per department should only contain employees that are direct assigned to the specific department.
Therefore,no recursion is required.
**/

SELECT d."deptId", d.name, d."numEmpl", d."parentId", avg(d."numEmpl")
    over(partition by d."parentId") as averageempl
FROM public.department d
order by d."deptId" asc


/**
Creates:
1,Headquarter,10,1,17.2
2,Sales,15,1,17.2
3,Logistics,25,1,17.2
4,F&E,11,1,17.2
5,Marketing,25,1,17.2
6,Basic Research,70,4,116.6666666666666667
7,Field Research,90,4,116.6666666666666667
8,Project Developement,190,4,116.6666666666666667
9,3D Printing,10,8,42.5
10,Software Developemnet,75,8,42.5
11,Direct Sales,7,2,8.5
12,Indirect Sales,10,2,8.5
13,Phone Sales,50,11,37.5
14,Online Sales,25,11,37.5



**/