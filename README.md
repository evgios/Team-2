# Team-2
Репозиторий проекта Команды 2 стажировка ДАР_2024

de_files/ - содержит результат работы дата-инженеров


./ioskevich_files/ - директория дата-инженера Иоскевич Е.С.

docker-compose.yaml - файл проекта, определяющий службы, сети и тома для приложения Docker

Архитектурное решение.docx - содержит описание архитектурного решения для проекта


./config/ - директория конфигураций для docker-compose

connections.json - соединепния для проекта


./dags/ - файлы DAG, задействованные в проекте

dag_sourse.py - тестовый даг для проверки соединения с БД

transfer.py - даг для первоначального копиррования данных из слоя Source в слой ODS

update schemas.py - основной даг проекта, осуществляющий ежедневное обновления данных по слоям ODS, DDS и Datamart


./include/SQL scripts/ - SQL скрипты, задействованые в проекте для формирования слоев ODS, DDS и Datamart

ODS create tables sql scripts.sql - первоначальное создание таблиц слоя ODS

ODS clear.sql - очистка таблиц слоя ODS

DDS create tables sql scripts.sql - первоначальное создание таблиц слоя DDS

DDS filling.sql - заполнение таблиц слоя DDS, включая очистку и подготовку данных

Datamart create tables sql scripts.sql - первоначальное создание таблиц слоя Datamart

Datamart filling.sql - заполнение таблиц слоя Datamert
