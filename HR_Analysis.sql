select * from countries;
select * from departments;
select * from employees;
select * from job_history;
select * from locations
select * from regions
select * from emp_details_view; 
select * from emp_details_views;

1-- Write a query to display the names (first_name, last_name) using alias name “First Name_and_Last Name" and last name end with "N".

select CONCAT(first_name ,' ',Last_name) as First_Name_and_Last_Name 
from emp_details_views 
where last_name  in (select last_name from emp_details_views where  last_name like '%n')

2-- Write a query to get unique department ID info from employees table ;

select * from (select distinct(department_id) as uniqe,* from employees ) as temp

3-- Write a query to get all employee details from the employee table order by first name, descending.
select * from employees order by first_name desc

4-- Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is calculated as 15% of salary).

select first_name,last_name,salary,floor(salary*0.15) as Pf from employees;

5--Write a query to get the employee ID, names (first_name, last_name), salary,order in ascending of pf.

select employee_id, concat (first_name,' ',last_name)  as names , salary, floor(salary*0.15) as
Pf from  employees
order by pf ;

6--Write a query to get the highest 1,2,3,salaries payable to employees.
select * 
from (select employee_id,salary,dense_rank() over(order by salary desc) as Highest_salary
from employees) as temp
where Highest_salary in (1,2,3);

 7-- Write a query to get the first 3 characters of first name in upper case & last_name last 3 characters from employees table.
 select upper(substring(first_name,1,3)) as First_3 ,upper(Right(last_name,3)) as last_3 from employees;

 8-- Write a query to check if the first_name fields of the employees table contains numbers

 select first_name from employees where first_name  like '[0-9]';
 
 with cte as 
 (select case when first_name  like '[0-9]' then 'Number_present'
 else 'Number_Not_present' end as checking  from employees )

 select case when checking='Number_Not_present' then count('Number_Not_present')
 else 0 end as count_of_NOtnumber_in_field from cte group by checking;


 9-- Write a query to display the name (first_name, last_name) 
 --and salary for all employees whose salary is not in the range $10,000 through $15,000 and are in department 30 or 100  and 
 --hire date for all employees who were hired in 1997.
 
 select CONCAT(first_name,' ',last_name) as name ,salary,hire_date from employees 
 where salary in (select salary  from employees where salary not between $10000 and $15000 ) and
 department_id in (select department_id from employees where department_id= 30 or department_id=100)
 and year(hire_date)=1997;

 10-- all employees who have both "b" and "c" in their first name.
 select first_name from employees where first_name like '%b%' and first_name like '%[c]%';

 11--Write a query to display the name, job, and salary for all employees whose job is that of a Programmer or a Shipping Clerk, 
 --and whose salary is not equal to $4,500, $10,000, or $15,000 .

 select concat(first_name,' ',last_name) as name,salary,job_title from employees,jobs
 where job_title in (select job_title from jobs where job_title='Programmer' or job_title='Shipping Clerk')
 and salary not in (4500,10000,15000);


 12--Write a query to get the job_id and related employee's id in group formate

 SELECT j.job_id,string_agg(e.employee_id,',') as employee_id    
FROM employees as e,jobs as j
where e.job_id=j.job_id
GROUP BY j.job_id

13-- Write a query to append '@example.com' to email field
update employees
set email=concat(email,'@gmail.com')


14-- Write a query to display the first word from those job titles which contains more than one words .
select SUBSTRING(job_title,1,CHARINDEX(' ',job_title))as jobs_titles from jobs

select * from locations 

15--Write a query to display the email exculed from @  
--and lenth of  last_name for employees where last name contain character 'c' after 2nd position

select SUBSTRING(email,-1,CHARINDEX('@',email)) as mail ,last_name,len(last_name) as lenth from employees
where last_name in (select last_name from employees where last_name like '__c%');