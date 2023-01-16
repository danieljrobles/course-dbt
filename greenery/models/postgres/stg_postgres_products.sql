with src_products as (
    select * from {{ source('postgres','products')}}
)

, renamed_recast as (
    select  
        product_id
        , name
        , price
        , inventory
    from src_products
)

select * from renamed_recast