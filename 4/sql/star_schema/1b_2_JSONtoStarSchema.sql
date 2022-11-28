/** 1b_2_JSONtoStarSchema.sql **/
/** Required Fields: **/
-- Corses: courseid, course, type, ects, level, department,
-- Metadata: universityname

-- Selection from metadata
SELECT
    aau_metadata.data->'name'
FROM json_aau_metadata as aau_metadata;


-- Selection from master corses
SELECT
    master_data->>'id' id,
    master_data->>'title' title,
    master_data->>'type' "type",
    master_data->>'lecturer' lecturer,
    master_data->>'ECTS' ects,
    master_data->>'department' department
FROM json_aau_corses as masters,
    jsonb_array_elements(masters.data->'master') master_data;


-- Select Levels for each course
SELECT
    jsonb_object_keys(corses.data) as "Level"
FROM json_aau_corses as corses;


-- Merge previous statements and insert into course table
-- INSERT INTO course(courseid, course, "Type", ects, "Level", department, universityname)
-- Select Levels for each course
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
INSERT INTO course(
    courseid, course, "Type", ects, "Level", department, universityname
)
SELECT
    course_data->>'id' id,
    course_data->>'title' title,
    course_data->>'type' "type",
--    course_data->>'ECTS' ects,
    CAST(course_data->>'ECTS' AS INT),
    levels,
    course_data->>'department' department,
    metadata.data->'name' "universityname"
FROM json_aau_corses as courses,
     json_aau_metadata as metadata,
     jsonb_object_keys(courses.data) as levels,
     jsonb_array_elements(courses.data->levels) course_data;