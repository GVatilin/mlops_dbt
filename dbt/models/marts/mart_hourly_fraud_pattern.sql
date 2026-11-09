select
    day_of_week,
    hour,
    count() as transaction_count,
    sum(is_fraud) as fraud_count,
    100.0 * avg(is_fraud) as fraud_rate,
    sum(amount) as total_amount,
    fraud_rate >= 5 as is_high_risk
from {{ ref('stg_transactions') }}
group by day_of_week, hour
