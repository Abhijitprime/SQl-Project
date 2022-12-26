create table studet (st_id int ,name varchar(20));
create table mark (st_id int,physic int,math int,che int);

insert into studet  values (101,'Abhijit'),(102,'Abhi'),(103,'Aijit'),(104,'Abjit')
insert into mark values(101,40,56,36),(102,65,46,36),(103,35,56,36),(104,85,66,76);
select * from studet;
select * from mark;

delete from zr where va is null