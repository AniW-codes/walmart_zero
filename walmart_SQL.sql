select *
from walmart;


--EDA--
select Count(*)
from walmart;

select distinct(payment_method)
from walmart;

select payment_method,
		Count(payment_method)
from walmart
group by payment_method;

--columnheaders must be in lower case
select distinct(City) 
from walmart;

--DROP TABLE walmart;

select COUNT(distinct(city))
from walmart;




--find different payment methods, no of transactions and no of quantities sold. 

select payment_method, 
		Count(*) as no_transactions,
		SUM(quantity) as qty_sold_every_txn
from walmart
group by 1;




--identify the highest rated category in each branch while returning the branch name, category and avg rating

select * from
			(select branch,
					category,
					(AVG(rating)),
					RANK() Over(Partition by branch order by avg(rating) desc) as RNK
			from walmart
			group by 1,2)
			--order by 1,3 desc
where RNK = 1;



--Identify the busiest weekday for each branch based on no of transactions


select date,
		TO_DATE(date, 'DD/MM/YY') as formated_date
from walmart

-----extracting weekday from date--------
select *,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'),'Day') as formated_date
from walmart

Select * from 
			(select branch,
					TO_CHAR(TO_DATE(date, 'DD/MM/YY'),'Day') as weekday_name,
					Count(invoice_id),
					RANK() OVER(Partition by branch order by Count(invoice_id) DESC) as RNK
			from walmart
			group by 1,2)
where RNK = 1




--Calculate the total qty of items sold per payment method. List payment_method and total_qty.


select payment_method, 
		SUM(quantity) as qty_sold_every_txn
from walmart
group by 1;



--Determine the avg, min and max rating of category for each city.
--List city, category, avg rating, min rating and max rating.

select city,
		category,
		min(rating),
		max(rating),
		avg(rating)
from walmart
group by 1,2;


--Calculate the total profit for each category by considering total_profit as (Unit price x quantity x profit margin)


select category,
		ROUND(SUM(total::numeric * profit_margin::numeric),2) as profit_total
from walmart
group by 1
order by 2 desc;


--Determine the most common type of payment method for each branch.


select * from 
			(select branch,
					payment_method,
					COUNT(*),
					RANK() Over(Partition by branch order by COUNT(*) desc) as RNK
			from walmart
			group by 1,2
			order by 1,3)
where RNK = 1;



--Categorise sales into groups of MORNING,AFTERNOON and EVENING based on times in the day.
--Find out each shift and number of invoices.

With CTE_time as
					(select *,
							CASE
								When EXTRACT (HOUR FROM (time::time)) < 12 then 'Morning'
								When EXTRACT (HOUR FROM (time::time)) BETWEEN 12 and 17 then 'Afternoon' 
								else 'Evening'
							 END as shift_split
					from walmart)
Select shift_split,
		COUNT(*)
from CTE_time
group by 1;
	


--Identify 5 branches with highest decrease ratio in revenue compared to previous year
--Current yr is 2023, last year is 2022


---setting logic for date field
Select *,
		date::date as formated_date,
		EXTRACT(Year from date::date) as only_year
from walmart


-----------------------------


with revenue_2022 as --2022 sales CTE
		(
				Select branch,
						SUM(total) as total_revenue_2022
				from walmart
				where EXTRACT(Year from date::date) = 2022
				group by branch
		),
revenue_2023 as --2023 sales CTE
		(		Select branch,
						SUM(total) as total_revenue_2023
				from walmart
				where EXTRACT(Year from date::date) = 2023
				group by branch
		)

select revenue_2023.branch,
		total_revenue_2022,
		total_revenue_2023,
		(total_revenue_2022 - total_revenue_2023)*100/total_revenue_2022 as ratio_in_percentage
from revenue_2022 
join revenue_2023
	on revenue_2022.branch = revenue_2023.branch
where total_revenue_2022 > total_revenue_2023
order by ratio_in_percentage desc
limit 5;



--Determine the most common type of payment method for each branch and ultimately return the count of those top methods

select payment_method,
		Count(*)
		from 
		(select * from 
			(select branch,
					payment_method,
					COUNT(*),
					RANK() Over(Partition by branch order by COUNT(*) desc) as RNK
			from walmart
			group by 1,2
			order by 1,3)
where RNK = 1
)
group by payment_method;



