with src_order_items as (
    select * from {{ source('postgres','order_items')}}
)

, renamed_recast as (
    select  
        order_id
        , product_id
        , quantity        
    from src_order_items
)

select * from renamed_recast