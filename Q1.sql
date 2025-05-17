-- Question 1 : High-Value Customers with Multiple Products

-- Scenario: The business wants to identify customers who have both a 
-- savings and an investment plan (cross-selling opportunity).

-- Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, 
-- sorted by total deposits.

-- Tables:
-- users_customuser
-- savings_savingsaccount
-- plans_plan

-- Getting to know the tables
select * from plans_plan;
select * from savings_savingsaccount;
select * from users_customuser;
select * from withdrawals_withdrawal;


-- Pre-aggregate savings(Pre-calculate total savings per user) using Subqueries and CTE's(common table expressions)
-- to Reduces data size during joins, Speed up execution, Prevent server timeouts.
WITH savings_totals AS (
    SELECT owner_id, SUM(confirmed_amount) AS total_savings
    FROM savings_savingsaccount
    GROUP BY owner_id
),

-- Pre-aggregate withdrawals(Pre-calculate total withdraws per user) using Subqueries 
-- and CTE's(common table expressions)
-- to Reduces data size during joins, Speed up execution, Prevent server timeouts.
withdrawal_totals AS (
    SELECT owner_id, SUM(amount_withdrawn) AS total_withdrawals
    FROM withdrawals_withdrawal
    GROUP BY owner_id
)
--  Main Query
SELECT
    u.id AS owner_id,
    CONCAT_ws(' ', u.first_name, u.last_name) AS name, #join the first and last name to get the fullname
    
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count, #Count savings plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count, #Count investment plans
    
    ROUND(
        (COALESCE(s.total_savings, 0) - COALESCE(w.total_withdrawals, 0)) / 100.0, 0)
        AS total_deposits #Safely compute deposits (treat NULLs as 0) and converts the total deposit to naira
                        # leaving it in zero decimal places.
FROM users_customuser u

JOIN plans_plan p ON u.id = p.owner_id
LEFT JOIN savings_totals s ON s.owner_id = u.id
LEFT JOIN withdrawal_totals w ON w.owner_id = u.id

GROUP BY u.id, u.first_name, u.last_name

HAVING savings_count >= 1 AND investment_count >= 1 #Ensures that both requirements are met

ORDER BY total_deposits DESC;


