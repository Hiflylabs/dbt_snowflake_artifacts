# The name of this view in Looker is "Stg Run Results"
view: model_performance_fact {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: {{ _user_attributes['dbt_database'] }}.{{ _user_attributes['dataset'] }}_ARTIFACTS."MODEL_PERFORMANCE_FACT"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."END_DATE" ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Artifact Run ID" in Explore.

  dimension: artifact_run_id {
    type: string
    sql: ${TABLE}."ARTIFACT_RUN_ID" ;;
  }

  dimension: bytes_spilled_to_local_storage {
    type: number
    sql: ${TABLE}."BYTES_SPILLED_TO_LOCAL_STORAGE" ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  dimension: bytes_spilled_to_remote_storage {
    type: number
    sql: ${TABLE}."BYTES_SPILLED_TO_REMOTE_STORAGE" ;;
  }

  dimension: command_invocation_id {
    type: string
    sql: ${TABLE}."COMMAND_INVOCATION_ID" ;;
  }

  dimension_group: compile_started {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CAST(${TABLE}."COMPILE_STARTED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: credits_used_cloud_services {
    type: number
    sql: ${TABLE}."CREDITS_USED_CLOUD_SERVICES" ;;
  }

  dimension: dbt_cloud_run_id {
    type: number
    sql: ${TABLE}."DBT_CLOUD_RUN_ID" ;;
  }

  dimension: execution_command {
    type: string
    sql: ${TABLE}."EXECUTION_COMMAND" ;;
  }

  dimension: model_name {
    type: string
    sql: ${TABLE}."MODEL_NAME" ;;
  }

  dimension: error_message {
    type: string
    sql: ${TABLE}."ERROR_MESSAGE" ;;
  }

  dimension: query_text {
    type: string
    sql: ${TABLE}."QUERY_TEXT" ;;
  }

  dimension: partitions_scanned {
    type: number
    sql: ${TABLE}."PARTITIONS_SCANNED" ;;
  }

  dimension: partitions_total {
    type: number
    sql: ${TABLE}."PARTITIONS_TOTAL" ;;
  }

  dimension_group: query_completed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CAST(${TABLE}."QUERY_COMPLETED_AT" AS TIMESTAMP_NTZ) ;;
  }

  dimension: query_id {
    type: string
    sql: ${TABLE}."QUERY_ID" ;;
  }

  dimension: query_type {
    type: string
    sql: ${TABLE}."QUERY_TYPE" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
    html:
    {% if value == 'SUCCESS' %}
    <p style="color: green; background-color: green; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'SKIP' %}
    <p style="color: yellow; background-color: yellow; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
    <p style="color: red; background-color: red; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
    ;;
  }

  dimension: total_elapsed_time_min {
    type: number
    sql: ${TABLE}."TOTAL_ELAPSED_TIME_MIN" ;;
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}."USER_NAME" ;;
  }

  dimension: warehouse_size {
    type: string
    sql: ${TABLE}."WAREHOUSE_SIZE" ;;
  }

  dimension: was_full_refresh {
    type: yesno
    sql: ${TABLE}."WAS_FULL_REFRESH" ;;
  }

  dimension: warehouse_credits_hourly {
    type: number
    sql: ${TABLE}."WAREHOUSE_CREDITS_HOURLY" ;;
  }

  dimension: est_cost {
    type: number
    value_format_name: usd
    sql: ${TABLE}."EST_COST" ;;
  }

  dimension: est_credits_used {
    type: number
    sql: ${TABLE}."EST_CREDITS_USED" ;;
  }

  dimension: partioned_scanned_pct {
    type: number
    sql: DIV0(${partitions_scanned},${partitions_total});;
  }

  measure: successful_runs {
    type: sum
    sql: case when ${status} = 'SUCCESS' then 1 else 0 end;;
  }

  measure: total_runs {
    type: count
  }

  dimension: rows_produced {
    type: number
    sql: ${TABLE}."ROWS_PRODUCED" ;;
  }

  measure: total_runtime {
    type: sum
    sql: ${total_elapsed_time_min};;
  }

  measure: total_credits {
    type: sum
    sql: ${credits_used_cloud_services} ;;
  }

  measure: average_runtime {
    label: "Average Runtime (Min)"
    type: sum
    sql: ${total_elapsed_time_min};;
  }

  measure: average_credits {
    type: average
    sql: ${credits_used_cloud_services} ;;
  }

  measure: total_bytes_spilled_to_local_storage {
    type: sum
    sql: ${bytes_spilled_to_local_storage} ;;
  }

  measure: average_bytes_spilled_to_local_storage {
    type: average
    sql: ${bytes_spilled_to_local_storage} ;;
  }


  measure: total_bytes_spilled_to_remote_storage {
    type: sum
    sql: ${bytes_spilled_to_remote_storage} ;;
  }

  measure: average_bytes_spilled_to_remote_storage {
    type: average
    sql: ${bytes_spilled_to_remote_storage} ;;
  }

  measure: total_rows_produced {
    type: sum
    sql: ${rows_produced} ;;
  }

  measure: average_rows_produced {
    type: average
    sql: ${rows_produced};;
  }

  measure: total_est_cost {
    type: sum
    value_format_name: usd
    sql: ${est_cost} ;;
  }

  measure: average_est_cost{
    type: average
    value_format_name: usd
    sql: ${est_cost};;
  }

  measure: total_est_credits_used {
    type: sum
    sql: ${est_credits_used} ;;
  }

  measure: average_est_credits_used{
    type: average
    sql: ${est_credits_used};;
  }

  measure: average_partioned_scanned_pct {
    type: average
    value_format_name: percent_2
    sql: ${partioned_scanned_pct} ;;
  }

}
