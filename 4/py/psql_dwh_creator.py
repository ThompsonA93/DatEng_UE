#
# PREAMBLE
#
# Install requirements using
# ~$ pip3 install psycopg2-binary pandas
import psycopg2         # PSQL-Connection
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import json             # JSON handling
import os               # Reference Directories and Files
import pandas           # Just for debugging results
import time as t        # Sleep, just for showcasing

# Flags
SLEEP = False     
SLEEP_DURATION = 4
PRINT = True

# Var
DATABASE = "aau_dwh"

# Funcs
def listToString(list):
    return ' '.join([str(substr) for substr in list])

def printPretty(tablename, data):
    print("+-+", tablename, "+-+\n",pandas.DataFrame(data).to_markdown(index=False), "\n")

#
# CODE
#
## I. Connect to the PSQL Database
# FIXME Try catch if database does not exist yet
conn = psycopg2.connect(
    user="postgres", password="1q2w3e4r", host='localhost', port='5432', database=DATABASE
)
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cursor = conn.cursor()

## II. Create DWH
# FIXME with try/catch when database already exists
# createdb = "CREATE DATABASE "+DATABASE+";"
# cursor.execute(createdb)

## III. Create Tables
# FIXME Try/catch deletion since dependant on grades
create_tables = """
/** 1a_1_DWHCreation.sql **/
DROP TABLE IF EXISTS Grades; -- Temporarily from 2nd script
DROP TABLE IF EXISTS Lecturer;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Time;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Studyplan;

-- {Name, Rank (Univ Ass, Postdoc-Ass, Prof, Ass Prof, …), Title (DI, DR,…)} → Department → University
CREATE TABLE Lecturer(
    LecturerID INT NOT NULL,
    "Name" VARCHAR(255) NOT NULL,
    Rank VARCHAR(255) NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Department VARCHAR(255) NOT NULL,
    University VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Lecturer PRIMARY KEY (
        -- https://www.w3schools.com/sql/sql_primarykey.ASP
        -- Benefit: Names the primary key
        LecturerID
    )
);

-- {Course, Type (VO, VC, UE,…), ECTS, Level} → Department* → UniversityName
CREATE TABLE Course(
    CourseID VARCHAR(255) NOT NULL, -- "ID listed as XXX.XXX" :: Assuming Varchar due to '.'
    Course VARCHAR(255) NOT NULL,
    "Type" VARCHAR(255) NOT NULL,
    ECTS INT NOT NULL,
    "Level" VARCHAR(255) NOT NULL,
    Department VARCHAR(255) NOT NULL,
    UniversityName VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Course PRIMARY KEY (
        CourseID
    )
);

-- Day → Month → Semester → Year
CREATE TABLE Time(
    TimeID SERIAL NOT NULL, -- Serial: Autogenerate key, as we don't have an ID written in JSON
    "Day" INT NOT NULL,
    "Month" INT NOT NULL,
    Semester VARCHAR(255), -- No entry matching semester :: Assuming SS/WS
    "Year" INT NOT NULL,
    CONSTRAINT Pk_Time PRIMARY KEY(
        TimeID
    )
);

-- Name
CREATE TABLE Student(
    StudentID INT NOT NULL, -- 9,xxx,xxx < 2,147,483,647 (Max INT)
    "Name" VARCHAR(255),
    CONSTRAINT PK_STUDENT PRIMARY KEY(
        StudentID
    )
);

-- {StudyplanTitle, Degree (Bachelor/Master), Branch (Technical Studies/Economics)}
CREATE TABLE Studyplan(
    StudyplanID INT NOT NULL,
    StudyplanTitle VARCHAR(255) NOT NULL,
    Degree VARCHAR(255) NOT NULL,
    Branch VARCHAR(255) NOT NULL,
    CONSTRAINT PK_Studyplan PRIMARY KEY(
        StudyplanID
    )
);
"""
cursor.execute(create_tables)

create_fact_table = """
/* 1a_2_GradesCreation.sql */
-- Creation of fact table (Grades)

-- Needs to correlate to the tables in 1a
CREATE TABLE Grades(
    GradeID SERIAL NOT NULL,
    LecturerKey INT NOT NULL,
    CourseKey VARCHAR(255) NOT NULL,
    TimeKey INT NOT NULL,
    StudentKey INT NOT NULL,
    StudyplanKey INT NOT NULL,
    CONSTRAINT PK_Grades PRIMARY KEY(
        GradeID
    ),
    CONSTRAINT FK_Lecturer FOREIGN KEY (LecturerKey)
        REFERENCES  lecturer(lecturerid)
        ON DELETE CASCADE,
    CONSTRAINT FK_Course FOREIGN KEY (CourseKey)
        REFERENCES course(courseid)
        ON DELETE CASCADE,
    CONSTRAINT FK_Time FOREIGN KEY (TimeKey)
        REFERENCES time(timeid)
        ON DELETE CASCADE,
    CONSTRAINT FK_Student FOREIGN KEY (StudentKey)
        REFERENCES student(studentid)
        ON DELETE CASCADE,
    CONSTRAINT FK_Studyplan FOREIGN KEY (StudyplanKey)
        REFERENCES studyplan(studyplanid)
        ON DELETE CASCADE
);
"""
cursor.execute(create_fact_table)

print("! Scanning for tables:")
cursor.execute("""SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'""")
for table in cursor.fetchall():
    print("\t", table)
if(SLEEP): t.sleep(SLEEP_DURATION)

