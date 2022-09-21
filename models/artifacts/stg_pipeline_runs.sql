{{ config(
    tags=["artifacts", "pipeline"]
) }}

with source as (
    select * from {{ source('dbt_artifacts', 'dbt_run_results') }}
),

pipeline_runs as (

    select
        artifact_generated_at as run_start,
        elapsed_time as run_elapsed_time,
        array_to_string(selected_models, ',') as run_selection
    from source

)

select * from pipeline_runs
