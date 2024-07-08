from airflow import DAG
from airflow.operators.generic_transfer import GenericTransfer


table_names = ['"базы_данных"', '"базы_данных_и_уровень_знаний_сотру"', '"инструменты"',
               '"инструменты_и_уровень_знаний_сотр"', '"образование_пользователей"', '"опыт_сотрудника_в_отраслях"',
               '"опыт_сотрудника_в_предметных_обла"', '"отрасли"', '"платформы"', '"платформы_и_уровень_знаний_сотруд"',
               '"предметная_область"', '"резюмедар"', '"сертификаты_пользователей"', '"сотрудники_дар"',
               '"среды_разработки"', '"среды_разработки_и_уровень_знаний_"', '"технологии"',
               '"технологии_и_уровень_знаний_сотру"', '"типы_систем"', '"типы_систем_и_уровень_знаний_сотру"',
               '"уровень_образования"', '"уровни_владения_ин"', '"уровни_знаний"', '"уровни_знаний_в_отрасли"',
               '"уровни_знаний_в_предметной_област"', '"фреймворки"', '"фреймворки_и_уровень_знаний_сотру"',
               '"языки"', '"языки_пользователей"', '"языки_программирования"', '"языки_программирования_и_уровень"']

with DAG(
      dag_id="dag_transfer",
      catchup=False,
      start_date=None,
       schedule=None,
       tags=["postgresql", "copy-task"],
    ) as dag:
          count_table = 0
          for name in table_names:
               copy_task = GenericTransfer(
               task_id = f"transfer_task_{count_table}",
               source_conn_id = 'sourse_connect',
               destination_conn_id = 'conn_etl_db_2',
               sql = f"SELECT * FROM source_data.{name}",
               destination_table = f"ods.{name}")
               count_table += 1
