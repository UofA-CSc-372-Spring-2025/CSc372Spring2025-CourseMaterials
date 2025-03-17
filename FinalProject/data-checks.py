# Configuration
max_points_per_student = 30

# Column indices
STUDENT_COL = 0
FRIEND_START_COL = 1
FRIEND_POINTS_START_COL = 2
NUM_FRIENDS = 5
LANGUAGE_START_COL = 11
LANGUAGE_POINTS_START_COL = 12
NUM_LANGUAGES = 3
HAPPINESS_START_COL = 17
NUM_HAPPINESS_COLS = 5

# Read the data
file_path = "happiness-data-from-form.csv"

def read_file(file_path):
    with open(file_path, encoding='utf-8') as file:
        lines = file.readlines()
    return [line.strip().split(",") for line in lines]


# Function to calculate total points per student
def calculate_total_points(row):
    friend_points = sum(
        int(row[i]) if row[i] else 0
        for i in range(FRIEND_POINTS_START_COL, FRIEND_POINTS_START_COL + 2 * NUM_FRIENDS, 2)
    )
    language_points = sum(
        int(row[i]) if row[i] else 0
        for i in range(LANGUAGE_POINTS_START_COL, LANGUAGE_POINTS_START_COL + 2 * NUM_LANGUAGES, 2)
    )
    happiness_points = sum(
        int(row[i]) if row[i] else 0
        for i in range(HAPPINESS_START_COL, HAPPINESS_START_COL + NUM_HAPPINESS_COLS)
    )
    return friend_points + language_points + happiness_points

# Read the data
data = read_file(file_path)
headers = data[0]
data = data[1:]

# Compute total points for each student
students_total_points = {}
exceeding_students = {}
languages = set()
all_students = set()
friend_mentions = set()

for row in data:
    student = row[STUDENT_COL]
    all_students.add(student)
    total_points = calculate_total_points(row)
    students_total_points[student] = total_points
    
    if total_points > max_points_per_student:
        exceeding_students[student] = total_points
    
    for i in range(NUM_LANGUAGES):
        if row[LANGUAGE_START_COL + i * 2]:
            languages.add(row[LANGUAGE_START_COL + i * 2])
    
    for i in range(NUM_FRIENDS):
        if row[FRIEND_START_COL + i * 2]:
            friend_mentions.add(row[FRIEND_START_COL + i * 2])

# Identify missing students in friend lists
missing_students = friend_mentions - all_students

# Output results
print("Total Points per Student:")
for student, total in students_total_points.items():
    print(f"{student}: {total}")

print("\nStudents Exceeding Max Points:")
for student, total in exceeding_students.items():
    print(f"{student}: {total}")

print("\nList of all programming languages:")
print(sorted(languages))

print("\nStudents listed as friends but missing a row:")
print(sorted(missing_students))
