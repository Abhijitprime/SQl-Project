select * from dim_cities
select * from dim_plan
select * from fact_atliqo_metrics
select * from fact_market_share
select * from dim_date
select * from fact_plan_revenue


--1--show How many Telicom comapny are there with their total Market share %.

with cte as 
(select sum(ms_pct) as total from fact_market_share)
select b.company,
round(sum(b.ms_pct*100/a.total),2) as percent_of_total 
from fact_market_share b,cte a
group by b.company

--2-- What is Total & Avg Revenue & Avg revenue per user for Altiqo  telicom company.

select * from 
(select avg(arpu) as avg_revenue_per_user ,round(sum(atliqo_revenue_crores),2) as Total_Altiqo_Revenue ,
round(Avg (atliqo_revenue_crores),2) as Average_Revenue_Altiqo 
from fact_atliqo_metrics) as temp

--3-- show total active user and unsubcribe user for altiqo 

select concat(sum(active_users_lakhs),' ','L') as total_active_user
,concat(sum(unsubscribed_users_lakhs),' ','L') as total_unsubscribed_user
from  fact_atliqo_metrics


--4-- what is total revenue,avg_arpu,total active user and unsubcribe user (before/after 5G)
select * from fact_atliqo_metrics;
select *from dim_date;

with Ram as
(select concat(sum(atliqo_revenue_crores),' ','C') as total_Revenue_Before_5G,
concat(sum(active_users_lakhs),' ','L') as total_active_user_Before_5G
,concat(sum(unsubscribed_users_lakhs),' ','L') as total_unsubscribed_user_Before_5G,
avg(arpu) as avg_revenue_per_user_Before_5G
from fact_atliqo_metrics f
join dim_date d
on
f.date=d.date 
where d.before_after_5g='Before 5g')
,
krishna as (select concat(sum(atliqo_revenue_crores),' ','C') as total_Revenue_After_5g,
concat(sum(active_users_lakhs),' ','L') as total_active_user_After_5g,
concat(sum(unsubscribed_users_lakhs),' ','L') as total_unsubscribed_user_After_5g,
avg(arpu) as avg_revenue_per_user_After_5g
from fact_atliqo_metrics f
join dim_date d
on
f.date=d.date 
where d.before_after_5g='After 5g')

select Ram.*,krishna.*
from Ram,krishna;



--5-- show city_name,before_5g_Revenue,After_5g_Revenue,%_change_revenue 


with Ram as 
(select C.city_name,sum(atliqo_revenue_crores) as Total_Revenue_Before_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='Before 5g'
group by C.city_name)
,
krishna as 
(select C.city_name,sum(atliqo_revenue_crores) as Total_Revenue_After_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='After 5g'
group by C.city_name)

select R.city_name,concat(R.Total_Revenue_Before_5g,' ','L') as Total_Revenue_Before_5g
,concat(K.Total_Revenue_After_5g,' ','L') as Total_Revenue_After_5g,
round((K.Total_Revenue_After_5g-R.Total_Revenue_Before_5g) *100/R.Total_Revenue_Before_5g ,1) as Percent_change
from Ram R,Krishna K
where R.city_name=K.city_name



--6--show city_name,before_5g_Active_user,After_5g_Active_user,%_change_Active_user



with kanha as 
(select C.city_name,sum(active_users_lakhs) as active_users_lakhs_Before_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='Before 5g'
group by C.city_name)
,
balram as 
(select C.city_name,sum(active_users_lakhs) as active_users_lakhs_After_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='After 5g'
group by C.city_name)

select R.city_name,concat(R.active_users_lakhs_Before_5g,' ','L') as active_users_lakhs_Before_5g 
,concat(K.active_users_lakhs_After_5g,' ','L') as active_users_lakhs_After_5g,
round((K.active_users_lakhs_After_5g-R.active_users_lakhs_Before_5g) *100/R.active_users_lakhs_Before_5g ,1) as Percent_change
from kanha R,balram K
where R.city_name=K.city_name
order by Percent_change desc;

--7--show city_name,before_5g_unsubcribed_user,After_5g_unsubcribed_user,%_change_unsubcribed_user

with ct as 
(select C.city_name,sum(unsubscribed_users_lakhs) as unsub_user_lakhs_Before_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='Before 5g'
group by C.city_name)
,
ct2 as 
(select C.city_name,sum(unsubscribed_users_lakhs) as unsub_user_lakhs_After_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='After 5g'
group by C.city_name)

select R.city_name,concat(R.unsub_user_lakhs_Before_5g,' ','L') as unsub_user_lakhs_Before_5g 
,concat(K.unsub_user_lakhs_After_5g,' ','L') as unsub_user_lakhs_After_5g,
round((K.unsub_user_lakhs_After_5g-R.unsub_user_lakhs_Before_5g) *100/R.unsub_user_lakhs_Before_5g ,1) as Percent_change
from ct R,ct2 K
where R.city_name=K.city_name


