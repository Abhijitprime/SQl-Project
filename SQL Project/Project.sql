

select *from shipping_dimen;
select * from market_fact;
select * from prod_dimen;
select * from cust_dimen
select * from orders_dimen;



-- Where is the least profitable product subcategory shipped the most?
--For the least profitable product sub-category, display the  region-wise no_of_shipments
--and the profit made in each region in decreasing order of profits 
--(i.e. region, no_of_shipments, profit_in_each_region) → Note:You can hardcode the name of the least profitable product subcategory 


select p.Product_Sub_Category,c.region ,
count(s.Ship_id) as shipping_count,
min(m.profit) as least_profitable
from prod_dimen p,market_fact m,shipping_dimen s,cust_dimen c
where p.Prod_id=m.Prod_id 
and m.Ship_id=s.ship_id
and m.Cust_id=c.Cust_id
group by p.Product_Sub_Category,c.region
order by count(s.Ship_Mode) desc,least_profitable


--Write a SQL query to to make a list with Cust_Id, Sales, Customer Name,region and their excule region ('ONTARIO','NORTHWEST TERRITORIES')
--where sales are between 1000 and 5000. 

select c.cust_id,c.customer_name,c.region,m.sales 
from cust_dimen c,market_fact m
where c.Cust_id=m.Cust_id 
and m.Sales between 1000 and 5000
and Region not in ('ONTARIO','NORTHWEST TERRITORIES')

--Write a SQL query to find all details & the 3rd highest sales.
select * from (select *,dense_rank() over(order by Sales desc ) as Nth_sales from market_fact) as temp 
where Nth_sales=3


--Display the product categories ,product_sub_category,in descending order of profits 
--(display the product category wise profits i.e. product_category,product_sub_category ,profits)? 

SELECT p.Product_Category,p.Product_Sub_Category,round(sum(m.Profit),2) as profits from prod_dimen p ,market_fact m
where p.Prod_id=m.Prod_id
group by p.Product_Category ,p.Product_Sub_Category
order by  p.Product_Category,p.Product_Sub_Category,profits desc;

-- Display Previous year profit and next year profit

select year(o.order_date) as year, 
sum(m.profit) as proft_over_year,
LEAD(sum(m.profit)) over (order by year(o.order_date)) as proft_Next_year,
Lag(sum(m.profit)) over (order by year(o.order_date)) as proft_previous_year

from orders_dimen o , market_fact m

where o.Ord_id=m.Ord_id
group by year(o.order_date)
order by year(o.order_date)


--Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and 
--the number of tables purchased (display the customer name, no_of_tables purchased).

with table1 as
(select c.customer_name,p.Product_sub_category ,m.Sales,c.Region
from cust_dimen c,market_fact m, prod_dimen p
where   
c.cust_id=m.cust_id and
m.prod_id=p.Prod_id and Region='Atlantic' and Product_sub_category ='TABLES')

select customer_name,count(Product_sub_category) as no_of_tables from table1
group by customer_name order by no_of_tables desc;


--Find the region having maximum customers (display the region name and max(no_of_customers) 
select region,max(cust_id) as mx_no_of_customers,count(cust_id) as no_of_customers 
from cust_dimen
group by region
order by no_of_customers desc


