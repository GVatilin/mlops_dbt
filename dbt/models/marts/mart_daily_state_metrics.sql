select
    transaction_date,
    state,
    count() as transaction_count,
    sum(amount) as total_amount,
    avg(amount) as avg_amount,
    quantileExact(0.95) (amount) as p95_amount,
    avg(amount_bucket = 'LARGE') as large_transaction_share
from {{ ref('stg_transactions') }}
group by transaction_date, state
