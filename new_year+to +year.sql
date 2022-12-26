CREATE TABLE grp_member (
	joined DateTime,
	member_id int
);
INSERT INTO grp_member (joined, member_id)
VALUES 
('2021-02-10', 123),
('2019-05-14', 123),
('2021-02-25', 123),
('2019-07-14', 123),
('2021-11-04', 123),
('2021-05-17', 123),
('2021-07-14', 123),
('2020-08-02', 123),
('2020-09-13', 123),
('2021-02-14', 123),
('2019-05-06', 123),
('2021-12-14', 123),
('2020-07-29', 123),
('2020-06-14', 123),
('2021-05-18', 123),
('2021-10-04', 123),
('2020-08-12', 123),
('2020-09-21', 123);

select * from grp_member

SELECT YEAR(joined) AS JoinedYear, COUNT(member_id) AS Members
FROM grp_member 
GROUP BY YEAR(joined) 
ORDER BY JoinedYear asc; 