# Assignment 4
- [ ] Create A DWH
  - [ ] 1.a
  - [ ] 1.b
- [ ] DWH Querying
- [ ] Data Integration
  - [ ] 3.a
  - [ ] 3.b
  - [ ] 3.c
  - [ ] 3.d

    
## Task 1 - Create A DWH
- [ ] Design a suitable DWH schema

Given the required layout for the data as follows ...
```
// The arrow indicates hierarchy levels. 
// The sets contain multiple attributes at the same hierarch level.

Lecturer:
    {Name, Rank (Univ Ass, Postdoc-Ass, Prof, Ass Prof, …), Title (DI, DR,…)} → Department → University
Course:
    {Course, Type (VO, VC, UE,…), ECTS, Level} → Department* → UniversityName
Time**:
    Day → Month → Semester → Year
Student:
    Name
StudyPlan:
    {StudyplanTitle, Degree (Bachelor/Master), Branch (Technical Studies/Economics)}

* A course is assigned to the budget of some department; this is not necessarily the department where the lecturer is assigned.
** For the time dimension: Only fill the dimension table with the dates of actual exams.
*** The level of a course can differ from the level of a student. Students may already take some master’s courses during their bachelor program.
```

... the utilization of a Star Schema makes sense. 
The snow flake schema would benefit the Time Attribute, given the amount of dimensions versus the amount of data held.




- [ ] Load data from the JSON files

## Task 2 - DWH Querying
- [ ] The data should now be shown as a pivot table with the dimensions of student, StudyPlan, and lecturer showing the average grades.
- [ ] Write a query in SQL returning all required data to fill the pivot table and supporting OLAP
operations on the pivot table without issuing an additional query.
- [ ] It is sufficient to only provide the required data in form of an SQL result. You may sketch how the SQL result set relates to the cells of a pivot table. 

## Task 3 - Data Integration
- [ ] Briefly explain the three main phases of Data Integration 
- [ ] Why are Precision and Recall insufficient for assessing matching systems in isolation?
- [ ] Provide an example for a global as view mapping and a local as view mapping for the
following schema: 
```
Global Schema (PK, FK):
Person(id, givenName, lastName, job, age)

Local Schema (PK, FK):
MyPerson(svnr, givenName, lastName, age)
MyPobs (svnr,jobtitle)
```
- [ ] Discuss the benefits and drawbacks of local as view vs global as view regarding
rewriting complexity, change of data sources, and constraints over data sources.

