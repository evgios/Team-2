from datetime import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator


with DAG(
    dag_id='simple_test_query',
    description='This is the required test query to the source database',
    start_date=datetime(2024, 7, 6),
    schedule_interval='@daily',
    catchup=False
) as dag:
    empty0 = EmptyOperator(
        task_id='empty_start'
    )
    sql= SQLExecuteQueryOperator(
        task_id='simple_query',
        conn_id='source',
        sql="""
            SELECT *
            FROM source.source_data.образование_пользователей
            LIMIT 2
        """
    )
    empty1 = EmptyOperator(
        task_id='empty_finish'
    )

    empty0 >> sql >> empty1
