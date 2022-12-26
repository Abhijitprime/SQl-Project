select * from dup

select SUBSTRING (emp_name,1,2) as extrat from  dup
select RIGHT(emp_name,3) as tr from dup
select left(emp_name,3) as tr from dup
select REPLACE(emp_name,'bh','mh') as pl from dup
select round(32.62,3) as m
create index mk on dup(emp_name,salary);
select emp_name,salary from dup
where emp_name ='shyam';
