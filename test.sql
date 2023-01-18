create table test1 (id int,subject varchar(10),marks int,year date);
insert into test1 values(1,'M ', 80 ,'1990'),(1,'M',82,'1991'),(1 ,'M',84,'1992'),(1 ,'M' ,79,'1993'),(2,'M',75,'1990'),
(2,'M',82,'1991'),
(2,'M',83,'1992'),
(2,'M',85,'1993'),
(1,'P',80,'1990'),
(1,'P',83,'1991'),
(1,'P',84,'1992'),
(1,'P',72,'1993')



WITH data_with_year_over_year AS (
    SELECT id, subject, Year, (Marks-(LAG(Marks) OVER (PARTITION BY subject ORDER BY year))) as growth_Marks_year_over_year 
    FROM test1
)
SELECT id, subject, Year, growth_Marks_year_over_year
FROM data_with_year_over_year
where subject='M';

WITH data_with_year_over_year AS (
    SELECT id, subject, Year, (Marks-(LEAD(Marks) OVER (PARTITION BY id, subject ORDER BY Year))) as growth_Marks_year_over_year 
    FROM test1
)
SELECT id, subject, Year, growth_Marks_year_over_year
FROM data_with_year_over_year;



select (year(Year)-1) as m from test1

WITH data_with_year_over_year AS (
    SELECT id, subject, Marks, Year, (year(Year)-1) as prev_year, 
	(Marks-(SELECT Marks FROM test1 WHERE id=t1.id and subject=t1.subject and Year=t1.year(Year)-1)) as growth
    FROM test1 t1
)
SELECT id, subject, Year, Marks,growth
FROM data_with_year_over_year;














create table cell2 (id int,mobilenumber varchar(10),state text);
insert into cell2(id,mobilenumber,state) values
 (1,7696123590,'Punjab'),
 (2,7696123590,'NCR'),
 (3,7696153595,'karnataka'),
 (4,8696123590,'karnataka'),
 (5,8696123590,'haryana'),
 (6,7696123590,'UP')

 select *,dense_rank()over(partition by mobilenumber order by id ) as rk from cell2;

 select * from cell2
 select id,mobilenumber 
 from (select *,dense_rank()over(partition by mobilenumber  order by id ) as rk from cell2)as temp
 where rk>2;


