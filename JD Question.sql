Select * from Department
select * from [Department Attendence]
select * from [Department Time];

/* Note 1:- I have Split column Name 'Department Work Timings' into 2 Columns
(department_work_start_timings  ,  department_work_end_timings) for better understanding

Note 2:- I've Rename comlumn name Date (DD/MM/YYYY) to  Date  and Time (HH:MM AM/PM) to  Time

*/


-- For Showing 12 Hours(AM/Pm) Time Format
SELECT Employee_ID,Date,FORMAT(CAST(Time AS DATETIME),'hh:mm tt') AS [Time] ,Attendance_Tag  from [Department Attendence];
 
 -- For Showing 12 Hours(AM/Pm) Time Format
 select Department_ID,Department_Name,FORMAT(cast(department_work_start_timings as datetime),'hh:mm tt') as Dep_Work_Start_time,
 FORMAT(cast(Department_Work_End_Timings as datetime),'hh:mm tt') as Dep_Work_end_time
 from [Department Time];



-- created view with CTE for Short leave 

create view JD_table1
as
(with t1 as 
(select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag , 
DATEDIFF(minute, b.Department_Work_Start_Timings, c.Time) as In_out_Time_diff,
(case
when DATEDIFF(minute, b.Department_Work_Start_Timings, c.Time) > 5 then 'short_leave' 
else 'ontime' end )as late_incoming

from Department a,[Department Time] b,[Department Attendence] c

where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID and 
Attendance_Tag ='Incoming' and c.Time is not null)

,
t2 as 
(select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag ,

DATEDIFF(minute, c.Time,b.Department_Work_End_Timings) as In_out_time_diff,
(case
when
DATEDIFF(minute, c.Time,b.Department_Work_End_Timings) >5 then 'short_leave'
else 'ontime' end )as early_outgoing


from Department a,[Department Time] b,[Department Attendence] c

where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID and 
Attendance_Tag='Outgoing' and c.Time is not null
)

select * from t1
union
select * from t2;


-- select All value from View table

select * from JD_table1;

--Calculate the Total Number of Unique Employees having Short Leave in the given working week of Dec'22

with t1 as 
 (SELECT Employee_ID,late_incoming,date
    FROM JD_table1
    WHERE late_incoming in('short_leave') 
	AND date >= '2022-12-19' AND Date <= '2022-12-23')

select count(Employee_ID)  as Short_leave_emp_count from t1;


select * from JD_table1;


--- Calculate the Total Number of Unique Employees with missed puch out/ puch in in the given working week of Dec'22.
--- logic:- each emp id has 2 date incoming date ,outgoing date if he/she miss puch_in or puch_out that case only 1 date appears
--- and in problem statement clearly  ask "Unique Employees with missed puch out/ puch in" in week 


with cte as 
(SELECT Employee_id,Date,Attendance_tag,time,department_name,
	department_work_start_timings,department_work_end_timings,
	case when Attendance_tag = 'Incoming' then 'Punch_in'
	when Attendance_tag = 'Outgoing' then 'Punch_out'
	else 'Miss_Puch_in' end as Punch_inout from JD_table1),


cte2 as
(select Employee_id,count(date) as Date_count
	from cte
	where  
	not exists
	(select Attendance_Tag from JD_table1 where  Attendance_Tag  in('incoming') and Attendance_Tag in('Outgoing'))
	group by Employee_id
	having count(date) <10)

select b.Employee_id,count(b.Employee_id) As Emp_Miss_puch_inout from cte2 b
group by b.Employee_id;
	

---missed puch out/ puch in in the given working week of Dec'22
create View JD_miss_puch as
	  with cte as 
	(select * from JD_table1)
	,
	cte2 as 
	(select Employee_id,department_name,count(date) as date_count from JD_table1
	group by Employee_id,department_name )
	
	select a.*,case
when (date='2022-12-19'and Attendance_Tag='Outgoing') then 'Miss_puch_incoming'
when (date='2022-12-19'and Attendance_Tag='Incoming') then 'Miss_puch_outgoing'

else 'Puch' end  as Miss_Puch_IN_OUT
	from cte a,cte2 b
	where a.Employee_id=b.Employee_id and date_count<10;


--Identify the details of the employees, with a segregation for short leaves 
--and missed puch out/ puch in in the given working week of Dec'22.

Select  employee_id,department_name,date,time,
department_work_start_timings,department_work_end_timings,Attendance_Tag,late_incoming
from JD_table1
where late_incoming='short_leave'


select * from JD_miss_puch;

select employee_id,department_name,date,time,
department_work_start_timings,department_work_end_timings,Attendance_Tag,late_incoming,Miss_Puch_IN_OUT
from JD_miss_puch
where late_incoming='short_leave' and Miss_Puch_IN_OUT in ('Miss_puch_incoming','Miss_puch_outgoing')






