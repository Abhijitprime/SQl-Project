Select * from Department
select * from [Department Attendence]
select * from [Department Time]

/* Note 1:- I have Split column Name 'Department Work Timings' into 2 Columns
(department_work_start_timings  ,  department_work_end_timings) for better understanding

Note 2:- I've Rename comlumn name Date (DD/MM/YYYY) to  Date  and Time (HH:MM AM/PM) to  Time

*/

-- For Showing 12 Hours(AM/Pm) Time Format
SELECT Employee_ID,Date,FORMAT(CAST(Time AS DATETIME),'hh:mm tt') AS [Time] ,Attendance_Tag  from [Department Attendence];
 
 -- For Showing 12 Hours(AM/Pm) Time Format
 select Department_ID,Department_Name,FORMAT(cast(department_work_start_timings as datetime),'hh:mm tt') as Dep_Work_Start_time,
 FORMAT(cast(Department_Work_End_Timings as datetime),'hh:mm') as Dep_Work_end_time
 from [Department Time];

  
 with temp as 
(select a.Employee_id,c.Department_name,
 FORMAT(cast(c.Department_Work_Start_Timings as datetime),'hh:mm tt') as Dep_start,
 FORMAT(cast(c.Department_Work_End_Timings as datetime),'hh:mm tt') as Dep_end ,
FORMAT(cast(b.Time as datetime),'hh:mm tt') as emp_time,b.Attendance_Tag,
b.Date
from Department a,[Department Attendence] b,[Department Time] c
 where a.Employee_ID=b.Employee_ID and a.Department_ID=c.Department_ID
 ) , 
 temp2 as 
 (select e.*,DENSE_RANK() over(partition by e.department_name order by e.employee_id ,e.date asc) as rk
 from temp e)
 
 select * from temp2 d
 where NOT EXISTS (select d.Attendance_Tag from temp2 d where d.Attendance_Tag='incoming' and d.Attendance_Tag='outgoing');

 with temp1 as 
(select a.Employee_id,c.Department_name,
 FORMAT(cast(c.Department_Work_Start_Timings as datetime),'hh:mm tt') as Dep_start,
 FORMAT(cast(c.Department_Work_End_Timings as datetime),'hh:mm tt') as Dep_end ,
FORMAT(cast(b.Time as datetime),'hh:mm tt') as emp_time,b.Attendance_Tag,
b.Date
from Department a
 join[Department Attendence] b on a.Employee_ID=b.Employee_ID 
 left join [Department Time] c on a.Department_ID=c.Department_ID
 )  
 
 select e.Employee_id,e.Department_name, 
 e.Dep_start, e.Dep_end,e.Date,
 e.emp_time ,datediff(minute,e.Dep_start,e.emp_time) as st from temp1 e
 











 
 /* case 
 when datediff(minute,e.Dep_start,e.emp_time) >5 then 'late'

 else on time
 end as str from temp e

 case
 when then late_incoming
 when e.Time >= e.Department_Work_end_Timings


FROM temp e
WHERE datediff(minute, e.time, e.Department_Work_Start_Timings)  > '00:05:00' 
       and  datediff(minute,e.Department_Work_End_Timings,  e.time) > '00:05:00'

	   */



	   /* SELECT e.Employee_id,e.Department_name, 
 e.Department_Work_Start_Timings,FORMAT(cast(Department_Work_End_Timings as datetime),'hh:mm') as Department_Work_End_Timing,e.time as emp_time,
       datediff(minute, e.time, e.Department_Work_Start_Timings) as late_incoming, 
       datediff(minute,e.time,FORMAT(cast(Department_Work_End_Timings as datetime),'hh:mm')) as early_outgoing */
	 /*  -- temp2 as
 (select e.Employee_id,e.Department_name,
 e.Department_Work_Start_Timings,e.Department_Work_End_Timings,
 e.time,e.Attendance_Tag ,
 (case when e.Attendance_Tag='Incoming' then 'Punch_in'
 else 'Punch_out' 
 end )as Puch_in_out,
 from temp e */

 Select * from Department
select * from [Department Attendence]
select * from [Department Time];

with t1 as 
(select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag as incoming, DATEDIFF(minute, b.Department_Work_Start_Timings, c.Time) as late_incoming
from Department a,[Department Time] b,[Department Attendence] c
where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID and 
Attendance_Tag ='Incoming')

,
t2 as 
(select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag as outgoing,DATEDIFF(minute, c.Time,b.Department_Work_End_Timings) as early_outgoing
from Department a,[Department Time] b,[Department Attendence] c
where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID and 
Attendance_Tag='Outgoing'
)

select * from t1
union
select * from t2;


select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag as incoming
from Department a,[Department Time] b,[Department Attendence] c
where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID





SELECT a.Employee_ID,b.Department_Name,a.Date , a.Time as emp_work_start_time,
       a.Department_Work_Start_Timings,
       b.Time as emp_work_end_time,b.Department_Work_End_Timings, 
       DATEDIFF(minute, a.Department_Work_Start_Timings, a.Time) as late_incoming, 
       DATEDIFF(minute, b.Time, b.Department_Work_End_Timings) as early_outgoing
FROM t1 a,t2 b
WHERE DATEDIFF(minute, a.Department_Work_Start_Timings, a.Time) >= 5 or
 DATEDIFF(minute, b.Time, b.Department_Work_End_Timings) >= 5
      AND (a.Time IS NOT NULL AND b.Time IS NOT NULL)
	  and a.Date=b.Date and a.Employee_ID=b.Employee_ID and a.Department_Name=b.Department_Name








 create view JD_table
as
with t1 as 
(select a.Employee_id,b.department_name,c.Date,
b.department_work_start_timings,b.department_work_end_timings
,c.time,c.Attendance_Tag , 
DATEDIFF(minute, b.Department_Work_Start_Timings, c.Time) as In_out_Time_diff,
(case
when DATEDIFF(minute, b.Department_Work_Start_Timings, c.Time) > 5 then 'late_in-short_leave' 
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
DATEDIFF(minute, c.Time,b.Department_Work_End_Timings) >5 then 'early_out-short_leave'
else 'ontime' end )as early_outgoing
from Department a,[Department Time] b,[Department Attendence] c
where a.Department_ID=b.Department_ID and a.Employee_ID=c.Employee_ID and 
Attendance_Tag='Outgoing' and c.Time is not null
)

select * from t1
union
select * from t2




with t1 as 
 (SELECT Employee_ID,late_incoming,date
    FROM JD_table
    WHERE late_incoming in('late_in-short_leave','early_out-short_leave') 
	AND date >= '2022-12-19' AND Date <= '2022-12-23')

select count(Employee_ID) from t1
	

