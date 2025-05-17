-- Combine the first and last name to get the full name
SELECT
    u.id AS customer_id,
    CONCAT_WS(' ', u.first_name, u.last_name) AS name,

    -- Calculates account tenure in months from date joined to current date
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Count of all savings transactions (assumed one row = one transaction)
    COUNT(s.savings_id) AS total_transactions,

    -- Estimate CLV using the formula:
    -- (total_transactions / tenure) * 12 * avg_profit_per_transaction
    ROUND(
        (COUNT(s.savings_id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1)) * 12 *
        (0.001 * COALESCE(SUM(s.confirmed_amount), 0) / GREATEST(COUNT(s.savings_id), 1)),
        3
    ) AS estimated_clv
FROM users_customuser u

-- Join to savings transactions
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id

-- Group by each user
GROUP BY u.id, u.first_name, u.last_name, u.date_joined

-- Rank users by highest CLV
ORDER BY estimated_clv DESC;
