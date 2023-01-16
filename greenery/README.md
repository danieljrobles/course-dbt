Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

### Week 1:
* How many users do we have?
Answer
`130`

SQL
```
select 
    count(distinct email)   as count_of_unique_email
    , count(email)          as count_of_all_email
from dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_users
```

Output
```
+-----------------------+--------------------+
| COUNT_OF_UNIQUE_EMAIL | COUNT_OF_ALL_EMAIL |
+-----------------------+--------------------+
| 130                   | 130                |
+-----------------------+--------------------+
```

* On average, how many orders do we receive per hour?
Answer
`7.680851`

SQL
```
select 
    min(created_at)             as first_order_datetime
    , max(created_at)           as last_order_datetime
    , count(distinct order_id)  as total_unique_orders
    , datediff('hour', first_order_datetime, last_order_datetime) as time_period_hours
    , total_unique_orders/time_period_hours as avg_orders_per_hour
from dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_orders
```

Output
```
+-------------------------+-------------------------+---------------------+-------------------+---------------------+
| FIRST_ORDER_DATETIME    | LAST_ORDER_DATETIME     | TOTAL_UNIQUE_ORDERS | TIME_PERIOD_HOURS | AVG_ORDERS_PER_HOUR |
+-------------------------+-------------------------+---------------------+-------------------+---------------------+
| 2021-02-10 00:00:05.000 | 2021-02-11 23:55:36.000 | 361                 | 47                | 7.680851            |
+-------------------------+-------------------------+---------------------+-------------------+---------------------+
```
* On average, how long does an order take from being placed to being delivered?
Answer
`3.891803278689 days`

SQL
```
select 
    avg(time_to_delivery_seconds) as avg_time_to_delivery_seconds
    , avg(time_to_delivery_days) as avg_time_to_delivery_days
from
(
    select 
        created_at
        , delivered_at
        , datediff('second', created_at, delivered_at) as time_to_delivery_seconds
        , time_to_delivery_seconds / 60 / 60 / 24 as time_to_delivery_days
    from dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_orders
)
```

Output
```
+------------------------------+---------------------------+
| AVG_TIME_TO_DELIVERY_SECONDS | AVG_TIME_TO_DELIVERY_DAYS |
+------------------------------+---------------------------+
| 336,251.803279               | 3.891803278689            |
+------------------------------+---------------------------+
```
* How many users have only made one purchase? Two purchases? Three+ purchases?
Answer
`see output`

SQL
```
select 
    total_orders
    , count(distinct user_id)
from
(
    select 
        users.user_id
        , count(distinct orders.order_id) as total_orders
    from dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_orders orders
    join dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_users users on orders.user_id = users.user_id
    group by 
        users.user_id
)
group by 
    total_orders
order by 
    total_orders
```

Output
`+--------------+-------------------------+
| TOTAL_ORDERS | COUNT(DISTINCT USER_ID) |
+--------------+-------------------------+
| 1            | 25                      |
+--------------+-------------------------+
| 2            | 28                      |
+--------------+-------------------------+
| 3            | 34                      |
+--------------+-------------------------+
| 4            | 20                      |
+--------------+-------------------------+
| 5            | 10                      |
+--------------+-------------------------+
| 6            | 2                       |
+--------------+-------------------------+
| 7            | 4                       |
+--------------+-------------------------+
| 8            | 1                       |
+--------------+-------------------------+``
```

* On average, how many unique sessions do we have per hour?
Answer
``

SQL
```
select 
    count(distinct session_id)/24 as avg_sessions_per_hour
from dev_db.dbt_danielroblesgetordermarkcom.stg_postgres_events
```

Output
```
+-----------------------+
| AVG_SESSIONS_PER_HOUR |
+-----------------------+
| 24.083333             |
+-----------------------+
```