#
# PREAMBLE
#
# Install requirements using
# ~$ pip3 install psycopg2-binary pandas
import psycopg2         # PSQL-Connection
import json             # JSON handling
import os               # Reference Directories and Files
import pandas           # Just for debugging results
import time as t        # Sleep, just for showcasing
SLEEP = False            
SLEEP_DURATION = 2.5

def listToString(list):
    return ' '.join([str(substr) for substr in list])

def printPretty(data):
    print(pandas.DataFrame(data).to_markdown(), "\n")

#
# CODE
#
# Connect to the PSQL Database
conn = psycopg2.connect(
    database="aau", user="postgres", password="1q2w3e4r", host='localhost', port='5432'
)
cursor = conn.cursor()

print("! Scanning for tables:")
cursor.execute("""SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'""")
for table in cursor.fetchall():
    print("\t", table)

if(SLEEP): t.sleep(SLEEP_DURATION)

lecturer = []   # Name, Rank, Title, Department, University
course = []     # ID, Course, Type, ECTS, Level, Department, University
time = []       # Day, Month, Semester, Year
student = []    # Name
studyplan = []  # StudyplanTitle, Degree, Branch

# Assume: Schemas already running (see 1a_1, 1a_2, 1b_1 in /sql)
# Write to 'course' table
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
            entry = listToString(name),rank,listToString(title),l['department'],metadata_data['name']
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

printPretty(course)
printPretty(lecturer)
printPretty(studyplan)
printPretty(time)
printPretty(student)

# Commit data to DB
# TODO

# Close & clean up
conn.close()