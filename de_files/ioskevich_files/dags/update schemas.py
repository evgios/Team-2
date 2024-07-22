from airflow.models.dag import DAG
from airflow.operators.generic_transfer import GenericTransfer
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
import datetime
from airflow.utils.task_group import TaskGroup

table_names = ['"базы_данных"', '"базы_данных_и_уровень_знаний_сотру"',
               '"инструменты"', '"инструменты_и_уровень_знаний_сотр"',
               '"образование_пользователей"', '"опыт_сотрудника_в_отраслях"',
               '"опыт_сотрудника_в_предметных_обла"', '"отрасли"',
               '"платформы"', '"платформы_и_уровень_знаний_сотруд"',
               '"предметная_область"', '"резюмедар"',
               '"сертификаты_пользователей"', '"сотрудники_дар"',
               '"среды_разработки"', '"среды_разработки_и_уровень_знаний_"',
               '"технологии"', '"технологии_и_уровень_знаний_сотру"',
               '"типы_систем"', '"типы_систем_и_уровень_знаний_сотру"',
               '"уровень_образования"', '"уровни_владения_ин"',
               '"уровни_знаний"', '"уровни_знаний_в_отрасли"',
               '"уровни_знаний_в_предметной_област"', '"фреймворки"',
               '"фреймворки_и_уровень_знаний_сотру"', '"языки"',
               '"языки_пользователей"', '"языки_программирования"',
               '"языки_программирования_и_уровень"']

with DAG(
    dag_id="update_schemas",
    catchup=False,
    start_date=datetime.datetime(2024, 7, 26),
    schedule="@daily",
    template_searchpath="/opt/airflow/include/SQL scripts",
    tags=["postgresql", "team2"],
    ) as dag:

        clear_ods_tables = SQLExecuteQueryOperator(
        task_id="clear_ods_tables",
        conn_id='conn_etl_db_2',
        sql="ODS clear.sql",
        show_return_value_in_logs=True)

        with TaskGroup(group_id='from_sourse_to_ods') as group_processes:
                count_table = 0
                for name in table_names:
                    from_sourse_to_ods = GenericTransfer(
                    task_id = f"from_sourse_to_ods_{count_table}",
                    source_conn_id = 'sourse_connect',
                    destination_conn_id = 'conn_etl_db_2',
                    sql = f"SELECT * FROM source_data.{name}",
                    destination_table = f"ods.{name}")
                    count_table += 1

        fill_dds_tables = SQLExecuteQueryOperator(
        task_id="dds_fill_tables",
        conn_id='conn_etl_db_2',
        sql="DDS filling.sql",
        show_return_value_in_logs=True
        )

        fill_dm_tables = SQLExecuteQueryOperator(
        task_id="datamart_fill_tables",
        conn_id='conn_etl_db_2',
        sql="Datamart filling.sql",
        show_return_value_in_logs=True
        )

clear_ods_tables >> group_processes >> fill_dds_tables >> fill_dm_tables