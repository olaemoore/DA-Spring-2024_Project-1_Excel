use EMPDB;

-- 1 create foreign key in DepartmentSample Table on 'Edept_ID' column
alter table employeeSample
add constraint FK_departmentsampleDeptID
foreign key (Edept_ID) references departmentsample (Dept_ID) 


-- 2 showing all columns and rows for new tables uploaded from flat files
select * from EmployeeSample

select * from DepartmentSample


-- 3 show unique job titles in each business unit
select distinct job_title, Business_Unit
from EmployeeSample


-- 4 Find average age of all employees
select avg(age) as 'Average age of Employees'
from EmployeeSample


-- 5 Find Min, max, and avg salary of all employees
select min(annual_salary) as 'Lowest Salary', MAX(annual_salary) as 'Highest Salary', AVG(annual_salary) as 'Average Salary'
from EmployeeSample


-- 6 Find the number of employees in each Business unit
select Job_Title, Business_Unit, count(*) as '# Employees in dept'
from EmployeeSample
group by job_title, Business_Unit


-- 7 Find the employees hired in the last 10 years.  Return Employee ID, Full Name, ethnicity and # of years with the company
Select Employee_ID, Full_Name, ethnicity, 
datediff(year, Hire_Date, getdate()) as '# of years with the Company'
from EmployeeSample
where datediff(year, Hire_Date, getdate())  <= 10


-- 8 Find the employees who were hired more than 10 years and whose annual salary is less than $100k and have an analyst position.  List Full_name, job_title, salary and years with the compancy
Select   Count(*),annual_salary, Job_Title,
datediff(year, Hire_Date, getdate()) as '# of years with the Company'
from EmployeeSample
where annual_salary < 100000 and datediff(year, Hire_Date, getdate())  > 10
and Job_Title like '%Analyst%' 
group by Job_Title, Hire_Date, Annual_Salary
order by Hire_Date


-- 9 Find employees who were hired during the height of Covid (2019, 2020). Returen Employee ID, Business Unit, Job Title, annual salary
select Employee_ID, Business_Unit, Job_Title, Annual_Salary, Hire_Date
from EmployeeSample
where DATEPART(year, hire_date) = 2019 or DATEPART(year, hire_date) = 2020


-- 10 Find # of employees who have a senior position in each business unit
select Count(employee_ID) as 'No. of Employees', Business_Unit
from EmployeeSample
Where Job_Title like 'SR%'
group by Business_Unit


-- 11 Show employees who received a bonus (name, job title, salary and bonus)/ calculate bonuse
select Full_Name, Job_Title, annual_salary, (Annual_Salary*Bonus) as 'Calculated Bonus'
from EmployeeSample 
where Bonus != 0


-- 12 Show the top 10 highest paid employees (excluding bonus). Return full name, gender, ethnicity, annual salary, dept city
select top 10 es.Full_Name, es.Gender, es.Ethnicity, es.Annual_Salary, ds.dept_city
from EmployeeSample ES
left join DepartmentSample ds
on es.Edept_ID = ds.Dept_ID
order by es.Annual_Salary


 -- 13 Show all female employees who are not asian and make over $200k. Return full_name, ethnicity, gender, salary
  select es.Full_Name, es.Ethnicity, es.annual_salary, es.Age, ds.Department_Name, ds.Dept_State
 from EmployeeSample es
 right join DepartmentSample ds
 on es.Edept_ID = ds.Dept_ID
 where gender = 'female' and es.Annual_Salary > 200000 and Ethnicity != 'asian'
 order by Annual_Salary


 -- 14 Show all employees, calculate salary + bonus included; add department from 'DepartmentSample' table.  (Query to be used for data visualizations)
 Select Employee_ID, Full_Name, Business_Unit, Gender, Ethnicity, Annual_Salary,Bonus, Department_Name, Dept_State, Dept_Zip, Dep_Country, (Annual_Salary+(annual_salary*CONVERT(float,bonus)/100)) As 'Revised Salary'
from employeeSample es
inner join DepartmentSample ds
on es.Edept_ID = ds.Dept_ID
