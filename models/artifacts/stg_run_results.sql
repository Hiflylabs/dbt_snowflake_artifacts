{{ config(
    tags=["artifacts", "run_results"]
) }}

with source as (
    select * from {{ source('dbt_artifacts', 'dbt_run_results_nodes') }}
),

run_results_nodes as (

    select
        artifact_run_id,
        compile_started_at::timestamp as start_date,
        query_completed_at::timestamp as end_date,
        execution_command,
        was_full_refresh,
        trim(split(node_id, '.')[2], '"') as model_name,
        upper(status) as status,
        total_node_runtime,
        result_json:adapter_response:query_id as query_id,
        case when status = 'error' or status = 'fail' or status = 'warn'
            then result_json:message
            else null
        end as error_message
    from source

)

select * from run_results_nodes
