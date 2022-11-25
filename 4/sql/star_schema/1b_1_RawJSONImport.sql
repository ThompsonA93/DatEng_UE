/** 1b_1_RawJSONImport.sql **/
/*
-- Take 1: Copy x From
-- Errors out:
[2022-11-23 09:57:43] [22P02] ERROR: invalid input syntax for type json
[2022-11-23 09:57:43] Detail: The input string ended unexpectedly.
[2022-11-23 09:57:43] Where: JSON data, line 1: {
[2022-11-23 09:57:43] COPY json_aau_corses, line 1, column data: "{"

DROP TABLE IF EXISTS json_aau_corses;
DROP TABLE IF EXISTS json_aau_metadata;
CREATE TABLE json_aau_corses(
    data jsonb
);
CREATE TABLE json_aau_metadata(
    data jsonb
);
COPY json_aau_corses FROM '/home/thompson/Projects/DatEng_UE/4/aau/aau_corses.json';
COPY json_aau_metadata FROM '/home/thompson/Projects/DatEng_UE/4/aau/aau_metadata.json';
*/

/*
-- Take 2: SQLify
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

-- Take 3: Refactoring data to CSV and import as such
-- Elaborated via README.md and directory aau_csv_refactored

-- Take 4: Manual copy from and insert values
DROP TABLE IF EXISTS json_aau_corses;
DROP TABLE IF EXISTS json_aau_metadata;
DROP TABLE IF EXISTS json_aau_resultlist;

CREATE TABLE json_aau_corses(
    data jsonb
);
CREATE TABLE json_aau_metadata(
    data jsonb
);
CREATE TABLE json_aau_resultlist(
    data jsonb
);

INSERT INTO json_aau_corses VALUES(
'{
  "bachelor": [
    {
      "id": "620.220",
      "title": "Einführung in die strukturierte und objektbasierte Programmierung",
      "type": "VO",
      "lecturer": "36866626",
      "ECTS": "2",
      "department": "ITEC"
    },
    {
      "id": "621.900",
      "title": "Web-Technologien",
      "type": "VO",
      "lecturer": "772243224",
      "ECTS": "2",
      "department": "ISYS"
    },
    {
      "id": "620.050",
      "title": "Datenbanken",
      "type": "VO",
      "lecturer": "772243224",
      "ECTS": "2",
      "department": "ISYS"
    },
    {
      "id": "620.050",
      "title": "Datenbanktechnologie",
      "type": "UE",
      "lecturer": "772243224",
      "ECTS": "2",
      "department": "ISYS"
    }
  ],
  "master": [
    {
      "id": "623.254",
      "title": "Current Topics in Information Systems Engineering",
      "type": "VC",
      "lecturer": "772243224",
      "department": "AINF",
      "ECTS": "3"
    },
    {
      "id": "624.002",
      "title": "Privatissimum für Diplomand/inn/en und Dissertant/inn/en",
      "type": "PV",
      "lecturer": "772243224",
      "department": "ISYS",
      "ECTS": "1"
    },
    {
      "id": "623.250",
      "title": "Interoperability",
      "type": "VC",
      "lecturer": "772243224",
      "department": "ISYS",
      "ECTS": "4"
    },
    {
      "id": "623.500",
      "title": "Data Engineering",
      "type": "VC",
      "lecturer": "772243224",
      "department": "ISYS",
      "ECTS": "4"
    },
    {
      "id": "623.502",
      "title": "Distributed Computing Infrastructures",
      "type": "VC",
      "lecturer": "2077308266",
      "department": "ITEC",
      "ECTS": "4"
    },
    {
      "id": "623.252",
      "title": "Process Engineering",
      "type": "VC",
      "lecturer": "834107405",
      "department": "ISYS",
      "ECTS": "2"
    }
  ]
}'
);

INSERT INTO json_aau_metadata VALUES(
'{
  "id": "ATEOS1000019137",
  "name": "Alpen-Adria-Universität Klagenfurt",
  "state": "Carinthia",
  "city": "Klagenfurt am Wörthersee",
  "street": "Universitätsstraße 65-67",
  "zip": "9020",
  "bachelor_study_plans": [
    {
      "id": "511",
      "name": "Angewandte Informatik",
      "branch": "Technical Studies"
    },
    {
      "id": "522",
      "name": "Wirtschaftsinformatik",
      "branch": "Economoics"
    }
  ],
  "master_study_plans": [
    {
      "id": "922",
      "name": "Wirtschaftsinformatik",
      "type": "Master",
      "branch": "Economics"
    },
    {
      "id": "911",
      "name": "Angewandte Informatik",
      "type": "Master",
      "branch": "Technical Studies"
    }
  ],
  "lecturers": [
    {
      "id": "36866626",
      "name": "Assoc.Prof. Dipl.-Ing. Dr. Klaus Schöffmann",
      "department": "ITEC"
    },
    {
      "id": "2077308266",
      "name": "Postdoc-Ass. Dr. Dragi Kimovski",
      "department": "ITEC"
    },
    {
      "id": "834107405",
      "name": "O.Univ.-Prof. Dipl.-Ing. Dr. Johann Eder ",
      "department": "ISYS"
    },
    {
      "id": "772243224",
      "name": "Assoc.-Prof. DI. Dr. Julius Köpke",
      "department": "ISYS"
    }
  ]
}'
);

-- Blockchains
INSERT INTO json_aau_resultlist VALUES(
'{
  "course": "623.254",
  "examinator": "772243224",
  "date": "2022-06-24",
  "results": [
    {
      "matno": "9000078",
      "name": "Sara Groß",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000079",
      "name": "Lara Seidel",
      "grade": "1",
      "studyplan": "922"
    },
    {
      "matno": "9000082",
      "name": "Sofie Haas",
      "grade": "3",
      "studyplan": "911"
    },
    {
      "matno": "9000083",
      "name": "Sophia Schreiber",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000086",
      "name": "Nele Dietrich",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000087",
      "name": "Neele Ziegler",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000090",
      "name": "Maya Pohl",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000091",
      "name": "Amelie Engel",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000094",
      "name": "Lucas Bergmann",
      "grade": "5",
      "studyplan": "911"
    },
    {
      "matno": "9000095",
      "name": "Lukas Thomas",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000098",
      "name": "Luka Arnold",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000099",
      "name": "Paul Wolff",
      "grade": "1",
      "studyplan": "922"
    },
    {
      "matno": "9000080",
      "name": "Laura Heinrich",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000081",
      "name": "Sophie Brandt",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000084",
      "name": "Sofia Graf",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000085",
      "name": "Lina Schulte",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000088",
      "name": "Johanna Kuhn",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000089",
      "name": "Maja Kühn",
      "grade": "2",
      "studyplan": "522"
    }
  ]
}'
);

-- Data Engineering.
INSERT INTO json_aau_resultlist VALUES(
'{
  "course": "623.500",
  "examinator": "772243224",
  "date": "2022-02-01",
  "results": [
    {
      "matno": "9000019",
      "name": "Laura Schwarz",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000022",
      "name": "Sophia Krüger",
      "grade": "3",
      "studyplan": "911"
    },
    {
      "matno": "9000023",
      "name": "Sofia Hofmann",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000026",
      "name": "Neele Schmitt",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000027",
      "name": "Johanna Werner",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000030",
      "name": "Amelie Meier",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000031",
      "name": "Amely Lehmann",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000034",
      "name": "Lukas Maier",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000035",
      "name": "Jonas Köhler",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000038",
      "name": "Paul Walter",
      "grade": "3",
      "studyplan": "911"
    },
    {
      "matno": "9000039",
      "name": "Felix Mayer",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000042",
      "name": "Fynn Fuchs",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000043",
      "name": "Tim Peters",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000046",
      "name": "Luis Möller",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000047",
      "name": "Louis Weiß",
      "grade": "5",
      "studyplan": "922"
    },
    {
      "matno": "9000050",
      "name": "Elias Schubert",
      "grade": "3",
      "studyplan": "911"
    },
    {
      "matno": "9000051",
      "name": "Niclas Vogel",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000054",
      "name": "Jan Günther",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000055",
      "name": "Philip Frank",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000058",
      "name": "Moritz Roth",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000059",
      "name": "Jannik Beck",
      "grade": "3",
      "studyplan": "922"
    },
    {
      "matno": "9000062",
      "name": "Hannah Franke",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000063",
      "name": "Hanna Albrecht",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000066",
      "name": "Lena Ludwig",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000067",
      "name": "Lea Böhm",
      "grade": "4",
      "studyplan": "922"
    },
    {
      "matno": "9000070",
      "name": "Emma Martin",
      "grade": "2",
      "studyplan": "911"
    },
    {
      "matno": "9000071",
      "name": "Emily Schumacher",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000074",
      "name": "Lilli Stein",
      "grade": "1",
      "studyplan": "911"
    },
    {
      "matno": "9000075",
      "name": "Lilly Jäger",
      "grade": "2",
      "studyplan": "922"
    },
    {
      "matno": "9000078",
      "name": "Sara Groß",
      "grade": "1",
      "studyplan": "911"
    }
  ]
}'
);

-- Data banks
INSERT INTO json_aau_resultlist VALUES(
'{
  "course": "620.050",
  "examinator": "772243224",
  "date": "2022-02-03",
  "results": [
    {
      "matno": "9000001",
      "name": "Hannah Müller",
      "grade": "4",
      "studyplan": "522"
    },
    {
      "matno": "9000004",
      "name": "Leonie Fischer",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000005",
      "name": "Lena Weber",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000008",
      "name": "Anna Becker",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000009",
      "name": "Emma Schulz",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000012",
      "name": "Marie Koch",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000013",
      "name": "Lilli Bauer",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000016",
      "name": "Sarah Wolf",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000017",
      "name": "Sara Schröder",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000020",
      "name": "Sophie Zimmermann",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000021",
      "name": "Sofie Braun",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000024",
      "name": "Lina Hartmann",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000025",
      "name": "Nele Lange",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000028",
      "name": "Maja Schmitz",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000029",
      "name": "Maya Krause",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000032",
      "name": "Leon Schmid",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000033",
      "name": "Lucas Schulze",
      "grade": "4",
      "studyplan": "522"
    },
    {
      "matno": "9000036",
      "name": "Luca Herrmann",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000037",
      "name": "Luka König",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000040",
      "name": "Maximilian Huber",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000041",
      "name": "Finn Kaiser",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000044",
      "name": "Timm Lang",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000045",
      "name": "Ben Scholz",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000048",
      "name": "Max Jung",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000049",
      "name": "Julian Hahn",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000052",
      "name": "Niklas Friedrich",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000053",
      "name": "Noah Keller",
      "grade": "4",
      "studyplan": "522"
    },
    {
      "matno": "9000056",
      "name": "Philipp Berger",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000057",
      "name": "Phillip Winkler",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000060",
      "name": "Yannick Lorenz",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000061",
      "name": "Mia Baumann",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000064",
      "name": "Leoni Schuster",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000065",
      "name": "Leonie Simon",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000068",
      "name": "Leah Winter",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000069",
      "name": "Anna Kraus",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000072",
      "name": "Emilie Krämer",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000073",
      "name": "Marie Vogt",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000076",
      "name": "Lili Otto",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000077",
      "name": "Sarah Sommer",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000080",
      "name": "Laura Heinrich",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000081",
      "name": "Sophie Brandt",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000084",
      "name": "Sofia Graf",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000085",
      "name": "Lina Schulte",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000088",
      "name": "Johanna Kuhn",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000089",
      "name": "Maja Kühn",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000092",
      "name": "Amely Horn",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000093",
      "name": "Leon Busch",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000096",
      "name": "Jonas Voigt",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000097",
      "name": "Luca Sauer",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000100",
      "name": "Felix Pfeiffer",
      "grade": "1",
      "studyplan": "511"
    }
  ]
}'
);

-- ESOP
INSERT INTO json_aau_resultlist VALUES(
'{
  "course": "620.220",
  "examinator": "36866626",
  "date": "2022-02-03",
  "results": [
    {
      "matno": "9000001",
      "name": "Hannah Müller",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000004",
      "name": "Leonie Fischer",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000005",
      "name": "Lena Weber",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000008",
      "name": "Anna Becker",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000009",
      "name": "Emma Schulz",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000012",
      "name": "Marie Koch",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000013",
      "name": "Lilli Bauer",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000016",
      "name": "Sarah Wolf",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000017",
      "name": "Sara Schröder",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000020",
      "name": "Sophie Zimmermann",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000021",
      "name": "Sofie Braun",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000024",
      "name": "Lina Hartmann",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000025",
      "name": "Nele Lange",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000028",
      "name": "Maja Schmitz",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000029",
      "name": "Maya Krause",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000032",
      "name": "Leon Schmid",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000033",
      "name": "Lucas Schulze",
      "grade": "4",
      "studyplan": "522"
    },
    {
      "matno": "9000036",
      "name": "Luca Herrmann",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000037",
      "name": "Luka König",
      "grade": "5",
      "studyplan": "522"
    },
    {
      "matno": "9000040",
      "name": "Maximilian Huber",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000041",
      "name": "Finn Kaiser",
      "grade": "5",
      "studyplan": "522"
    },
    {
      "matno": "9000044",
      "name": "Timm Lang",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000045",
      "name": "Ben Scholz",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000048",
      "name": "Max Jung",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000049",
      "name": "Julian Hahn",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000052",
      "name": "Niklas Friedrich",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000053",
      "name": "Noah Keller",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000056",
      "name": "Philipp Berger",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000057",
      "name": "Phillip Winkler",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000060",
      "name": "Yannick Lorenz",
      "grade": "1",
      "studyplan": "511"
    },
    {
      "matno": "9000061",
      "name": "Mia Baumann",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000064",
      "name": "Leoni Schuster",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000065",
      "name": "Leonie Simon",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000068",
      "name": "Leah Winter",
      "grade": "2",
      "studyplan": "511"
    },
    {
      "matno": "9000069",
      "name": "Anna Kraus",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000072",
      "name": "Emilie Krämer",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000073",
      "name": "Marie Vogt",
      "grade": "3",
      "studyplan": "522"
    },
    {
      "matno": "9000076",
      "name": "Lili Otto",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000077",
      "name": "Sarah Sommer",
      "grade": "1",
      "studyplan": "522"
    },
    {
      "matno": "9000080",
      "name": "Laura Heinrich",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000081",
      "name": "Sophie Brandt",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000084",
      "name": "Sofia Graf",
      "grade": "5",
      "studyplan": "511"
    },
    {
      "matno": "9000085",
      "name": "Lina Schulte",
      "grade": "2",
      "studyplan": "522"
    },
    {
      "matno": "9000088",
      "name": "Johanna Kuhn",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000089",
      "name": "Maja Kühn",
      "grade": "5",
      "studyplan": "522"
    },
    {
      "matno": "9000092",
      "name": "Amely Horn",
      "grade": "3",
      "studyplan": "511"
    },
    {
      "matno": "9000093",
      "name": "Leon Busch",
      "grade": "5",
      "studyplan": "522"
    },
    {
      "matno": "9000096",
      "name": "Jonas Voigt",
      "grade": "4",
      "studyplan": "511"
    },
    {
      "matno": "9000097",
      "name": "Luca Sauer",
      "grade": "4",
      "studyplan": "522"
    },
    {
      "matno": "9000100",
      "name": "Felix Pfeiffer",
      "grade": "2",
      "studyplan": "511"
    }
  ]
}'
);

-- INTEROP
INSERT INTO json_aau_resultlist VALUES(
'{
	"course": "623.250",
	"examinator": "772243224",
	"date": "2022-01-25",
	"results": [
		{
			"matno": "9000002",
			"name": "Hanna Schmidt",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000003",
			"name": "Leoni Schneider",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000006",
			"name": "Lea Meyer",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000007",
			"name": "Leah Wagner",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000010",
			"name": "Emily Hoffmann",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000011",
			"name": "Emilie Schäfer",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000014",
			"name": "Lilly Richter",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000015",
			"name": "Lili Klein",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000018",
			"name": "Lara Neumann",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000019",
			"name": "Laura Schwarz",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000022",
			"name": "Sophia Krüger",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000023",
			"name": "Sofia Hofmann",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000026",
			"name": "Neele Schmitt",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000027",
			"name": "Johanna Werner",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000030",
			"name": "Amelie Meier",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000031",
			"name": "Amely Lehmann",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000034",
			"name": "Lukas Maier",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000035",
			"name": "Jonas Köhler",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000038",
			"name": "Paul Walter",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000039",
			"name": "Felix Mayer",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000042",
			"name": "Fynn Fuchs",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000043",
			"name": "Tim Peters",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000046",
			"name": "Luis Möller",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000047",
			"name": "Louis Weiß",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000050",
			"name": "Elias Schubert",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000051",
			"name": "Niclas Vogel",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000054",
			"name": "Jan Günther",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000055",
			"name": "Philip Frank",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000058",
			"name": "Moritz Roth",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000059",
			"name": "Jannik Beck",
			"grade": "2",
			"studyplan": "922"
		}
	]
}'
);

-- Parallel
INSERT INTO json_aau_resultlist VALUES(
'{
	"course": "623.502",
	"examinator": "2077308266",
	"date": "2022-02-02",
	"results": [
		{
			"matno": "9000023",
			"name": "Sofia Hofmann",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000026",
			"name": "Neele Schmitt",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000027",
			"name": "Johanna Werner",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000030",
			"name": "Amelie Meier",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000031",
			"name": "Amely Lehmann",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000034",
			"name": "Lukas Maier",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000035",
			"name": "Jonas Köhler",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000038",
			"name": "Paul Walter",
			"grade": "5",
			"studyplan": "911"
		},
		{
			"matno": "9000039",
			"name": "Felix Mayer",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000042",
			"name": "Fynn Fuchs",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000043",
			"name": "Tim Peters",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000046",
			"name": "Luis Möller",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000047",
			"name": "Louis Weiß",
			"grade": "4",
			"studyplan": "922"
		},
		{
			"matno": "9000050",
			"name": "Elias Schubert",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000051",
			"name": "Niclas Vogel",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000054",
			"name": "Jan Günther",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000055",
			"name": "Philip Frank",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000058",
			"name": "Moritz Roth",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000059",
			"name": "Jannik Beck",
			"grade": "4",
			"studyplan": "922"
		},
		{
			"matno": "9000062",
			"name": "Hannah Franke",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000063",
			"name": "Hanna Albrecht",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000066",
			"name": "Lena Ludwig",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000067",
			"name": "Lea Böhm",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000070",
			"name": "Emma Martin",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000071",
			"name": "Emily Schumacher",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000074",
			"name": "Lilli Stein",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000075",
			"name": "Lilly Jäger",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000078",
			"name": "Sara Groß",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000079",
			"name": "Lara Seidel",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000082",
			"name": "Sofie Haas",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000083",
			"name": "Sophia Schreiber",
			"grade": "4",
			"studyplan": "922"
		}
	]
}'
);

-- Process Engineering
INSERT INTO json_aau_resultlist VALUES(
'{
	"course": "623.252",
	"examinator": "834107405",
	"date": "2022-02-01",
	"results": [
		{
			"matno": "9000046",
			"name": "Luis Möller",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000047",
			"name": "Louis Weiß",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000050",
			"name": "Elias Schubert",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000051",
			"name": "Niclas Vogel",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000054",
			"name": "Jan Günther",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000055",
			"name": "Philip Frank",
			"grade": "4",
			"studyplan": "922"
		},
		{
			"matno": "9000058",
			"name": "Moritz Roth",
			"grade": "1",
			"studyplan": "911"
		},
		{
			"matno": "9000059",
			"name": "Jannik Beck",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000062",
			"name": "Hannah Franke",
			"grade": "5",
			"studyplan": "911"
		},
		{
			"matno": "9000063",
			"name": "Hanna Albrecht",
			"grade": "2",
			"studyplan": "922"
		},
		{
			"matno": "9000066",
			"name": "Lena Ludwig",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000067",
			"name": "Lea Böhm",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000070",
			"name": "Emma Martin",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000071",
			"name": "Emily Schumacher",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000074",
			"name": "Lilli Stein",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000075",
			"name": "Lilly Jäger",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000078",
			"name": "Sara Groß",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000079",
			"name": "Lara Seidel",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000082",
			"name": "Sofie Haas",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000083",
			"name": "Sophia Schreiber",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000086",
			"name": "Nele Dietrich",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000087",
			"name": "Neele Ziegler",
			"grade": "1",
			"studyplan": "922"
		},
		{
			"matno": "9000090",
			"name": "Maya Pohl",
			"grade": "4",
			"studyplan": "911"
		},
		{
			"matno": "9000091",
			"name": "Amelie Engel",
			"grade": "5",
			"studyplan": "922"
		},
		{
			"matno": "9000094",
			"name": "Lucas Bergmann",
			"grade": "2",
			"studyplan": "911"
		},
		{
			"matno": "9000095",
			"name": "Lukas Thomas",
			"grade": "3",
			"studyplan": "922"
		},
		{
			"matno": "9000098",
			"name": "Luka Arnold",
			"grade": "3",
			"studyplan": "911"
		},
		{
			"matno": "9000099",
			"name": "Paul Wolff",
			"grade": "2",
			"studyplan": "922"
		}
	]
}'
);

-- Webtech
INSERT INTO json_aau_resultlist VALUES(
'{
	"course": "621.900",
	"examinator": "772243224",
	"date": "2022-01-25",
	"results": [
		{
			"matno": "9000001",
			"name": "Hannah Müller",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000004",
			"name": "Leonie Fischer",
			"grade": "4",
			"studyplan": "511"
		},
		{
			"matno": "9000005",
			"name": "Lena Weber",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000008",
			"name": "Anna Becker",
			"grade": "1",
			"studyplan": "511"
		},
		{
			"matno": "9000009",
			"name": "Emma Schulz",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000012",
			"name": "Marie Koch",
			"grade": "2",
			"studyplan": "511"
		},
		{
			"matno": "9000013",
			"name": "Lilli Bauer",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000016",
			"name": "Sarah Wolf",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000017",
			"name": "Sara Schröder",
			"grade": "5",
			"studyplan": "522"
		},
		{
			"matno": "9000020",
			"name": "Sophie Zimmermann",
			"grade": "3",
			"studyplan": "511"
		},
		{
			"matno": "9000021",
			"name": "Sofie Braun",
			"grade": "5",
			"studyplan": "522"
		},
		{
			"matno": "9000024",
			"name": "Lina Hartmann",
			"grade": "2",
			"studyplan": "511"
		},
		{
			"matno": "9000025",
			"name": "Nele Lange",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000028",
			"name": "Maja Schmitz",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000029",
			"name": "Maya Krause",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000032",
			"name": "Leon Schmid",
			"grade": "1",
			"studyplan": "511"
		},
		{
			"matno": "9000033",
			"name": "Lucas Schulze",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000036",
			"name": "Luca Herrmann",
			"grade": "2",
			"studyplan": "511"
		},
		{
			"matno": "9000037",
			"name": "Luka König",
			"grade": "4",
			"studyplan": "522"
		},
		{
			"matno": "9000040",
			"name": "Maximilian Huber",
			"grade": "3",
			"studyplan": "511"
		},
		{
			"matno": "9000041",
			"name": "Finn Kaiser",
			"grade": "3",
			"studyplan": "522"
		},
		{
			"matno": "9000044",
			"name": "Timm Lang",
			"grade": "3",
			"studyplan": "511"
		},
		{
			"matno": "9000045",
			"name": "Ben Scholz",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000048",
			"name": "Max Jung",
			"grade": "2",
			"studyplan": "511"
		},
		{
			"matno": "9000049",
			"name": "Julian Hahn",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000052",
			"name": "Niklas Friedrich",
			"grade": "2",
			"studyplan": "511"
		},
		{
			"matno": "9000053",
			"name": "Noah Keller",
			"grade": "5",
			"studyplan": "522"
		},
		{
			"matno": "9000056",
			"name": "Philipp Berger",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000057",
			"name": "Phillip Winkler",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000060",
			"name": "Yannick Lorenz",
			"grade": "3",
			"studyplan": "511"
		},
		{
			"matno": "9000061",
			"name": "Mia Baumann",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000064",
			"name": "Leoni Schuster",
			"grade": "4",
			"studyplan": "511"
		},
		{
			"matno": "9000065",
			"name": "Leonie Simon",
			"grade": "4",
			"studyplan": "522"
		},
		{
			"matno": "9000068",
			"name": "Leah Winter",
			"grade": "1",
			"studyplan": "511"
		},
		{
			"matno": "9000069",
			"name": "Anna Kraus",
			"grade": "4",
			"studyplan": "522"
		},
		{
			"matno": "9000072",
			"name": "Emilie Krämer",
			"grade": "1",
			"studyplan": "511"
		},
		{
			"matno": "9000073",
			"name": "Marie Vogt",
			"grade": "5",
			"studyplan": "522"
		},
		{
			"matno": "9000076",
			"name": "Lili Otto",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000077",
			"name": "Sarah Sommer",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000080",
			"name": "Laura Heinrich",
			"grade": "4",
			"studyplan": "511"
		},
		{
			"matno": "9000081",
			"name": "Sophie Brandt",
			"grade": "3",
			"studyplan": "522"
		},
		{
			"matno": "9000084",
			"name": "Sofia Graf",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000085",
			"name": "Lina Schulte",
			"grade": "1",
			"studyplan": "522"
		},
		{
			"matno": "9000088",
			"name": "Johanna Kuhn",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000089",
			"name": "Maja Kühn",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000092",
			"name": "Amely Horn",
			"grade": "5",
			"studyplan": "511"
		},
		{
			"matno": "9000093",
			"name": "Leon Busch",
			"grade": "2",
			"studyplan": "522"
		},
		{
			"matno": "9000096",
			"name": "Jonas Voigt",
			"grade": "3",
			"studyplan": "511"
		},
		{
			"matno": "9000097",
			"name": "Luca Sauer",
			"grade": "4",
			"studyplan": "522"
		},
		{
			"matno": "9000100",
			"name": "Felix Pfeiffer",
			"grade": "5",
			"studyplan": "511"
		}
	]
}'
);
