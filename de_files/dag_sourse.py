from airflow.models.dag import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id="dag_sourse_connect",
    catchup=False,
    start_date=None,
    schedule=None,
    tags=["postgresql", "first-task"],
) as dag1:

    get_all_schemas = SQLExecuteQueryOperator(
    task_id="get_all_schemas",
    conn_id="sourse_connect",
    sql='SELECT * FROM source_data."базы_данных"',
    show_return_value_in_logs=True
)
