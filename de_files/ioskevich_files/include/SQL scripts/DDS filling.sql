INSERT INTO dds.employees (
	"user_id",
	"active",
	"job_title",
	"emp_role",
	"emp_level")
SELECT "id",
	case when "активность" = 'Да' then 'yes'::boolean
	when "активность" = 'Нет' then 'no'::boolean
	end as "активность",
	CASE WHEN "должность" = 'Аналитик,Департамент систем бизнес-аналитики' THEN 'Бизнес-аналитик'
	when "должность" = 'старший системный аналитик' then 'Старший системный аналитик'
	ELSE "должность"
	END as "должность",
	CASE WHEN "должность" like '%уководитель%' THEN 'Руководитель проектов'
	WHEN "должность" like ANY (ARRAY['Аналитик', 'Старший аналитик', 'Аналитик технической поддержки',
	'Ведущий аналитик', 'Ведущий системный аналитик', 'Младший аналитик', 'Младший системный аналитик',
	'Системный аналитик', 'старший системный аналитик', 'Эксперт-аналитик', 'Эксперт по анализу данных'])
	THEN 'Системный аналитик'
	WHEN "должность" like ANY (ARRAY['%изнес-аналитик', 'Пресейл-аналитик',
	'Аналитик,Департамент систем бизнес-аналитики', 'Старший бизнес-аналитик', 'Бизнес эксперт'])
	THEN 'Бизнес-аналитик'
	WHEN "должность" like ANY (ARRAY['Старший инженер данных', 'Инженер данных']) THEN 'Инженер данных'
	WHEN "должность" like '%рхитектор%' THEN 'Архитектор'
	WHEN "должность" like ANY (ARRAY['Ведущий разработчик', 'Младший разработчик',
	'Разработчик', 'Младший разработчик BI', 'Разработчик систем бизнес-аналитики', 'Разработчик хранилищ',
	'Разработчик-эксперт', 'Старший разработчик', 'Старший консультант-разработчик']) THEN 'Разработчик'
	WHEN "должность" = 'Инженер данных' THEN 'Инженер данных'
	WHEN "должность" like ANY (ARRAY['Младший инженер по тестированию', 'Младший тестировщик',
	'Старший инженер по тестированию', 'Тестировщик']) THEN 'Тестировщик'
	ELSE 'Другое'
	END AS "employee_role",
	CASE WHEN "должность" like 'Младший%' THEN 'Junior'
	WHEN "должность" like any (ARRAY['Аналитик', 'Аналитик технической поддержки',
	'Системный аналитик', 'Разработчик', 'Разработчик систем бизнес-аналитики',
	'Разработчик хранилищ', 'Бизнес-аналитик', 'Пресейл-аналитик',
	'Аналитик,Департамент систем бизнес-аналитики', 'Архитектор', 'Инженер по тестированию',
	'Тестировщик', 'Архитектор UI/UX', 'Архитектор решений', 'Инженер данных',
	'Системный архитектор'])  THEN 'Middle'
	WHEN "должность" LIKE ANY (ARRAY['старший%', 'Старший%','Эксперт%', '%ксперт'])
	THEN 'Senior'
	WHEN "должность" like ANY (ARRAY['%едущи%', 'Технический лидер'])
	AND "должность" != 'Ведущий менеджер по персоналу' THEN 'Lead'
	WHEN "должность" like '%уководитель%' THEN 'TeamLead'
	ELSE 'Уровень не указан'
	END AS "employee_level"
FROM ods."сотрудники_дар"
where length("должность") != 0;