## IV. Fetch Table information from JSON, aggregate necessities and insert into temporary arrays
lecturer = []   # Name, Rank, Title, Department, University
course = []     # ID, Course, Type, ECTS, Level, Department, University
time = []       # Day, Month, Semester, Year
student = []    # Name
studyplan = []  # StudyplanTitle, Degree, Branch

with open("../aau/aau_corses.json", mode='r', encoding='utf-8') as course_json:
    with open("../aau/aau_metadata.json", mode='r', encoding='utf-8') as metadata_json:
        course_data = json.load(course_json)
        metadata_data = json.load(metadata_json)
        #print("! Reading course-data: ", course_data)
        #print("! Reading meta-data: ", metadata_data)

        # 1. Lecturer-table aggregations
        for l in metadata_data['lecturers']:            
            # Assume: Generate Title by elimination procedure
            #   1. = Always Rank
            #   n-1 & n = Always Firstname + Lastname
            splitname = l['name'].split()
            rank = splitname[0]
            title = splitname[1:len(splitname)-2]
            name = splitname[len(splitname)-2:]
            #print("!", rank, title, name)

            # Name, Rank, Title, Department, University
            entry = l['id'],listToString(name),rank,listToString(title),l['department'],metadata_data['name']
            lecturer.append(entry)

        # 2. Courses-Table aggregations
        for c in course_data:
            for recs in course_data[c]:
                # ID, Course, Type, ECTS, Level, Department, University
                entry = recs['id'],recs['title'],recs['type'],recs['ECTS'],c,recs['department'],metadata_data['name']
                course.append(entry)

        # 3. Time-Table requires a different approach (over results, see below)
        # 4. Student-Table requires a different approach (over results, see below)
        
        # 5. Studyplan-Table aggregations
        for c in metadata_data['bachelor_study_plans']:
            # StudyplanTitle, Degree, Branch
            entry = c['id'],c['name'],"Bachelor",c['branch']
            studyplan.append(entry)
        for c in metadata_data['master_study_plans']:
            entry = c['id'],c['name'],c['type'],c['branch']
            studyplan.append(entry)

path = "../aau/results"
for infile in os.listdir(path):
    with open(file=path+"/"+infile, mode='r', encoding='utf-8') as results_json:
        results_data = json.load(results_json)
        # 3. Time-Table  
        # Day, Month, Semester, Year
        # Assume semester based on month
        split_date = results_data['date'].split('-')
        day = split_date[2]
        month = split_date[1]
        year = split_date[0]
        semester = 'SS'
        if int(month) >= 6:
            semester = 'WS'
        entry = day, month, semester, year
        time.append(entry)
        # 4. Student-Table 
        # Name
        for r in results_data['results']:
            entry = r['matno'], r['name']
            student.append(entry)


#if(PRINT): printPretty("Courses: ", course)
#if(SLEEP): t.sleep(SLEEP_DURATION)
#if(PRINT): printPretty("Lecturer: ", lecturer)
#if(SLEEP): t.sleep(SLEEP_DURATION)
#if(PRINT): printPretty("Studyplan: ", studyplan)
#if(SLEEP): t.sleep(SLEEP_DURATION)
#if(PRINT): printPretty("Time: ", time)
#if(SLEEP): t.sleep(SLEEP_DURATION)
#if(PRINT): printPretty("Student:" ,student)
#if(SLEEP): t.sleep(SLEEP_DURATION)

# Commit data to DB
## lecturer = []   # Name, Rank, Title, Department, University
## course = []     # ID, Course, Type, ECTS, Level, Department, University
## time = []       # Day, Month, Semester, Year
## student = []    # Name
## studyplan = []  # StudyplanTitle, Degree, Branch
for entry in lecturer:
    query_skel = """INSERT INTO lecturer(lecturerid, "Name", rank, title, department, university) VALUES (%s,%s,%s,%s,%s,%s)"""
    cursor.execute(query_skel, entry)
cursor.execute("""SELECT * FROM lecturer;""")
dtable = cursor.fetchall()  
printPretty("LecturerTable", dtable) #print(dtable)

for entry in course:
    query_skel = """INSERT INTO course(courseid, course, "Type", ects, "Level", department, universityname) VALUES (%s,%s,%s,%s,%s,%s,%s)"""
    cursor.execute(query_skel, entry)
cursor.execute("""SELECT * FROM course;""")
dtable = cursor.fetchall()  
printPretty("CourseTable", dtable) #print(dtable)

for entry in time:
    query_skel = """INSERT INTO time("Day", "Month", semester, "Year") VALUES (%s,%s,%s,%s)"""
    cursor.execute(query_skel, entry)
cursor.execute("""SELECT * FROM time;""")
dtable = cursor.fetchall()  
printPretty("TimeTable", dtable) #print(dtable)

for entry in student:
    query_skel = """INSERT INTO student(studentid, "Name") VALUES (%s,%s) ON CONFLICT DO NOTHING"""
    cursor.execute(query_skel, entry)
cursor.execute("""SELECT * FROM student;""")
dtable = cursor.fetchall()  
printPretty("StudentTable", dtable) #print(dtable)

for entry in studyplan:
    query_skel = """INSERT INTO studyplan(studyplanid, studyplantitle, degree, branch) VALUES (%s,%s,%s,%s)"""
    cursor.execute(query_skel, entry)
cursor.execute("""SELECT * FROM studyplan;""")
dtable = cursor.fetchall()  
printPretty("StudyPlanTable", dtable) #print(dtable)

# Commit & clean up

conn.commit()
conn.close()