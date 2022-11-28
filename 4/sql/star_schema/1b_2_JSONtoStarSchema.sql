/** 1b_2_JSONtoStarSchema.sql **/
/*************/
/** COURSES **/
/*************/
-- Fetch data from:
--  Corses: courseid, course, type, ects, level, department,
--  Metadata: universityname

-- 1. Testselection from metadata
SELECT
    aau_metadata.data->'name'
FROM json_aau_metadata as aau_metadata;


-- 2. Testselection from master corses
SELECT
    master_data->>'id' id,
    master_data->>'title' title,
    master_data->>'type' "type",
    master_data->>'lecturer' lecturer,
    master_data->>'ECTS' ects,
    master_data->>'department' department
FROM json_aau_corses as masters,
    jsonb_array_elements(masters.data->'master') master_data;


-- 3. Testselect Levels for each course
SELECT
    jsonb_object_keys(corses.data) as "Level"
FROM json_aau_corses as corses;

-- 4. HOW NOT TO SELECT
SELECT
    master_data->>'id' id,
    master_data->>'title' title,
    master_data->>'type' "type",
    master_data->>'ECTS' ects,
    jsonb_object_keys(masters.data) "level",
    master_data->>'department' department,
    metadata.data->'name' "universityname"
FROM json_aau_corses as masters,
     json_aau_metadata as metadata,
    jsonb_array_elements(masters.data->'master') master_data;

/*
INSERT INTO course(
    courseid, course, "Type", ects, "Level", department, universityname
)
*/
-- SELECT ALL DATA AND INSERT INTO COURSES
INSERT INTO course(
    courseid, course, "Type", ects, "Level", department, universityname
)
SELECT
    course_data->>'id' id,
    course_data->>'title' title,
    course_data->>'type' "type",
    CAST(course_data->>'ECTS' AS INT),  -- Cast from Text to Int necessary
    levels,
    course_data->>'department' department,
    metadata.data->'name' "universityname"
FROM json_aau_corses as courses,
     json_aau_metadata as metadata,
     jsonb_object_keys(courses.data) as levels,
     jsonb_array_elements(courses.data->levels) course_data;


/*
INSERT INTO lecturer(
    lecturerid, "Name", rank, title, department, university
)
*/
SELECT
    lecturer_data->>'id' id,
--    lecturer_data->>'name' "name",
    split_part(lecturer_data->>'name',' ','1') "rank",
    split_part(lecturer_data->>'name',' ','2') "title",
    split_part(lecturer_data->>'name',' ','3') "Name",
    lecturer_data->>'department' department,
    metadata.data->>'name' university
FROM json_aau_metadata as metadata,
     jsonb_array_elements(metadata.data->'lecturers') lecturer_data;

-- FIXME
-- @Require String separation for Title
SELECT
    split_part(lecturer_data->>'name',' ','1') "rank",
    substring(lecturer_data->>'name' FROM '(Dr.)') "title",
    substring(lecturer_data->>'name' FROM '\w+ \w+') "name"
FROM json_aau_metadata as metadata,
     jsonb_array_elements(metadata.data->'lecturers') lecturer_data;
