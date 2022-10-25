-- DELIVERABLE 1: The Number of Retiring Employees by Title

-- create new table that contains employee no, names, title, and start and end date
SELECT emp.emp_no,
emp.first_name,
emp.last_name,
titles.title,
titles.from_date,
titles.to_date
INTO retirement_titles -- add columns to new table
FROM employees as emp
INNER JOIN titles -- join tables by primary key
ON emp.emp_no = titles.emp_no
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31') --filter birth date 1952 - 1955
ORDER BY emp.emp_no; --order by employee number 

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows from the retirement_titles table
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title,
from_date,
to_date
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;

-- retrieve the number of retirees by title from the unique titles table 
SELECT COUNT(ut.emp_no), ut.title -- number of unique titles
INTO retiring_titles
FROM unique_titles AS ut -- table
GROUP BY ut.title
ORDER BY ut.count DESC;

SELECT * FROM retiring_titles;

-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program 

SELECT DISTINCT ON (emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date,
de.from_date, de.to_date, 
t.title
FROM employees as e
JOIN dept_emp as de ON (e.emp_no = de.emp_no)
JOIN titles as t ON (e.emp_no = t.emp_no)
INTO mentorship_eligibility
WHERE (de.to_date = '9999-01-01') 
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM membership_eligibility;

-- README.md tables

-- Find the ages of the retiring employees
SELECT DATE_PART('year', '2022-10-24'::date) - DATE_PART('year', birth_date::date),
birth_date, first_name, last_name
INTO employees_ages
FROM employees;

--Count the number of employees per age
SELECT COUNT(ea.age), ea.age
INTO number_ages
FROM employees_ages AS ea
GROUP BY ea.age
ORDER BY ea.age;

-- Find percentage of each age of employee
SELECT  100.0 * count / sum(count) over () as percent, age
INTO percent_age
FROM    number_ages AS na;

SELECT * FROM percent_age;
