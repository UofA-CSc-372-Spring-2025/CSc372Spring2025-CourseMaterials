# Notes on usage
# This script is designed to optimize group assignments for students based on 
# their preferences.
# It uses the Google OR-Tools library to solve a linear programming problem.
# The script reads a CSV file containing student preferences, optimizes group 
# assignments,
# and generates an output CSV file with the results.

# The script requires the Google OR-Tools library to be installed. Here
# are the instructions to set up a virtual environment and install the library:
#     # Create a virtual environment (optional) 
#     python3 -m venv ortools-env
#     # Activate the virtual environment
#     source ortools-env/bin/activate  # On Windows use `ortools-env\Scripts\activate`
#     # Install the ortools library
#     pip install ortools
#     # Run the script
#     python3 group-opt.py input.csv output.csv

# The script takes two command-line arguments: the input CSV file and the output CSV file.
# The input CSV file should contain student preferences in the following format:
# Student, Friend1, Friend1_Points, Friend2, Friend2_Points, Language1, Language1_Points, Language2, Language2_Points, Time1, Time1_Points, Time2, Time2_Points
# The output CSV file will contain the group assignments, languages, times, formats, and happiness scores.

from ortools.linear_solver import pywraplp
import csv
import sys

# Constants for preferences and group constraints
num_student_prefs = 5
num_lang_prefs = 3
num_times_prefs = 3
num_formats_prefs = 2
col_prefs_start = 1
col_lang_prefs_start = col_prefs_start + 2*num_student_prefs
col_times_start = col_lang_prefs_start + num_lang_prefs
col_formats_start = col_times_start + num_times_prefs

# Constants for group assignment rules
MIN_STUDENTS_PER_GROUP = 3
MAX_STUDENTS_PER_GROUP = 4
MAX_GROUPS_PER_LANGUAGE = 2

def load_happiness_matrix_from_csv(filename):
    """Loads student happiness, language, time, and format preferences from a CSV file."""
    happiness_matrix = {}
    language_preferences = {}
    meeting_time_preferences = {}
    meeting_format_preferences = {}
    students = set()
    
    with open(filename, mode='r', newline='') as file:
        reader = csv.reader(file)
        headers = next(reader)  # Skip header row
        
        for row in reader:
            student = row[0]
            students.add(student)
            happiness_matrix[student] = {}
            language_preferences[student] = {}
            meeting_time_preferences[student] = {}
            meeting_format_preferences[student] = {}
            
            # Extract student pairing happiness scores
            for i in range(col_prefs_start, col_lang_prefs_start, 2):
                if row[i] and row[i + 1]:
                    preferred_student = row[i].strip()
                    happiness_points = row[i + 1].strip()
                    if preferred_student and happiness_points.isdigit():
                        happiness_matrix[student][preferred_student] = int(happiness_points)
                        students.add(preferred_student)
            
            # Extract language preferences
            for i in range(col_lang_prefs_start, col_times_start, 2):
                if row[i] and row[i + 1]:
                    language = row[i].strip()
                    happiness_points = row[i + 1].strip()
                    if language and happiness_points.isdigit():
                        language_preferences[student][language] = int(happiness_points)
            
            # Extract meeting time preferences
            possible_times = ["Morning", "Afternoon", "Evening"]
            for i, time in zip(range(col_times_start, col_formats_start), possible_times):
                happiness_points = row[i].strip()
                if happiness_points.isdigit():
                    meeting_time_preferences[student][time] = int(happiness_points)
            
            # Extract meeting format preferences
            possible_formats = ["In-person", "Virtual"]
            for i, format_pref in zip(range(col_formats_start, len(row)), possible_formats):
                happiness_points = row[i].strip()
                if happiness_points.isdigit():
                    meeting_format_preferences[student][format_pref] = int(happiness_points)
    
    return list(students), happiness_matrix, language_preferences, meeting_time_preferences, meeting_format_preferences

