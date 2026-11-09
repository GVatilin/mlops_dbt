select
    toDateTime(transaction_time) as transaction_time,
    toDate(transaction_time) as transaction_date,
    {{ dbt_date.day_of_week('transaction_time', isoweek=true) }} as day_of_week,
    toHour(transaction_time) as hour,
    trimBoth(merch) as merchant,
    lowerUTF8(trimBoth(cat_id)) as category,
    toFloat64(amount) as amount,
    {{ amount_bucket('amount') }} as amount_bucket,
    {{ dbt_utils.generate_surrogate_key(['name_1', 'name_2', 'street', 'post_code']) }} as customer_id,
    upperUTF8(trimBoth(gender)) as gender,
    upperUTF8(trimBoth(us_state)) as state,
    toUInt8(target) as is_fraud
from {{ source('raw', 'transactions') }}
