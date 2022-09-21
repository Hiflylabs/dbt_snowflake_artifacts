{{ config(
    tags=["artifacts", "history"]
) }}

with source as (
    select * from {{ source('snowflake', 'query_history') }}
),

query_history as (
    select
        query_id,
        query_text,
        query_type,
        total_elapsed_time / 60000 as total_elapsed_time_min,
        user_name,
        warehouse_size,
        partitions_total,
        partitions_scanned,
        bytes_spilled_to_local_storage,
        bytes_spilled_to_remote_storage,
        credits_used_cloud_services,
        rows_produced,
        -- needs to be updated if snowlfake changes pricing policy
        case
            when warehouse_size = 'X-Small'
                then 1
            when warehouse_size = 'Small'
                then 2
            when warehouse_size = 'Medium'
                then 4
            when warehouse_size = 'Large'
                then 8
            when warehouse_size = 'X-Large'
                then 16
            when warehouse_size = '2X-Large'
                then 32
            when warehouse_size = '3X-Large'
                then 64
            when warehouse_size = '4X-Large'
                then 128
            when warehouse_size = '5X-Large'
                then 256
            when warehouse_size = '6X-Large'
                then 512
            else 0
        end as warehouse_credits_hourly
    from source
)

select * from query_history
