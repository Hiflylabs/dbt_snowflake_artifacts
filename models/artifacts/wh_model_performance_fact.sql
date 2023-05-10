{{ config(
    tags=["artifacts", "run_results", "history"],
    alias='model_performance_fact',
    unique_key='model_performance_pk'
) }}

with run_results_nodes as (
    select * from {{ ref('stg_run_results') }}
    where execution_command='run'
),

query_history as (
    select * from {{ ref('stg_query_history') }}
),

joint as (

    select
        {{ dbt_utils.generate_surrogate_key(['model_name', 'artifact_run_id', 'start_date', 'end_date']) }} as model_performance_pk,
        r.*,
        q.query_type,
        q.query_text,
        q.user_name,
        q.total_elapsed_time_min,
        q.warehouse_size,
        q.partitions_total,
        q.partitions_scanned,
        q.rows_produced,
        q.bytes_spilled_to_local_storage,
        q.bytes_spilled_to_remote_storage,
        q.credits_used_cloud_services,
        q.warehouse_credits_hourly,
        total_elapsed_time_min * warehouse_credits_hourly / 60 as est_credits_used,
        -- currently using business critical subscription
        {{ var('snowflake_contract_rate') }} * est_credits_used    as est_cost
    from run_results_nodes as r
    left join query_history as q on q.query_id = r.query_id

)

select * from joint
