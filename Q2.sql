-- Calculating the total number of transactions and active months per user
WITH monthly_transactions AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,  -- Count of all transactions made by the user
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS active_months  
        -- Calculates the number of months between the first and last transaction (inclusive)
    FROM savings_savingsaccount 
    GROUP BY owner_id
),

-- Calculating the average transactions per user per month
avg_tx_per_user AS (
    SELECT
        owner_id,
        ROUND(total_transactions / active_months, 3) AS avg_transactions_per_month  # Average monthly transaction rate
    FROM monthly_transactions
),

-- Categorizes each user based on average transactions per month
categorized_users AS (
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'   #10 or more transactions/month
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency' #3 to 9/month
            ELSE 'Low Frequency'  #2 or fewer transactions/month
        END AS frequency_category
    FROM avg_tx_per_user
)

#Final Output: Count of customers in each category and their average transaction frequency
SELECT
    frequency_category,
    COUNT(*) AS customer_count, #Total number of customers in each frequency category
    ROUND(AVG(avg_transactions_per_month), 3) AS avg_transactions_per_month #Average transaction rate in the category
FROM (
    #Inline subquery to associate each user with their frequency category
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_tx_per_user 
) AS sub
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency'); 
#Ensure output appears in specific order: High → Medium → Low
