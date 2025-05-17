# DataAnalytics-Assessment
Technical Accessment

## Overview
This report outlines the approach, methodology, and reasoning behind solving four key business questions using SQL on a MySQL database containing information about users, their savings accounts, investment plans, and transactions.

## Per-Question Explanations
### 1. High-Value Customers with Multiple Products
Objective: Identify customers who have at least one funded savings plan and one funded investment plan.
Approach:
I started by Joining users_customuser with plans_plan using owner_id, then i Added temporary columns 'savings' and 'investments' to differentiate the plan types. Next i Filtered and aggregated data based on the presence of these plan types, and then i finally Calculated total deposits as the sum of confirmed savings minus withdrawals, divided by 100 to convert currency from Kobo to Naira.

### 2. Transaction Frequency Analysis
Objective: Categorize customers based on their average monthly transaction frequency.

Approach:
For this question i began with counting transactions for each customer, then i calculated the average number of transactions per month, then lastly i grouped customers into categories based on defined frequency thresholds.

### 3. Account Inactivity Alert
Objective: Identify active accounts with no inflow transactions for over a year.
Approach:
Firstly i joined plans and savings tables, then filtered accounts based on the absence of recent transactions (using 365-day threshold).
Lastly i calculated inactivity in days and displayed last transaction date.

### 4. Customer Lifetime Value (CLV) Estimation
Objective: Estimate customer lifetime value based on transaction volume and tenure.
Approach: I calculated the tenure as the number of months since account signup. then i estimated CLV using a simplified formula involving profit per transaction and monthly activity.

## Challenges and Steps taken to resove them
 Challenge 1: MySQL error 'Error Code: 2013. Lost connection to MySQL server during query'.
  Solution: when i started i tried running the code without using ctes and subqueries (almost crashed my pc) then i finally had the sense to optimize the queries by using ctes and subqueries thereby reducing complex joins and ensuring proper indexing.

  Challenge 2: Not knowing the right functions to use to appropriately handle null values. 
  Solution: This Project helped me learn about the function coalace which treats null values as 0 to avoid computation errors.
  
  


