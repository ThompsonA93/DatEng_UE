/** 1b_JSQONImport.sql **/
-- Imports Corses & Metadata
DROP TABLE IF EXISTS json_aau_corses;
DROP TABLE IF EXISTS json_aau_metadata;

/* -- Just failed & kept failing
[2022-11-23 09:57:43] [22P02] ERROR: invalid input syntax for type json
[2022-11-23 09:57:43] Detail: The input string ended unexpectedly.
[2022-11-23 09:57:43] Where: JSON data, line 1: {
[2022-11-23 09:57:43] COPY json_aau_corses, line 1, column data: "{"
*/
CREATE TABLE json_aau_corses(
    data jsonb
);

CREATE TABLE json_aau_metadata(
    data jsonb
);


COPY json_aau_corses FROM '/home/thompson/Projects/DatEng_UE/4/aau/aau_corses.json';
COPY json_aau_metadata FROM '/home/thompson/Projects/DatEng_UE/4/aau/aau_metadata.json';

/*
-- https://blog.sqlizer.io/posts/convert-json-to-sql/ ; honestly doesn't look correct
CREATE TABLE IF NOT EXISTS json_aau_corses (
    "bachelor_id" NUMERIC(6, 3),
    "bachelor_title" TEXT,
    "bachelor_type" TEXT,
    "bachelor_lecturer" INT,
    "bachelor_ECTS" INT,
    "bachelor_department" TEXT,
    "master_id" NUMERIC(6, 3),
    "master_title" TEXT,
    "master_type" TEXT,
    "master_lecturer" INT,
    "master_department" TEXT,
    "master_ECTS" INT
);

INSERT INTO json_aau_corses VALUES
    (620.220,'Einführung in die strukturierte und objektbasierte Programmierung','VO',36866626,2,'ITEC',NULL,NULL,NULL,NULL,NULL,NULL),
    (621.900,'Web-Technologien','VO',772243224,2,'ISYS',NULL,NULL,NULL,NULL,NULL,NULL),
    (620.050,'Datenbanken','VO',772243224,2,'ISYS',NULL,NULL,NULL,NULL,NULL,NULL),
    (620.050,'Datenbanktechnologie','UE',772243224,2,'ISYS',NULL,NULL,NULL,NULL,NULL,NULL),
    (NULL,NULL,NULL,NULL,NULL,NULL,623.254,'Current Topics in Information Systems Engineering','VC',772243224,'AINF',3),
    (NULL,NULL,NULL,NULL,NULL,NULL,624.002,'Privatissimum für Diplomand/inn/en und Dissertant/inn/en','PV',772243224,'ISYS',1),
    (NULL,NULL,NULL,NULL,NULL,NULL,623.250,'Interoperability','VC',772243224,'ISYS',4),
    (NULL,NULL,NULL,NULL,NULL,NULL,623.500,'Data Engineering','VC',772243224,'ISYS',4),
    (NULL,NULL,NULL,NULL,NULL,NULL,623.502,'Distributed Computing Infrastructures','VC',2077308266,'ITEC',4),
    (NULL,NULL,NULL,NULL,NULL,NULL,623.252,'Process Engineering','VC',834107405,'ISYS',2);

CREATE TABLE IF NOT EXISTS json_aau_metadata (
    "id" TEXT,
    "name" TEXT,
    "state" TEXT,
    "city" TEXT,
    "street" TEXT,
    "zip" INT,
    "bachelor_study_plans_id" INT,
    "bachelor_study_plans_name" TEXT,
    "bachelor_study_plans_branch" TEXT,
    "master_study_plans_id" INT,
    "master_study_plans_name" TEXT,
    "master_study_plans_type" TEXT,
    "master_study_plans_branch" TEXT,
    "lecturers_id" INT,
    "lecturers_name" TEXT,
    "lecturers_department" TEXT
);

INSERT INTO json_aau_metadata VALUES
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,511,'Angewandte Informatik','Technical Studies',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,522,'Wirtschaftsinformatik','Economoics',NULL,NULL,NULL,NULL,NULL,NULL,NULL),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,922,'Wirtschaftsinformatik','Master','Economics',NULL,NULL,NULL),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,911,'Angewandte Informatik','Master','Technical Studies',NULL,NULL,NULL),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36866626,'Assoc.Prof. Dipl.-Ing. Dr. Klaus Schöffmann','ITEC'),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2077308266,'Postdoc-Ass. Dr. Dragi Kimovski','ITEC'),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,NULL,NULL,NULL,NULL,834107405,'O.Univ.-Prof. Dipl.-Ing. Dr. Johann Eder ','ISYS'),
    ('ATEOS1000019137','Alpen-Adria-Universität Klagenfurt','Carinthia','Klagenfurt am Wörthersee','Universitätsstraße 65-67',9020,NULL,NULL,NULL,NULL,NULL,NULL,NULL,772243224,'Assoc.-Prof. DI. Dr. Julius Köpke','ISYS');

*/