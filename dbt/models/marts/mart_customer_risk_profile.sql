select
    customer_id,
    count() as transaction_count,
    min(transaction_time) as first_transaction_at,
    max(transaction_time) as last_transaction_at,
    sum(is_fraud) as fraud_count,
    100.0 * avg(is_fraud) as fraud_rate,
    avg(amount) as avg_amount,
    sum(amount) as total_amount,
    case
        when fraud_rate >= 5 then 'HIGH'
        when fraud_rate >= 1 then 'MEDIUM'
        else 'LOW'
    end as risk_level
from {{ ref('stg_transactions') }}
group by customer_id
