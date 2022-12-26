create table test1 (id int,subject varchar(10),marks int,year date);
insert into test1 values(1,'M ', 80 ,'1990'),(1,'M',82,'1991'),(1 ,'M',84,'1992'),(1 ,'M' ,79,'1993'),(2,'M',75,'1990'),
(2,'M',82,'1991'),
(2,'M',83,'1992'),
(2,'M',85,'1993'),
(1,'P',80,'1990'),
(1,'P',83,'1991'),
(1,'P',84,'1992'),
(1,'P',72,'1993')

select * from test1
group by year,id,subject,marks;

select a.year,a.marks,b.year,b.marks,(b.marks-a.marks/a.marks) as growth_over_year
from test1 a
left join test1 b
on a.year=b.year
and a.id=b.id
and a.subject=b.subject
order by a.year














create table cell2 (id int,mobilenumber varchar(10),state text);
insert into cell2(id,mobilenumber,state) values
 (1,7696123590,'Punjab'),
 (2,7696123590,'NCR'),
 (3,7696153595,'karnataka'),
 (4,8696123590,'karnataka'),
 (5,8696123590,'haryana'),
 (6,7696123590,'UP')

 select *,dense_rank()over(partition by mobilenumber order by id ) as rk from cell2;

 select id,mobilenumber 
 from (select *,dense_rank()over(partition by mobilenumber  order by id ) as rk from cell2)as temp
 where rk>2;