def optimize_group_assignment(students, groups, happiness_matrix, languages, language_preferences, times, meeting_time_preferences, formats, meeting_format_preferences):
    """Uses linear programming to optimize student group assignments based on preferences."""
    solver = pywraplp.Solver.CreateSolver('CBC')
    if not solver:
        print("Solver not available.")
        return None

    # Decision variables:
    # X[s, g]: 1 if student s is assigned to group g, 0 otherwise
    X = {(s, g): solver.IntVar(0, 1, f'X_{s}_{g}') for s in students for g in groups}
    # L[g, l]: 1 if group g is assigned language l, 0 otherwise
    L = {(g, l): solver.IntVar(0, 1, f'L_{g}_{l}') for g in groups for l in languages}
    # T[g, t]: 1 if group g is assigned time slot t, 0 otherwise
    T = {(g, t): solver.IntVar(0, 1, f'T_{g}_{t}') for g in groups for t in times}
    # F[g, f]: 1 if group g is assigned format f, 0 otherwise
    F = {(g, f): solver.IntVar(0, 1, f'F_{g}_{f}') for g in groups for f in formats}
    # Z[s, g, l]: 1 if student s is in group g and prefers language l, 0 otherwise
    Z = {(s, g, l): solver.IntVar(0, 1, f'Z_{s}_{g}_{l}') for s in students for g in groups for l in languages}
    # M[s, g, t]: 1 if student s is in group g and prefers time t, 0 otherwise
    M = {(s, g, t): solver.IntVar(0, 1, f'M_{s}_{g}_{t}') for s in students for g in groups for t in times}
    # W[s, g, f]: 1 if student s is in group g and prefers format f, 0 otherwise
    W = {(s, g, f): solver.IntVar(0, 1, f'W_{s}_{g}_{f}') for s in students for g in groups for f in formats}
    
    # Constraints:
    # Each student must be assigned to exactly one group
    for s in students:
        solver.Add(sum(X[s, g] for g in groups) == 1)
    
    # Each group must have between MIN_STUDENTS_PER_GROUP and MAX_STUDENTS_PER_GROUP students
    for g in groups:
        solver.Add(sum(X[s, g] for s in students) >= MIN_STUDENTS_PER_GROUP)
        solver.Add(sum(X[s, g] for s in students) <= MAX_STUDENTS_PER_GROUP)
        solver.Add(sum(L[g, l] for l in languages) <= MAX_GROUPS_PER_LANGUAGE)  # Language assignment constraint
    
    # Constraints to ensure that students are only assigned their preferred languages, times, and formats
    for s, g, l in Z:
        solver.Add(Z[s, g, l] <= X[s, g])
        solver.Add(Z[s, g, l] <= L[g, l])
        solver.Add(Z[s, g, l] >= X[s, g] + L[g, l] - 1)
    
    for s, g, t in M:
        solver.Add(M[s, g, t] <= X[s, g])
        solver.Add(M[s, g, t] <= T[g, t])
        solver.Add(M[s, g, t] >= X[s, g] + T[g, t] - 1)
    
    for s, g, f in W:
        solver.Add(W[s, g, f] <= X[s, g])
        solver.Add(W[s, g, f] <= F[g, f])
        solver.Add(W[s, g, f] >= X[s, g] + F[g, f] - 1)
    
    # Objective function: maximize student happiness and preferences
    objective = solver.Objective()
    for s, g, l in Z:
        objective.SetCoefficient(Z[s, g, l], language_preferences[s].get(l, 0))
    for s, g, t in M:
        objective.SetCoefficient(M[s, g, t], meeting_time_preferences[s].get(t, 0))
    for s, g, f in W:
        objective.SetCoefficient(W[s, g, f], meeting_format_preferences[s].get(f, 0))
    
    objective.SetMaximization()


    # Query the number of constraints and variables
    print(f"Number of variables: {solver.NumVariables()}")
    print(f"Number of constraints: {solver.NumConstraints()}")

    # Solve the optimization problem
    status = solver.Solve()
    if status == pywraplp.Solver.OPTIMAL:
        return (
            {s: max(groups, key=lambda g: X[s, g].solution_value()) for s in students},
            {g: max(languages, key=lambda l: L[g, l].solution_value()) for g in groups},
            {g: max(times, key=lambda t: T[g, t].solution_value()) for g in groups},
            {g: max(formats, key=lambda f: F[g, f].solution_value()) for g in groups}
        )
    else:
        print("No optimal solution found.")
        return None

