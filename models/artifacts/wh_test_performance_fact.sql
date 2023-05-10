{{ config(
    tags=["artifacts", "test_results", "history"],
    alias='test_performance_fact',
    unique_key='test_performance_pk'
) }}

with test_results_nodes as (
    select * from {{ ref('stg_run_results') }}
    where execution_command='test'
),

query_history as (
    select * from {{ ref('stg_query_history') }}
),

joint as (

    select
        {{ dbt_utils.generate_surrogate_key(['model_name', 'artifact_run_id', 'start_date', 'end_date']) }} as test_performance_pk,
        r.*
    from test_results_nodes as r

)

select * from joint
