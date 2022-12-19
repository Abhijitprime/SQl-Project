drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales ;
select * from product;
select * from users;
select * from goldusers_signup;

/*1:-what is the  total amount spend by each customer;*/

select s.userid,sum(p.price) as total_amount from sales s join product p on s.product_id=p.product_id group by s.userid;

/*How many days each customers vistied cite*/

select userid,count(distinct(created_date)) as visited_date from sales group by userid;

/* what was the first product purchased by each customr */

select * from (select *,rank() over(partition by userid order by created_date ) as rnk from sales) as temp where rnk=1;

/* what is the most purchased order from  product list .how many times was it purchased by all customers */

select userid,count(product_id) as most_purchased from sales where  
 product_id=(select top 1 product_id  from sales group by product_id order by count(product_id) desc)
 group by userid;

 /* which item/product is was most populer for each custmer */
 select userid , product_id  from (select *,DENSE_RANK() over(partition by userid order by product_id) as mx from sales) temp where mx in(1);

 select * from 
 (select *,rank()over(partition by userid order by cnt)  as rnk from
 (select userid,product_id,count(product_id) as cnt from sales  group by userid,product_id)a)b
 where rnk=1;

 6-- which item was purchesed by the customer first after becoming gold member?

 select * from
 (select a.* ,rank() over(partition by userid order by created_date) as rnk from
 (select s.userid,s.created_date,s.product_id,g.gold_signup_date 
 from sales s
 join goldusers_signup g
 on s.userid=g.userid
 and  s.created_date>=g.gold_signup_date) a) b where  rnk=1;

 7-- which item was  first purchased just before customer become gold_member
 
 select * from 
 (select c.* ,rank () over(partition by userid order by created_date) as rnk from
 (select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s
 join  goldusers_signup g on s.userid=g.userid
 and s.created_date<= g.gold_signup_date) c)d where rnk=1;

8-- what is the total order and amount spend by each customer just before they become gold member.

select userid,COUNT(created_date) as total_order,sum(price) as total_price from 
(select c.*,p.price from 
(select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s join goldusers_signup g on s.userid=g.userid
 and s.created_date<= g.gold_signup_date)c join
 product p on c.product_id=p.product_id)e
 group by userid;


 9 if buying each product generates points for eg:5rs=2 zomato point and 
 each product has different purchasing point for eg for p1 5rs=1 zomato point and p2 10rs=5 zomato points p3 5rs=1 zomato point
 --2rs=1 zomato point
 ,calculate point collected by each customer and for which product most point have been till now ;


 select userid,sum(point)*2.5 as total_money_user_point from
 (select b.* ,amount/points as  point from 
 (select a.*, case
 when product_id=1 then 5
 when product_id=2 then 2
 when product_id=3 then 1
 else 0
 end as points from
 (select s.userid,s.product_id,sum(p.price) as amount from sales s join product p on s.product_id=p.product_id group by userid,s.product_id)a)b)c 
 group by userid;

 select f.* from
 (select product_id,total_money_user_point,rank() over(order by total_money_user_point desc) as rnk from 
 (select product_id,sum(point) as total_money_user_point from
 (select b.* ,amount/points as  point from 
 (select a.*, case
 when product_id=1 then 5
 when product_id=2 then 2
 when product_id=3 then 1
 else 0
 end as points from
 (select s.userid,s.product_id,sum(p.price) as amount from sales s join product p on s.product_id=p.product_id group by userid,s.product_id)a)b)c 
 group by product_id)e)f where rnk=1;

 10-- In the first One year customer joins the gold program(inculding their join date) irrespective of what the customer has purchased they earn 
 5 zomato points for every 10rs spent who earn more more 1 or 3 and what was their points earning in their first yr?

 5 point=10 rs
 1 point=2rs
 0.5 point=1rs

 select c.*,p.price*0.5 as total_amounts from 
 (select s.userid,s.product_id,s.created_date,g.gold_signup_date from sales s join goldusers_signup g
 on s.userid=g.userid and s.created_date>=dateadd(year,1,g.gold_signup_date))c
 join product p on c.product_id=p.product_id;


 11 -- rank all the transaction of the customers
 
 select *,rank() over(partition by userid order by  created_date ) as rnk  from sales;


 12-- rank all the transactions for each member whenever they are zomato gold member for every gold member transaction mark as na.

 select d.*,case when rnk=0 then 'NA'  else rnk end as condtition from
 (select c.*,cAST(case 
 when gold_signup_date is null then 0 
 else rank() over(partition by userid order by created_date desc) 
 end AS VARCHAR)as rnk from 
 (select s.userid,s.created_date,s.product_id,g.gold_signup_date from sales s  left join goldusers_signup g
 on s.userid=g.userid and s.created_date>=g.gold_signup_date)c)d;

