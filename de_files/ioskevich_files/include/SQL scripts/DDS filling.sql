INSERT INTO dds."базы_данных" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."базы_данных";

UPDATE datamart."базы_данных"
  SET "Дата" = "Дата" - make_interval(years => 100)
where "Дата" = '2123-07-20';

INSERT INTO dds."сотрудники_дар" 
	("User ID",
	"Активность",
	"Последняя авторизация", 
	"Должность", 
	"ЦФО", 
	"Подразделения")
SELECT "id",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность",
	CASE WHEN length("Последняя авторизация") = 0 THEN NULL 
	ELSE CAST(replace("Последняя авторизация", ' %', '') as date)
	end as "Последняя авторизация",
	"должность",
	"цфо",
	"подразделения",
FROM ods."сотрудники_дар"
where length("должность") != 0;

INSERT INTO dds."уровни_знаний" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм." , ' %', '') as date), 
	"id" 
FROM ods."уровни_знаний";

INSERT INTO dds."уровни_знаний"
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID")
VALUES ('Данные отсутствуют', 'yes'::boolean, '2024-07-11', 283045);

INSERT INTO dds."базы_данных_и_уровень_знаний_сотру" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Базы данных", 
	"Дата", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when regexp_replace("Базы данных", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("Базы данных", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Базы данных", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0 then "Данные отсутствуют"
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') 
	end as "Уровень знаний"
FROM ods."базы_данных_и_уровень_знаний_сотру"
where CAST(substring("название", 6, length("название")-5) as int4) 
	in (select "User ID" from dds."сотрудники_дар");

UPDATE datamart."базы_данных_и_уровень_знаний_сотру"
  SET "Дата" = "Дата" - make_interval(years => 100)
where "Дата" in ('2119-04-01', '2123-07-20');

UPDATE datamart."базы_данных_и_уровень_знаний_сотру"
  SET "Дата" = "Дата" - make_interval(years => 200)
where "Дата" = '2221-02-01';

INSERT INTO dds."уровень_образования" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм." , ' %', '') as date), 
	"id" 
FROM ods."уровень_образования";

INSERT INTO dds."языки" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм." , ' %', '') as date), 
	"id" 
FROM ods."языки";

INSERT INTO dds."уровни_владения_ин" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм." , ' %', '') as date), 
	"id" 
FROM ods."уровни_владения_ин";

INSERT INTO dds."языки_пользователей" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Язык", 
	"Уровень знаний ин. языка") 
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when regexp_replace("язык", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("язык", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("язык", ' \[.+?\]', '', 'g')
	end as "язык",
	case when length("Уровень знаний ин. языка") = 0 then 'A1 – elementary'
	else regexp_replace("Уровень знаний ин. языка", ' \[.+?\]', '', 'g') 
	end as "Уровень знаний ин. языка"
FROM ods."языки_пользователей"
where "название" like 'User:%' and CAST(substring("название", 6, length("название")-5) as int4) 
	in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."сертификаты_пользователей"
	("User ID",
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Год сертификата", 
	"Наименование сертификата", 
	"Организация, выдавшая сертификат")
SELECT distinct 
	"User ID" int4,
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	"Год сертификата",
	"Наименование сертификата",
	"Организация, выдавшая сертификат"
from ods."сертификаты_пользователей"
where "User ID" in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."инструменты" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."инструменты";

INSERT INTO dds."инструменты_и_уровень_знаний_сотр" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Инструменты", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("инструменты", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("инструменты", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("инструменты", ' \[.+?\]', '', 'g')
	end as "Инструменты",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') 
	end as "Уровень знаний"
FROM ods."инструменты_и_уровень_знаний_сотр"
where CAST(substring("название", 6, length("название")-5) as int4) 
	in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."отрасли" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."отрасли";

INSERT INTO dds."уровни_знаний_в_отрасли" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."уровни_знаний_в_отрасли";

INSERT INTO dds."уровни_знаний_в_отрасли" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID")
VALUES ('Уровень знаний отрасли не указан', 'yes'::boolean, '2024-07-11', 115775);

INSERT INTO dds."опыт_сотрудника_в_отраслях" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Отрасли", 
	"Дата", 
	"Уровень знаний в отрасли") 
SELECT "User ID",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when regexp_replace("отрасли", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("отрасли", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("отрасли", ' \[.+?\]', '', 'g')
	end as "Отрасли",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний в отрасли") = 0 then 'Уровень знаний отрасли не указан'
	else regexp_replace("Уровень знаний в отрасли", ' \[.+?\]', '', 'g')
	end as "Уровень знаний в отрасли"
FROM ods."опыт_сотрудника_в_отраслях"
where "User ID" in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."образование_пользователей" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Уровень образования",	
	"Название учебного заведения", 
	"Фиктивное название", 
	"Факультет, кафедра", 
	"Специальность", 
	"Квалификация", 
	"Год окончания") 
SELECT distinct 
	"User ID",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when length("Уровень образование") = 0 then 'Не указано'
	else regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	end as "Уровень образование",
	"Название учебного заведения", 
	"Фиктивное название",
	"Факультет, кафедра",
	case when length("специальность") = '' then null
	else "специальность"
	end as "специальность",
	"квалификация",
	case when "Год окончания" = 0 then NULL 
	else "Год окончания"
	end as "Год окончания"
FROM ods."образование_пользователей"
where "User ID" in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."платформы" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."платформы";

INSERT INTO dds."платформы_и_уровень_знаний_сотруд" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Платформы", 
	"Дата", 
	"Уровень знаний") 
SELECT distinct 
	"User ID",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when regexp_replace("платформы", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("платформы", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("платформы", ' \[.+?\]', '', 'g')
	end as "платформы",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') end as "Уровень знаний"
FROM ods."платформы_и_уровень_знаний_сотруд"
where "User ID" in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."предметная_область" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."предметная_область";

INSERT INTO dds."уровни_знаний_в_предметной_област" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."уровни_знаний_в_предметной_област";

INSERT INTO dds."уровни_знаний_в_предметной_област" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID")
VALUES ('Уровень знаний не указан', 'yes'::boolean, '2024-07-11', 115764);

INSERT INTO dds."опыт_сотрудника_в_предметных_обла" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Предметные области", 
	"Дата", 
	"Уровень знаний в предметной облас") 
SELECT distinct 
	"User ID",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	case when regexp_replace("Предментые области", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("Предментые области", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Предментые области", ' \[.+?\]', '', 'g')
	end as "Отрасли",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний в предметной облас") = 0 then 'Уровень знаний не указан'
	else regexp_replace("Уровень знаний в предметной облас", ' \[.+?\]', '', 'g') 
	end as "Уровень знаний в предметной облас"
FROM ods."опыт_сотрудника_в_предметных_обла"
where "User ID" in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."среды_разработки" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."среды_разработки";

INSERT INTO dds."среды_разработки_и_уровень_знаний_" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Среды разработки", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("Среды разработки", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("Среды разработки", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Среды разработки", ' \[.+?\]', '', 'g')
	end as "Среды разработки",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') end as "Уровень знаний"
FROM ods."среды_разработки_и_уровень_знаний_"
where length("Уровень знаний") != 0 
and CAST(substring("название", 6, length("название")-5) as int4) in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."типы_систем" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."типы_систем";

INSERT INTO dds."типы_систем_и_уровень_знаний_сотру" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Типы систем", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN (replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("Типы систем", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("Типы систем", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Типы систем", ' \[.+?\]', '', 'g')
	end as "Типы систем",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') 
	end as "Уровень знаний"
FROM ods."типы_систем_и_уровень_знаний_сотру"
where CAST(substring("название", 6, length("название")-5) as int4) in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."фреймворки" 
	("Название", "Активность", "Дата изм.", "ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."фреймворки";

INSERT INTO dds."фреймворки_и_уровень_знаний_сотру" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Фреймворки", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("фреймворки", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("фреймворки", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("фреймворки", ' \[.+?\]', '', 'g')
	end as "Фреймворки",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') end as "Уровень знаний"
FROM ods."фреймворки_и_уровень_знаний_сотру"
where CAST(substring("название", 6, length("название")-5) as int4) in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."языки_программирования" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."языки_программирования";

INSERT INTO dds."языки_программирования_и_уровень" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Языки программирования", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("Языки программирования", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("Языки программирования", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Языки программирования", ' \[.+?\]', '', 'g')
	end as "Языки программирования",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') end as "Уровень знаний"
FROM ods."языки_программирования_и_уровень"
where CAST(substring("название", 6, length("название")-5) as int4) in (select "User ID" from dds."сотрудники_дар");

INSERT INTO dds."технологии" 
	("Название", 
	"Активность", 
	"Дата изм.", 
	"ID") 
SELECT "название", 
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST("Дата изм." AS date), 
	"id" 
FROM ods."технологии";

INSERT INTO dds."технологии_и_уровень_знаний_сотру" 
	("User ID", 
	"Активность", 
	"Дата изм.", 
	"ID", 
	"Дата", 
	"Технологии", 
	"Уровень знаний") 
SELECT distinct 
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	case when "активность" = 'Да' then 'yes'::boolean 
	when "активность" = 'Нет' then 'no'::boolean 
	end as "активность", 
	CAST(replace("Дата изм.", ' %', '') AS date), 
	"id",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date) 
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("технологии", ' \[.+?\]', '', 'g') like '%  %' 
	then replace(regexp_replace("технологии", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("технологии", ' \[.+?\]', '', 'g')
	end as "технологии",
	case when length("Уровень знаний") = 0 then 'Данные отсутствуют'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') end as "Уровень знаний"
FROM ods."технологии_и_уровень_знаний_сотру"
where CAST(substring("название", 6, length("название")-5) as int4) in (select "User ID" from dds."сотрудники_дар");

