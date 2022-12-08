# The name of this view in Looker is "Wh Model Dags"
view: model_dags_dim{
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: {{ _user_attributes['dbt_database'] }}.{{ _user_attributes['dataset'] }}_ARTIFACTS."MODEL_DAGS_DIM"
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Model Name" in Explore.

  dimension: model_name {
    type: string
    sql: ${TABLE}."MODEL_NAME" ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}."TAGS" ;;
  }

  dimension: upstream_dependencies {
    type: string
    sql: ${TABLE}."UPSTREAM_DEPENDENCIES" ;;
  }

  measure: count {
    type: count
    drill_fields: [model_name]
  }
}