--8-- show Time_Period and there relative before/after revenue.


with Rama as 
(select d.time_period,sum(atliqo_revenue_crores) as Total_Revenue_Before_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='Before 5g'
group by d.time_period)
,
kana as 
(select d.time_period,sum(atliqo_revenue_crores) as Total_Revenue_After_5g 
from fact_atliqo_metrics f,dim_date d,dim_cities c
where 
f.date=d.date
and
c.city_code=f.city_code
and d.before_after_5g='After 5g'
group by d.time_period)

select R.time_period,
sum(R.Total_Revenue_Before_5g) as Total_Revenue_Before_5g,
sum(K.Total_Revenue_After_5g) as Total_Revenue_After_5g

from Rama R,kana K
where R.time_period=K.time_period
group by  R.time_period


--9-- which Plans has highest revenue 

select p.plans,p.plan_description, sum(pf.plan_revenue_crores) as total, 
DENSE_RANK() over(order by sum(pf.plan_revenue_crores) desc) as rnk
from dim_plan p
join fact_plan_revenue pf
on p.plans=pf.plans
group by p.plans,p.plan_description

--10--what are top 5 cities with highest tmv and per_of_total


select  top 5 c.city_name,sum(f.tmv_city_crores) as Total_TMV,
round(sum(f.tmv_city_crores)*100/sum(sum(f.tmv_city_crores)) over(),1) as Per_of_Total_TMV from fact_market_share f,dim_cities c
where c.city_code=f.city_code 
group by c.city_name
order by Total_TMV desc,Per_of_Total_TMV desc

select * from fact_plan_revenue

--11--what are top 5 Plans with highest Plan_revenue_crores and pecent_of_total

select top 5 plans,sum(Plan_revenue_crores) as Total_Revenue_plan,
round(sum(Plan_revenue_crores)*100/sum(sum(Plan_revenue_crores)) over(),1) as Pecent_of_Total_Revenue_plan
from fact_plan_revenue
group by plans
order by Total_Revenue_plan desc,Pecent_of_Total_Revenue_plan desc

--12-- show plans and there revenue chnage  Before/After installation of 5G and %_change

with T1 as
(select f.plans,sum(plan_revenue_crores) as Total_Revenue_of_Plans_Before_5G from fact_plan_revenue f,dim_date d
where f.date=d.date
and d.before_after_5g='Before 5G'
group by f.plans)
,
T2 as
(select f.plans,sum(plan_revenue_crores) as Total_Revenue_of_Plans_After_5G from fact_plan_revenue f,dim_date d
where f.date=d.date
and d.before_after_5g='After 5G'
group by f.plans)

select a.plans,a.Total_Revenue_of_Plans_Before_5G as Total_Revenue_of_Plans_Before_5G
,b.Total_Revenue_of_Plans_After_5G as Total_Revenue_of_Plans_After_5G,
concat(round((b.Total_Revenue_of_Plans_After_5G-a.Total_Revenue_of_Plans_Before_5G)*100/a.Total_Revenue_of_Plans_Before_5G,2),'%') as Percent_change
from T1 a,T2 b
where a.plans=b.plans


--13--Show Month,company name & ther  Pecent_of_Total_ms_change

select  datename(month,(f.date))as Month_name,sum(f.ms_pct) as Total_MS_Pct,
round(sum(f.ms_pct)*100/sum(sum(f.ms_pct)) over(),1) as Pecent_of_Total_MS_Pct
from fact_market_share f
group by date
order by Total_MS_Pct desc,Pecent_of_Total_MS_Pct desc

--14-- what is % change and % of total ms_pct(Market share %) before/after installation of 5G
select * from dim_date
select * from fact_market_share;



with Tb1 as
(select sum(ms_pct) as Total_ms_pct_Before_5G from fact_market_share f,dim_date d
where f.date=d.date
and d.before_after_5g='Before 5G')
--group by d.month_name
,
Tb2 as
(select sum(ms_pct) as Total_ms_pct_After_5G from fact_market_share f,dim_date d
where f.date=d.date
and d.before_after_5g='After 5G')
--group by d.month_name

select a.Total_ms_pct_Before_5G as Total_ms_pct_Before_5G
,b.Total_ms_pct_After_5G as Total_ms_pct_After_5G,
concat(round((b.Total_ms_pct_After_5G-a.Total_ms_pct_Before_5G)*100/a.Total_ms_pct_Before_5G,2),'%') as Percent_change
from Tb1 a,Tb2 b