insert into dds.databases (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.базы_данных;

INSERT INTO dds.databases_emp_skill_level (
	"user_id",
	"id",
	"databases",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("Базы данных", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("Базы данных", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Базы данных", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Базы данных' as "Тип навыка"
FROM ods."базы_данных_и_уровень_знаний_сотру"
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.databases_emp_skill_level
USING (SELECT "user_id",
	        "databases",
	        "date",
	         count(*)
	   FROM dds.databases_emp_skill_level
	   GROUP BY "user_id",
	        "databases",
	        "date"
	   HAVING count(*) > 1) as t
WHERE databases_emp_skill_level."user_id" = t."user_id" AND
        databases_emp_skill_level."databases" = t."databases" AND
        databases_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds."databases_emp_skill_level" (
	"user_id",
	"id",
	"databases",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "databases",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."databases_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now()
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

INSERT INTO dds.foreign_language_emp_skill_level
	("user_id",
	"date",
	"id",
	"foreign_language",
	"foreign_language_level")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
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
	in (select "user_id" from dds.employees);

INSERT INTO dds.certificates
	("user_id",
	"date_of_modification",
	"id",
	"year",
	"name_of_the_certificate")
SELECT distinct
	"User ID",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id",
	case when "Год сертификата" = 0 then NULL
	else "Год сертификата"
	end as "Год сертификата",
	"Наименование сертификата"
from ods."сертификаты_пользователей"
where "User ID" in (select "user_id" from dds.employees);

insert into dds.instruments (
	"name",
	"date",
	"id"
)
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.инструменты;

insert into dds.technologies (
	"name",
	"date",
	"id"
)
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.технологии;

INSERT INTO dds.instruments_emp_skill_level (
	"user_id",
	"id",
	"instruments",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("инструменты", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("инструменты", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("инструменты", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Инструменты' as "Тип навыка"
FROM ods."инструменты_и_уровень_знаний_сотр"
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.instruments_emp_skill_level
USING (SELECT "user_id",
	        "instruments",
	        "date",
	         count(*)
	   FROM dds.instruments_emp_skill_level
	   GROUP BY "user_id",
	        "instruments",
	        "date"
	   HAVING count(*) > 1) as t
WHERE instruments_emp_skill_level."user_id" = t."user_id" AND
        instruments_emp_skill_level."instruments" = t."instruments" AND
        instruments_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.instruments_emp_skill_level (
	"user_id",
	"id",
	"instruments",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "instruments",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."instruments_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '01.01.2000'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;


INSERT INTO dds.industries_emp_skill_level (
	"user_id",
	"id",
	"industries",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	"User ID",
	"id",
	case when regexp_replace("отрасли", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("отрасли", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("отрасли", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("Уровень знаний в отрасли", ' \[.+?\]', '', 'g') = 'Я знаю специфику отрасли'
	then 'Junior'
	when regexp_replace("Уровень знаний в отрасли", ' \[.+?\]', '', 'g')
	like 'Я знаю специфику отрасли и%' then 'Middle'
	when regexp_replace("Уровень знаний в отрасли", ' \[.+?\]', '', 'g')
	like 'Я знаю специфику отрасли,%' then 'Senior'
	else 'Junior'
	end as "Уровень знаний в отрасли",
	'Отрасли' as "Тип навыка"
FROM ods.опыт_сотрудника_в_отраслях
where "User ID"	in (select "user_id" from dds.employees);
INSERT INTO dds.industries_emp_skill_level (
	"user_id",
	"id",
	"industries",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	"User ID",
	"id",
	case when regexp_replace("Предментые области", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("Предментые области", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Предментые области", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when regexp_replace("Уровень знаний в предметной облас", ' \[.+?\]', '', 'g') = 'Я знаю предметную область'
	then 'Junior'
	when regexp_replace("Уровень знаний в предметной облас", ' \[.+?\]', '', 'g')
	like 'Я знаю все особенн %' then 'Middle'
	when regexp_replace("Уровень знаний в предметной облас", ' \[.+?\]', '', 'g')
	like 'Я знаю специфику предметн%' then 'Senior'
	else 'Junior'
	end as "Уровень знаний в отрасли",
	'Отрасли' as "Тип навыка"
FROM ods.опыт_сотрудника_в_предметных_обла
where "User ID"	in (select "user_id" from dds.employees);
DELETE FROM dds.industries_emp_skill_level
USING (SELECT "user_id",
	        "industries",
	        "date",
	         count(*)
	   FROM dds.industries_emp_skill_level
	   GROUP BY "user_id",
	        "industries",
	        "date"
	   HAVING count(*) > 1) as t
WHERE industries_emp_skill_level."user_id" = t."user_id" AND
        industries_emp_skill_level."industries" = t."industries" AND
        industries_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.industries_emp_skill_level (
	"user_id",
	"id",
	"industries",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "industries",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."industries_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now()
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

INSERT INTO dds.education_of_emp
	("user_id",
	"id",
	"education_level",
	"name_of_the_institution",
	"speciality",
	"qualification",
	"year_of_graduation")
SELECT distinct
	"User ID",
	"id",
	case when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Высшее (бакалавриат)', 'Бакалавр']) then 'бакалавриат'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Высшее (специалитет)'])
	then 'специалитет'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Высшее (магистратура)'])
	then 'магистратура'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Аспирантура, ординатура, адъюнктура', 'Кандидат наук'])
	then 'аспирантура'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Среднее%', 'Сертификат', 'Удостоверение',
	'Неполное высшее%', 'Свидетельство', 'Неполное высшее%'])
	then 'среднее'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['Профессиональная%',
	'Повышение квалификации', 'Дополнительное профессиональное образование'])
	then 'проф. переподготовка'
	when regexp_replace("Уровень образование", ' \[.+?\]', '', 'g')
	like any (array['', '-'])
	then 'не указано'
	else 'высшее'
	end as "Уровень образования",
	"Название учебного заведения",
	case when "квалификация" = 'Экономист' then 'Экономист'
	when "квалификация" = 'Информатик-экономист' then 'Информатик-экономист'
	when "квалификация" = 'Бизнес-аналитик' then 'Бизнес-аналитик'
	when "квалификация" = 'Экономист-менеджер' then 'Экономист-менеджер'
	when "квалификация" = 'Техник' then 'Техник'
	when "квалификация" like '%нженер' then 'Инженер'
	when "квалификация" = 'Математик, системный программист'
	then 'Математик, системный программист'
	when "специальность" like any (array['%рист%', '%риспруденция'])
	then 'Юрист'
	when "специальность" like '%ехник'
	then 'Техник'
	when "специальность" like any (array['%кономист', '%кономика'])
	then 'Экономист'
	when "специальность" like any (array['%нженер', 'ИНЖЕНЕР']) then 'Инженер'
	when "специальность" like any (array['%енеджмент', '%енеджер'])
	then 'Менеджмент'
	when "специальность" like any (array['%акалавр', '%агистр', '%специалист',
	'Бакалавриат', 'бакалавар', '%агистр%', 'масгистр', 'Специалист', ''])
	then 'Не указано'
	when "специальность" like '01.05.01. Фундаментальные математика и механика'
	then 'Фундаментальные математика и механика'
	when "специальность" like '03.03.02 Физика'
	then 'Физика'
	when "специальность" like '11.04.02 Инфокоммуникационные технологии и системы связи'
	then 'Инфокоммуникационные технологии и системы связи'
	when "специальность" is null then 'Не указано'
	else "специальность"
	end as "Специальность",
	case when "квалификация" like '%акалав%' then 'Бакалавр'
	when "квалификация" like '%агистр' then 'Магистр'
	when "квалификация" like '%пециалист%' then 'Специалист'
	when "специальность" like '%акалав%' then 'Бакалавр'
	when "специальность" like any (array['%агистр', 'масгистр'])
	then 'Магистр'
	when "специальность" like '%пециалист' then 'Специалист'
	else 'Не указано'
	end as "Квалификация",
	case when "Год окончания" = 0 then NULL
	else "Год окончания"
	end as "Год окончания"
FROM ods."образование_пользователей"
where "User ID" in (select "user_id" from dds.employees);

insert into dds.education_level (
	"name")
SELECT distinct
	"education_level"
FROM dds.education_of_emp;

insert into dds.skill_level (
	"name",
	"date",
	"id"
)
SELECT
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.уровни_знаний
where "название" != 'Novice' and "название" != 'Expert';

insert into dds.foreign_languages_level (
	"name",
	"date",
	"id"
)
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.уровни_владения_ин;

insert into dds.platforms (
	"name",
	"date",
	"id"
)
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.платформы;

insert into dds.ide (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.среды_разработки;

INSERT INTO dds.platforms_emp_skill_level (
	"user_id",
	"id",
	"platforms",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	"User ID",
	"id",
	case when regexp_replace("платформы", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("платформы", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("платформы", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Платформы' as "Тип навыка"
FROM ods.платформы_и_уровень_знаний_сотруд
where "User ID"	in (select "user_id" from dds.employees);
DELETE FROM dds.platforms_emp_skill_level
USING (SELECT "user_id",
	        "platforms",
	        "date",
	         count(*)
	   FROM dds.platforms_emp_skill_level
	   GROUP BY "user_id",
	        "platforms",
	        "date"
	   HAVING count(*) > 1) as t
WHERE platforms_emp_skill_level."user_id" = t."user_id" AND
        platforms_emp_skill_level."platforms" = t."platforms" AND
        platforms_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.platforms_emp_skill_level (
	"user_id",
	"id",
	"platforms",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "platforms",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."platforms_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '2004-09-01'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

insert into dds.progr_language (
	"name",
	"date",
	"id"
)
SELECT
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.языки_программирования ;

INSERT INTO dds.ide_emp_skill_level (
	"user_id",
	"id",
	"ide",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("Среды разработки", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("Среды разработки", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Среды разработки", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Среды разработки' as "Тип навыка"
FROM ods.среды_разработки_и_уровень_знаний_
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.ide_emp_skill_level
USING (SELECT "user_id",
	        "ide",
	        "date",
	         count(*)
	   FROM dds.ide_emp_skill_level
	   GROUP BY "user_id",
	        "ide",
	        "date"
	   HAVING count(*) > 1) as t
WHERE ide_emp_skill_level."user_id" = t."user_id" AND
        ide_emp_skill_level."ide" = t."ide" AND
        ide_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.ide_emp_skill_level (
	"user_id",
	"id",
	"ide",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "ide",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."ide_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '2000-07-02'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

insert into dds.industries (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.отрасли ;
insert into dds.industries (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.предметная_область ;

 insert into dds.frameworks (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.фреймворки ;

insert into dds.foreign_languages (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.языки ;

insert into dds.type_of_system (
	"name",
	"date",
	"id")
SELECT distinct
	"название",
	CAST(replace("Дата изм.", ' %', '') AS date),
	"id"
FROM ods.типы_систем ;

INSERT INTO dds.type_of_system_emp_skill_level (
	"user_id",
	"id",
	"type_of_system",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("Типы систем", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("Типы систем", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Типы систем", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Типы систем' as "Тип навыка"
FROM ods.типы_систем_и_уровень_знаний_сотру
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.type_of_system_emp_skill_level
USING (SELECT "user_id",
	        "type_of_system",
	        "date",
	         count(*)
	   FROM dds.type_of_system_emp_skill_level
	   GROUP BY "user_id",
	        "type_of_system",
	        "date"
	   HAVING count(*) > 1) as t
WHERE type_of_system_emp_skill_level."user_id" = t."user_id" AND
        type_of_system_emp_skill_level."type_of_system" = t."type_of_system" AND
        type_of_system_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.type_of_system_emp_skill_level (
	"user_id",
	"id",
	"type_of_system",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "type_of_system",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."type_of_system_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '2007-09-01'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

INSERT INTO dds.frameworks_emp_skill_level (
	"user_id",
	"id",
	"frameworks",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("фреймворки", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("фреймворки", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("фреймворки", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Фреймворки' as "Тип навыка"
FROM ods.фреймворки_и_уровень_знаний_сотру
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.frameworks_emp_skill_level
USING (SELECT "user_id",
	        "frameworks",
	        "date",
	         count(*)
	   FROM dds.frameworks_emp_skill_level
	   GROUP BY "user_id",
	        "frameworks",
	        "date"
	   HAVING count(*) > 1) as t
WHERE frameworks_emp_skill_level."user_id" = t."user_id" AND
        frameworks_emp_skill_level."frameworks" = t."frameworks" AND
        frameworks_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.frameworks_emp_skill_level (
	"user_id",
	"id",
	"frameworks",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "frameworks",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."frameworks_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '2016-01-11'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

INSERT INTO dds.progr_language_emp_skill_level (
	"user_id",
	"id",
	"programming_languages",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("Языки программирования", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("Языки программирования", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("Языки программирования", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Языки программирования' as "Тип навыка"
FROM ods.языки_программирования_и_уровень
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.progr_language_emp_skill_level
USING (SELECT "user_id",
	        "programming_languages",
	        "date",
	         count(*)
	   FROM dds.progr_language_emp_skill_level
	   GROUP BY "user_id",
	        "programming_languages",
	        "date"
	   HAVING count(*) > 1) as t
WHERE progr_language_emp_skill_level."user_id" = t."user_id" AND
        progr_language_emp_skill_level."programming_languages" = t."programming_languages" AND
        progr_language_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.progr_language_emp_skill_level (
	"user_id",
	"id",
	"programming_languages",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "programming_languages",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."progr_language_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '1997-07-02'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;

INSERT INTO dds.technologies_emp_skill_level (
	"user_id",
	"id",
	"technologies",
	"date",
	"skill_level",
	"type_of_skill")
SELECT distinct
	CAST(substring("название", 6, length("название")-5) as int4) as "название",
	"id",
	case when regexp_replace("технологии", ' \[.+?\]', '', 'g') like '%  %'
	then replace(regexp_replace("технологии", ' \[.+?\]', '', 'g'), '  ', ' ')
	else regexp_replace("технологии", ' \[.+?\]', '', 'g')
	end as "Базы данных",
	CASE WHEN length("дата") = 0 THEN CAST(replace("Дата изм.", ' %', '') AS date)
	ELSE CAST("дата" as date)
	END as "дата",
	case when length("Уровень знаний") = 0
	or regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Novice' then 'Junior'
	when regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g') = 'Expert' then 'Senior'
	else regexp_replace("Уровень знаний", ' \[.+?\]', '', 'g')
	end as "Уровень знаний",
	'Технологии' as "Тип навыка"
FROM ods.технологии_и_уровень_знаний_сотру
where CAST(substring("название", 6, length("название")-5) as int4)
	in (select "user_id" from dds.employees);
DELETE FROM dds.technologies_emp_skill_level
USING (SELECT "user_id",
	        "technologies",
	        "date",
	         count(*)
	   FROM dds.technologies_emp_skill_level
	   GROUP BY "user_id",
	        "technologies",
	        "date"
	   HAVING count(*) > 1) as t
WHERE technologies_emp_skill_level."user_id" = t."user_id" AND
        technologies_emp_skill_level."technologies" = t."technologies" AND
        technologies_emp_skill_level."date" = t."date" AND
        "skill_level" = 'Junior';
insert into dds.technologies_emp_skill_level (
	"user_id",
	"id",
	"technologies",
	"date",
	"skill_level",
	"type_of_skill")
select
    distinct
    "user_id",
    "id",
    "technologies",
    date_actual,
    "skill_level",
    "type_of_skill"
from dds."technologies_emp_skill_level" as bd
full join datamart.dim_date as d
    on d.year_actual >= extract(year from bd."date")
where
    d.date_actual <= now() and d.date_actual >= '2004-01-01'
    and to_char(d.date_actual, 'MM-DD') = '01-01'
order by
    date_actual;