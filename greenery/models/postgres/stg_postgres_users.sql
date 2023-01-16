with src_users as (
    select * from {{ source('postgres','users')}}
)

, renamed_recast as (
    select  
        user_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
        , address_id
    from src_users
)

select * from renamed_recast