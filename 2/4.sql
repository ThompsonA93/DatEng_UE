/**
Execute the script department.sql from the moodle course to create the department table.

Write an SQL query returning all department names, the number of employees and the max
number of employees of any sister-department. Sister departments have the same parent.
The number of employees per department should only contain employees that are direct
assigned to the specific department. Therefore, no recursion is required.
**/


-- See https://www.geeksforgeeks.org/mysql-partition-by-clause/
-- Window functions: sum, count, avg, max, ...
-- Partition by narrows entire dataset to individual groups within the dataset
-- Over() clause defines how to partition and order rows of table, which is to be processed by window function.
SELECT d."deptId", d.name, d."numEmpl", d."parentId", max(d."numEmpl")
    over(partition by d."parentId") as max_employees -- Assuming: The maximum amount of employees per main department??
FROM public.department d
order by d."deptId" asc