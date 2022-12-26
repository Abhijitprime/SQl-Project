/*Day	Revenue	Cost	New Customers
2019-01-01	10800	4650	120
2019-01-02	10807	4650	80
2020-01-01	13720	7200	25
2020-01-02	13720	7200	33
2021-01-01	12262	7800	10
2021-01-02	17388	7800	28 */

create table yoy (Day date ,Revenue int,cost int,New_customers int);
insert into yoy values('2019-01-01',10800,4650,120),('2019-01-02',10807,4650,80),('2020-01-01',13720,7200,25),('2020-01-02',13720,7200,33),
('2021-01-01',12262,7800,10),('2021-01-02',17388,7800,28);
select * from yoy;

with cte as (select year(day) as year ,MONTH(day) as month,SUM(revenue) as revenue from yoy group by year(day),MONTH(day))
select 
year,month,revenue ,
lag(revenue) over(order by year,month),(revenue-lag(revenue) over(order by year,month)) diff 
from cte
order by 1,2;


create table train1 (train_id int,station varchar(15),clock time);
insert into train1 values(110,'San Francisco','10:00:00'),
(110,'Redwood City','10:54:00'),
(110,'Palo Alto','11:02:00'),
(110,'San Jose','12:35:00'),
(120,'San Francisco','11:00:00'),
(120,'Redwood City','11:54:00'),
(120,'Palo Alto','12:04:00'),
(120,'San Jose','13:30:00')
select * from train1;

select train_id,station,clock as time_trian,clock-min(clock) over(partition by train_id order by clock) as elapsed,
(lead(clock) over(partition by train_id order by clock)-clock) as difference_next_train from train1;
/* find time required  for trian to get to next station */





WITH monthly_metrics AS (
 SELECT 
   year(day) as year,
   month(day) as month,
   SUM(revenue) as revenue
 FROM yoy 
 GROUP BY  year(day),
   month(day) 
)
SELECT 
  year, month, revenue,
  LAG(revenue) OVER (ORDER BY year, month) as Revenue_previous_month,
  revenue - LAG(revenue) OVER (ORDER BY year, month) as Month_to_month_difference
FROM monthly_metrics
ORDER BY 1,2;