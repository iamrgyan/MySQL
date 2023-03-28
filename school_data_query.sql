show tables;

select * from admission;
select * from marks;
update marks set Total_Marks = 600;
select * from students;
select * from subjects;


-- Question 1 - How many students took admission year-wise, class-wise, and gender-wise?
select Admission_Year, count(students_category) as New_Admission from students where students_category = "New Admission" group by admission_year;
select Admission_Class, count(students_category) as New_Admission from students where students_category = "New Admission" group by Admission_Class;
select Gender, count(students_category) as New_Admission from students where students_category = "New Admission" group by Gender;
select count(Admission_Year), count(Admission_Class), count(Gender) from students where students_category = "New Admission";

-- Question 2 - Print list of New Admission students with Name, Gender, Admission Year, Admission_Class, and Student_Code.
select Student_Name, Gender, Admission_Year, Admission_Class, Student_Code from students where students_category = 'New Admission';

-- Question 3 - How many students have been dropped from school year-wise, class-wise, and gender-wise?
select present_year, count(student_status) as Dropped from students where student_status = "dropped" group by present_year;
select present_class, count(student_status) as Dropped from students where student_status = 'dropped' group by present_class;
select Gender, count(student_status) as Dropped from students where student_status = 'dropped' group by gender;
select count(present_year), count(present_class), count(Gender) from students where student_status = 'dropped';

-- Question 4 - Print list of Dropped students with Name, Gender, Admission Year, Admission_Class, and Student_Code.
select Student_Name, Gender, Admission_Year, Admission_Class, Student_Code from students where student_status = 'dropped';

-- Question 5 - How many students have been promoted year-wise, class-wiae, and gender-wise?
select present_year, count(student_status) as Promoted from students where student_status = 'promoted' group by present_year;
select present_class, count(student_status) as Promoted from students where student_status = "Promoted" group by present_class;
select Gender, count(student_status) as Promoted from students where student_status = "Promoted" group by gender;
select count(present_year), count(present_class), count(Gender) from students where student_status = 'promoted';

-- Question 6 - Print list of Promoted students with Name, Gender, Admission Year, Admission_Class, and Student_Code.
select Student_Name, Gender, Admission_Year, Admission_Class, present_year, present_class,
Student_Code from students where student_status = 'Promoted';


-- Question 7 - Print List of student with their Tenure in days from highest to lowest order.
select Student_Name, Gender, Admission_Year, Admission_Class, student_code , max(present_year) as Leaving_Year,
max(Present_Class) as Last_Class, 365*((max(present_year) - admission_year)+1) as Tenure_in_Days from students
group by student_code order by Tenure_in_Days desc;


-- Question 8 - Find the total number of students in class (6,7,8,9,10) year-wise
select Present_Year, Present_Class, count(present_class) as Class from students where Present_Year = '2017' group by present_class;
select Present_Year, Present_Class, count(present_class) as Class from students where Present_Year = '2018' group by present_class;
select Present_Year, Present_Class, count(present_class) as Class from students where Present_Year = '2019' group by present_class;
select Present_Year, Present_Class, count(present_class) as Class from students where Present_Year = '2020' group by present_class;
select Present_Year, Present_Class, count(present_class) as Class from students where Present_Year = '2021' group by present_class;

-- Question 9 - Get the list of people who never ever promoted
select * from students where present_year = admission_year and Student_Status = 'dropped';

-- Question 10 - Get the list of students who have been Promoted and then Dropped in next class
select * from students where present_year > admission_year and student_status = 'dropped';


-- Question 11 - Assign Keys to the tables
# Add primary Key to Table Admission
alter table admission add primary key(student_code);
desc admission;

# Add Foreign Key to Table Marks
alter table marks add foreign key(student_code) references admission(student_code);
desc marks;

# Add Foreign Key to Table Students
alter table students add foreign key(student_code) references admission(student_code);
desc students;

-- Question 12 - Get all the possible details of students who have been dropped.
select a.student_name, a.student_code, s.gender, s.admission_year, s.admission_class, s.present_year, s.present_class, s.students_category,
m.total_marks, m.marks_scored, m.hindi, m.english, m.social_science, m.math, m.science, m.computer_science
from admission a inner join students s on a.student_code = s.student_code inner join marks m on a.student_code = m.student_code
where m.student_status = 'Dropped' and s.student_status = "dropped";

-- Question 13 - Get the marks of student who have been promoted with thier admission class, present class and year of promotion.
select s.student_name, s.student_code, s.gender, s.admission_class, s.present_class, s.present_year, m.marks_scored,
m.hindi, m.english, m.social_science, m.math, m.science, m.computer_science, m.student_status
from students s inner join 
marks m on s.student_code = m.student_code where m.student_status = 'promoted' and s.Present_Year = m.Present_Year order by student_name;