def generate_output_csv(input_filename, output_filename, group_assignments, language_assignments, time_assignments, format_assignments, happiness_matrix, language_preferences, meeting_time_preferences, meeting_format_preferences):
    """Generates a CSV file with group assignments, group attributes, and individual happiness scores."""
    
    with open(input_filename, mode='r', newline='') as infile, open(output_filename, mode='w', newline='') as outfile:
        reader = csv.reader(infile)
        writer = csv.writer(outfile)
        
        # Read header and insert new columns after the first column
        header = next(reader)
        new_columns = ["Group", "Language", "Time", "Format", "Happiness Sum"]
        header = [header[0]] + new_columns + header[1:]
        writer.writerow(header)
        
        for row in reader:
            student = row[0]
            if student not in group_assignments:
                continue  # Skip students not in the assignments
            
            group = group_assignments[student]
            language = language_assignments[group]
            time = time_assignments[group]
            format_pref = format_assignments[group]
            
            # Calculate happiness sum for assigned group
            happiness_sum = sum(happiness_matrix[student].get(other, 0) for other in group_assignments if group_assignments[other] == group)
            
            # Add happiness points for preferred language, time, and format
            happiness_sum += language_preferences[student].get(language, 0)
            happiness_sum += meeting_time_preferences[student].get(time, 0)
            happiness_sum += meeting_format_preferences[student].get(format_pref, 0)
            
            # Insert new data just after the student name
            new_row = [row[0], group, language, time, format_pref, happiness_sum] + row[1:]
            writer.writerow(new_row)
    
    print(f"Output CSV generated: {output_filename}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python script.py input.csv output.csv")
        sys.exit(1)
    
    input_csv = sys.argv[1]
    output_csv = sys.argv[2]

    # Set some parameters and do the optimization.
    filename = input_csv  # Replace with actual CSV file path
    (students, happiness_matrix, language_preferences, \
     meeting_time_preferences, meeting_format_preferences) \
        = load_happiness_matrix_from_csv(filename)
    groups = [11, 12, 13, 14, 15, 16,17]  # Define groups
    #languages = ['C++', 'Dart', 'Go', 'Haskell', 'JavaScript', 'Julia', \
    #             'Miniscript', 'Rust', 'Zig', 'Zip']  # Define possible languages
    # list for smaller set of students
    languages = ['C++', 'GO', 'Kotlin', 'Lua', 'MATLAB', 'MiniScript', 'Ruby', 'Rust', 'SQL', 'Scala'];
#    languages = ["Ada", "C#", "C++","Elixir", "GO", "JavaScript", "Kotlin", "Lisp", "Lua",
#        "MATLAB","MiniScript", "Ruby","Rust", "Scala", "SQL", "Swift", "TypeScript", "WASM" ]

    times = ["Morning", "Afternoon", "Evening"]  # Define possible meeting times
    formats = ["In-person", "Virtual"]  # Define possible meeting formats

    solution = optimize_group_assignment(students, groups, happiness_matrix, 
                                         languages, language_preferences, times,
                                         meeting_time_preferences, formats,
                                         meeting_format_preferences)
    if solution:
        (group_assignments, language_assignments, time_assignments, format_assignments) = solution
        print("Group Assignments:", group_assignments)
        print("Language Assignments:", language_assignments)
        print("Time Assignments:", time_assignments)
        print("Format Assignments:", format_assignments)

    # Generate output CSV file with group assignments and happiness scores
    generate_output_csv(input_csv, output_csv, group_assignments, 
        language_assignments, time_assignments, format_assignments, 
        happiness_matrix, language_preferences, meeting_time_preferences, 
        meeting_format_preferences)
