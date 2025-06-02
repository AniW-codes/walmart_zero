# Walmart Data Analysis: End-to-End SQL + Python Project

## Project Overview

![Project Pipeline](https://github.com/najirh/Walmart_SQL_Python/blob/main/walmart_project-piplelines.png)


This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. The project is ideal for data analysts looking to develop skills in data manipulation, SQL querying, and data pipeline creation.

---

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, SQL (MySQL and PostgreSQL)
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Remove Duplicates**: Identify and remove duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
   - **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Use `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL and PostgreSQL
   - **Set Up Connections**: Connect to MySQL and PostgreSQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in  PostgreSQL using Python SQLAlchemy to automate table creation and data insertion.
   - **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.
     - Profit margin analysis by branch and category.
   - **Documentation**: Keep clear notes of each query's objective, approach, and results.

### 11. Project Visualisations on Tableau

**Tableau Analysis** : [Tableau Dashboard](https://public.tableau.com/views/Walmart_Analysis_17488998632900/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


### 12. Project Publishing and Documentation
   - **Documentation**: Maintain well-structured documentation of the entire process in Markdown or a Jupyter Notebook.
   - **Project Publishing**: Publish the completed project on GitHub or any other version control platform, including:
     - The `README.md` file.
     - Jupyter Notebooks.
     - SQL query scripts.
     - Data files or steps to access them.

---

## Requirements

- **Python 3.13.3**
- **SQL Databases**:  PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `psql-connector-python`, `psycopg2`
- **Kaggle API Key** (for data downloading)

## Getting Started

1. Clone the repository:
   ```bash
   git clone <repo-url>
   ```
2. Install Python libraries:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up your Kaggle API, download the data, and follow the steps to load and analyze.

---

## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---

## Results and Insights

This section will include your analysis findings:
- **Sales Insights**: Key categories, branches with highest sales, and preferred payment methods.
- **Profitability**: Insights into the most profitable product categories and locations.
- **Customer Behavior**: Trends in ratings, payment preferences, and peak shopping hours.

## EDA

```sql

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




```

## Key Questions


Q1 Find different payment methods, no of transactions and no of quantities sold. 

```sql
select payment_method, 
		Count(*) as no_transactions,
		SUM(quantity) as qty_sold_every_txn
from walmart
group by 1;


```


Q2 Identify the highest rated category in each branch while returning the branch name, category and avg rating

```sql

select * from
			(select branch,
					category,
					(AVG(rating)),
					RANK() Over(Partition by branch order by avg(rating) desc) as RNK
			from walmart
			group by 1,2)
			--order by 1,3 desc
where RNK = 1;

```


Q3 Identify the busiest weekday for each branch based on no of transactions

```sql

select date,
		TO_DATE(date, 'DD/MM/YY') as formated_date
from walmart

-----extracting weekday from date--------
select *,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'),'Day') as formated_date
from walmart


-----------------------------------------
Select * from 
			(select branch,
					TO_CHAR(TO_DATE(date, 'DD/MM/YY'),'Day') as weekday_name,
					Count(invoice_id),
					RANK() OVER(Partition by branch order by Count(invoice_id) DESC) as RNK
			from walmart
			group by 1,2)
where RNK = 1


```


Q4 Calculate the total qty of items sold per payment method. List payment_method and total_qty.

```sql

select payment_method, 
		SUM(quantity) as qty_sold_every_txn
from walmart
group by 1;


```

Q5 Determine the avg, min and max rating of category for each city. List city, category, avg rating, min rating and max rating.

```sql

select city,
		category,
		min(rating),
		max(rating),
		avg(rating)
from walmart
group by 1,2;


```

Q6 Calculate the total profit for each category by considering total_profit as (Unit price x quantity x profit margin)


```sql
select category,
		ROUND(SUM(total::numeric * profit_margin::numeric),2) as profit_total
from walmart
group by 1
order by 2 desc;



```

Q7 Determine the most common type of payment method for each branch.

```sql

select * from 
			(select branch,
					payment_method,
					COUNT(*),
					RANK() Over(Partition by branch order by COUNT(*) desc) as RNK
			from walmart
			group by 1,2
			order by 1,3)
where RNK = 1;


```


Q8 Categorise sales into groups of MORNING,AFTERNOON and EVENING based on times in the day. Find out each shift and number of invoices.

```sql

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


```


Q9 Identify 5 branches with highest decrease ratio in revenue compared to previous year
(Current yr is 2023, last year is 2022)

```sql

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

```



Determine the most common type of payment method for each branch and ultimately return the count of those top methods.

```sql

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

```



---

## License

This project is licensed under the MIT License. 

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
