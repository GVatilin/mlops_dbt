select
    merchant,
    count() as transaction_count,
    sum(is_fraud) as fraud_count,
    sum(amount) as turnover,
    sumIf(amount, is_fraud = 1) as fraud_amount,
    100.0 * avg(is_fraud) as fraud_rate,
    fraud_rate >= 5 as is_suspicious
from {{ ref('stg_transactions') }}
group by merchant
