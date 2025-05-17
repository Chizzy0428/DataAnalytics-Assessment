-- To Get the last inflow transaction date for each plan
WITH inflow_dates AS (
    SELECT
        s.plan_id,
        MAX(s.transaction_date) AS last_transaction_date  -- Most recent inflow transaction per plan
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount > 0  -- Only consider transactions with confirmed inflows
    GROUP BY s.plan_id
),

-- Identifying the type of each plan (Savings or Investment)
plan_types AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings'  -- Flag as Savings
            WHEN p.is_a_fund = 1 THEN 'Investment'         -- Flag as Investment
            ELSE 'Other'                                  -- Any other types
        END AS type
    FROM plans_plan p
    WHERE p.is_archived = 0 AND p.is_deleted = 0  -- Only include active, non-deleted plans
),

-- To Combine plan type and last inflow date, and calculate inactivity in days
combined AS (
    SELECT
        pt.plan_id,
        pt.owner_id,
        pt.type,
        i.last_transaction_date,
        DATEDIFF(CURDATE(), i.last_transaction_date) AS inactivity_days  -- Days since last inflow
    FROM plan_types pt
    LEFT JOIN inflow_dates i ON pt.plan_id = i.plan_id  -- Merge to get transaction info per plan
)

-- Final Output: Get plans that are inactive or never had a transaction
SELECT *
FROM combined
WHERE (last_transaction_date IS NULL OR inactivity_days > 365)  -- Inactive for over a year or no transactions at all
ORDER BY inactivity_days DESC;  -- Show longest inactive plans first

