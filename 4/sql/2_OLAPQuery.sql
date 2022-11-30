-- Test-Query: Basic Joins (not olap)
SELECT g.grade, s."Name", l."Name", c.course, t."Year"
FROM grades g
JOIN lecturer l on g.lecturerkey = l.lecturerid
JOIN course c on g.coursekey = c.courseid
JOIN time t on g.timekey = t.timeid
JOIN student s on g.studentkey = s.studentid
JOIN studyplan s2 on g.studyplankey = s2.studyplanid;

-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-cube/
-- Test-Query: Attempt building Pivot Table #1
SELECT avg(g.grade) as "avg_grade", s."Name" as "studentname", l."Name" as "lecturername", s2.studyplantitle
FROM grades g
JOIN lecturer l on g.lecturerkey = l.lecturerid
JOIN student s on g.studentkey = s.studentid
JOIN studyplan s2 on g.studyplankey = s2.studyplanid
GROUP BY CUBE(s."Name", l."Name", s2.studyplantitle);

-- Test-Query: Attempt building Pivot Table using GROUPING SETS
-- FIXME not sure if the average, semantically, makes any sense
SELECT avg(g.grade) as "avg_grade", s."Name" as "studentname", l."Name" as "lecturername", s2.studyplantitle
FROM grades g
JOIN lecturer l on g.lecturerkey = l.lecturerid
JOIN student s on g.studentkey = s.studentid
JOIN studyplan s2 on g.studyplankey = s2.studyplanid
GROUP BY GROUPING SETS (    -- Expect 2^n sets, where n = studentname, lecturername, studyplantitle at most. Group  together whatever makes sense
    (s."Name"),
    (l."Name"),
    (s2.studyplantitle),
    (s."Name", l."Name", s2.studyplantitle)
);

-- Test-Query: Build a real fucking massive table
-- Nicely views as results what is being queried over the grouping sets
SELECT avg(g.grade) as "avg_grade",
       s.studentid, s."Name",
       l.lecturerid, l."Name", l.rank, l.title, l.university,
       s2.studyplanid, s2.studyplantitle, s2.branch, s2.degree
FROM grades g
JOIN lecturer l on g.lecturerkey = l.lecturerid
JOIN student s on g.studentkey = s.studentid
JOIN studyplan s2 on g.studyplankey = s2.studyplanid
GROUP BY GROUPING SETS (
    (s.studentid, s."Name"), (s.studentid),
    (l.lecturerid, l."Name", l.rank, l.title, l.university), (l.lecturerid, l."Name", l.rank, l.title), (l.lecturerid, l."Name", l.rank), (l.lecturerid, l."Name"), (l.lecturerid),
    (s2.studyplanid, s2.studyplantitle, s2.branch, s2.degree), (s2.studyplanid, s2.studyplantitle, s2.branch), (s2.studyplanid, s2.studyplantitle), (s2.studyplanid),
    (s."Name", l."Name", s2.studyplantitle)
)
