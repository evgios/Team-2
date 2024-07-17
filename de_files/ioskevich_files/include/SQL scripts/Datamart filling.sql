INSERT INTO datamart."сотрудники_дар" (
	"User ID",
	"Активность",
	"Должность",
	"Роль сотрудника",
	"Уровень сотрудника"
	)
SELECT "User ID",
	"Активность",
	CASE WHEN "Должность" = 'Аналитик,Департамент систем бизнес-аналитики' THEN 'Бизнес-аналитик'
	when "Должность" = 'старший системный аналитик' then 'Старший системный аналитик'
	ELSE "Должность"
	END as "Должность",
	CASE WHEN "Должность" like '%уководитель%' THEN 'Руководитель проектов'
	WHEN "Должность" like ANY (ARRAY['Аналитик', 'Старший аналитик', 'Аналитик технической поддержки', 
	'Ведущий аналитик', 'Ведущий системный аналитик', 'Младший аналитик', 'Младший системный аналитик',
	'Системный аналитик', 'старший системный аналитик', 'Эксперт-аналитик', 'Эксперт по анализу данных']) 
	THEN 'Системный аналитик'
	WHEN "Должность" like ANY (ARRAY['%изнес-аналитик', 'Пресейл-аналитик', 
	'Аналитик,Департамент систем бизнес-аналитики', 'Старший бизнес-аналитик', 'Бизнес эксперт']) 
	THEN 'Бизнес-аналитик'
	WHEN "Должность" like ANY (ARRAY['Старший инженер данных', 'Инженер данных']) THEN 'Инженер данных'
	WHEN "Должность" like '%рхитектор%' THEN 'Архитектор'
	WHEN "Должность" like ANY (ARRAY['Ведущий разработчик', 'Младший разработчик', 
	'Разработчик', 'Младший разработчик BI', 'Разработчик систем бизнес-аналитики', 'Разработчик хранилищ',
	'Разработчик-эксперт', 'Старший разработчик', 'Старший консультант-разработчик']) THEN 'Разработчик'
	WHEN "Должность" = 'Инженер данных' THEN 'Инженер данных'
	WHEN "Должность" like ANY (ARRAY['Младший инженер по тестированию', 'Младший тестировщик',
	'Старший инженер по тестированию', 'Тестировщик']) THEN 'Тестировщик'
	ELSE 'Другое'
	END AS "Роль сотрудника",
	CASE WHEN "Должность" like 'Младший%' THEN 'Junior'
	WHEN "Должность" like (ARRAY['Аналитик', 'Аналитик технической поддержки',
	'Системный аналитик', 'Разработчик', 'Разработчик систем бизнес-аналитики',
	'Разработчик хранилищ', 'Бизнес-аналитик', 'Пресейл-аналитик',
	'Аналитик,Департамент систем бизнес-аналитики', 'Архитектор', 'Инженер по тестированию',
	'Тестировщик', 'Архитектор UI/UX', 'Архитектор решений', 'Инженер данных',
	'Системный архитектор'])  THEN 'Middle'
	WHEN "Должность" LIKE ANY (ARRAY['старший%', 'Старший%','Эксперт%', '%ксперт'])
	THEN 'Senior'
	WHEN "Должность" like ANY (ARRAY['%едущи%', 'Технический лидер']) 
	AND "Должность" != 'Ведущий менеджер по персоналу' THEN 'Lead'
	WHEN "Должность" like '%уководитель%' THEN 'TeamLead'
	ELSE 'Роль не определена'
	END AS "Уровень сотрудника"
FROM dds."сотрудники_дар"
WHERE "Должность" != '-';

INSERT INTO datamart."языки_пользователей" (
	"User ID",
	"Дата",
	"Язык",
	"Уровень знаний ин. языка"
)
SELECT "User ID",
	"Дата изм.",
	"Язык",
	"Уровень знаний ин. языка"
FROM dds."языки_пользователей";

INSERT INTO datamart."сертификаты_пользователей" (
	"User ID",
	"Год сертификата",
	"Наименование сертификата"
)
SELECT "User ID",
	"Год сертификата",
	"Наименование сертификата"
FROM dds."сертификаты_пользователей";

INSERT INTO datamart."базы_данных_и_уровень_знаний_сотру" (
	"User ID", 
	"Базы данных", 
	"Дата", 
	"Уровень знаний", 
	"Тип навыка"
) 
SELECT distinct
	"User ID", 
	"Базы данных",
	"Дата",
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Базы данных' as "Тип навыка"
FROM dds."базы_данных_и_уровень_знаний_сотру";

DELETE FROM datamart."базы_данных_и_уровень_знаний_сотру"
USING (SELECT "User ID",
	        "Базы данных",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM dds."базы_данных_и_уровень_знаний_сотру"
	   GROUP BY "User ID",
	        "Базы данных",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "базы_данных_и_уровень_знаний_сотру"."User ID" = t."User ID" AND
        "базы_данных_и_уровень_знаний_сотру"."Базы данных" = t."Базы данных" AND
        "базы_данных_и_уровень_знаний_сотру"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.базы_данных_и_уровень_знаний_сотру(
	"User ID",
    "Базы данных",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Базы данных",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."базы_данных_и_уровень_знаний_сотру" as bd
full join public.d_date as d
    on d.year_actual >= extract(year from bd."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."инструменты_и_уровень_знаний_сотр"
	("User ID",
	"Дата",
	"Инструменты",
	"Уровень знаний",
	"Тип навыка"
)
SELECT distinct "User ID",
	"Дата",
	"Инструменты",
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний"
	end as "Уровень знаний",
	'Инструменты' as "Тип навыка"
FROM dds."инструменты_и_уровень_знаний_сотр";

DELETE FROM datamart."инструменты_и_уровень_знаний_сотр"
USING (SELECT "User ID",
	        "Инструменты",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."инструменты_и_уровень_знаний_сотр"
	   GROUP BY "User ID",
	        "Инструменты",
	        "Дата"
	   HAVING count(*) > 1) as t3
WHERE "инструменты_и_уровень_знаний_сотр"."User ID" = t3."User ID" AND
        "инструменты_и_уровень_знаний_сотр"."Инструменты" = t3."Инструменты" AND
        "инструменты_и_уровень_знаний_сотр"."Дата" = t3."Дата" AND
        "инструменты_и_уровень_знаний_сотр"."Уровень знаний" = 'Junior';

insert into datamart.инструменты_и_уровень_знаний_сотр (
	"User ID",
    "Инструменты",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Инструменты",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."инструменты_и_уровень_знаний_сотр" as inst
full join public.d_date as d
    on d.year_actual >= extract(year from inst."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."опыт_сотрудника_в_отраслях" 
	("User ID", 
	"Отрасли", 
	"Дата", 
	"Уровень знаний в отрасли") 
SELECT distinct "User ID",
	"Отрасли",
	"Дата",
	case when "Уровень знаний в отрасли" = 'Я знаю специфику отрасли' then 'Junior'
	when "Уровень знаний в отрасли" like 'Я знаю специфику отрасли и%' then 'Middle'
	when "Уровень знаний в отрасли" like 'Я знаю специфику отрасли,%' then 'Senior'
	else 'Junior'
	end as "Уровень знаний в отрасли"
FROM dds."опыт_сотрудника_в_отраслях";

INSERT INTO datamart."опыт_сотрудника_в_отраслях"
	("User ID",
	"Отрасли",
	"Дата",
	"Уровень знаний в отрасли")
SELECT distinct "User ID",
	"Предметные области",
	"Дата",
	case when "Уровень знаний в предметной облас" = 'Я знаю предметную область' then 'Junior'
	when "Уровень знаний в предметной облас" like 'Я знаю все особенн %' then 'Middle'
	when "Уровень знаний в предметной облас" like 'Я знаю специфику предметн%' then 'Senior'
	else 'Junior'
	end as "Уровень знаний в предметной облас"
FROM dds."опыт_сотрудника_в_предметных_обла";

DELETE FROM datamart."опыт_сотрудника_в_отраслях"
USING (SELECT "User ID",
	        "Отрасли",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."опыт_сотрудника_в_отраслях"
	   GROUP BY "User ID",
	        "Отрасли",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "опыт_сотрудника_в_отраслях"."User ID" = t."User ID" AND
        "опыт_сотрудника_в_отраслях"."Отрасли" = t."Отрасли" AND
        "опыт_сотрудника_в_отраслях"."Дата" = t."Дата" AND
        "Уровень знаний в отрасли" = 'Junior';

insert into datamart.опыт_сотрудника_в_отраслях (
	"User ID",
    "Отрасли",
	"Дата",
    "Уровень знаний в отрасли"
    )
select
    distinct
    "User ID",
    "Отрасли",
	date_actual as "Дата",
    "Уровень знаний в отрасли"
from datamart."опыт_сотрудника_в_отраслях" as exp
full join public.d_date as d
    on d.year_actual >= extract(year from exp."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."образование_пользователей" 
	("User ID", 
	"Уровень образования",	
	"Название учебного заведения", 
	"Фиктивное название", 
	"Факультет, кафедра", 
	"Специальность", 
	"Квалификация", 
	"Год окончания") 
SELECT 	"User ID", 
	case when "Уровень образования" like any (array['Высшее (бакалавриат)',
	'Бакалавр']) then 'бакалавриат'
	when "Уровень образования" like any (array['Высшее (специалитет)'])
	then 'специалитет'
	when "Уровень образования" like any (array['Высшее (магистратура)'])
	then 'магистратура'
	when "Уровень образования" like any (array['Аспирантура, ординатура, адъюнктура',
	'Кандидат наук'])
	then 'аспирантура'
	when "Уровень образования" like any (array['Среднее%', 'Сертификат', 'Удостоверение', 'Неполное высшее%',
	'Свидетельство', 'Неполное высшее%']) then 'среднее'
	when "Уровень образования" like any (array['Профессиональная%',
	'Повышение квалификации', 'Дополнительное профессиональное образование'])
	then 'проф. переподготовка'
	when "Уровень образования" like any (array['Не указано', '-'])
	then 'не указано'
	else 'высшее'
	end as "Уровень образования",
	"Название учебного заведения",
	"Фиктивное название", 
	"Факультет, кафедра",
	case when "Квалификация" = 'Экономист' then 'Экономист'
	when "Квалификация" = 'Информатик-экономист' then 'Информатик-экономист'
	when "Квалификация" = 'Бизнес-аналитик' then 'Бизнес-аналитик'
	when "Квалификация" = 'Экономист-менеджер' then 'Экономист-менеджер'
	when "Квалификация" = 'Техник' then 'Техник'
	when "Квалификация" like '%нженер' then 'Инженер'
	when "Квалификация" = 'Математик, системный программист'
	then 'Математик, системный программист'
	when "Специальность" like any (array['%рист%', '%риспруденция'])
	then 'Юрист'
	when "Специальность" like '%ехник'
	then 'Техник'
	when "Специальность" like any (array['%кономист', '%кономика'])
	then 'Экономист'
	when "Специальность" like any (array['%нженер', 'ИНЖЕНЕР']) then 'Инженер'
	when "Специальность" like any (array['%енеджмент', '%енеджер'])
	then 'Менеджмент'
	when "Специальность" like any (array['%акалавр', '%агистр', '%специалист',
	'Бакалавриат', 'бакалавар', '%агистр%', 'масгистр', 'Специалист'])
	then 'Не указано'
	when "Специальность" is null then 'Не указано'
	else "Специальность"
	end as "Специальность",
	case when "Квалификация" like '%акалав%' then 'Бакалавр'
	when "Квалификация" like '%агистр' then 'Магистр'
	when "Квалификация" like '%пециалист%' then 'Специалист'
	when "Специальность" like '%акалав%' then 'Бакалавр'
	when "Специальность" like any (array['%агистр', 'масгистр'])
	then 'Магистр'
	when "Специальность" like '%пециалист' then 'Специалист'
	else 'Не указано'
	end as "Квалификация",
	"Год окончания" 
FROM dds."образование_пользователей";

INSERT INTO datamart."платформы_и_уровень_знаний_сотруд" 
	("User ID", 
	"Платформы", 
	"Дата", 
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct	"User ID",
	"Платформы",
	"Дата",
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Платформы' as "Тип навыка"
FROM dds."платформы_и_уровень_знаний_сотруд";

DELETE FROM datamart."платформы_и_уровень_знаний_сотруд"
USING (SELECT "User ID",
	        "Платформы",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."платформы_и_уровень_знаний_сотруд"
	   GROUP BY "User ID",
	        "Платформы",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "платформы_и_уровень_знаний_сотруд"."User ID" = t."User ID" AND
        "платформы_и_уровень_знаний_сотруд"."Платформы" = t."Платформы" AND
        "платформы_и_уровень_знаний_сотруд"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.платформы_и_уровень_знаний_сотруд (
	"User ID",
    "Платформы",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Платформы",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."платформы_и_уровень_знаний_сотруд" as pl
full join public.d_date as d
    on d.year_actual >= extract(year from pl."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."среды_разработки_и_уровень_знаний_"
	("User ID", 
	"Дата", 
	"Среды разработки", 
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct "User ID",
	"Дата", 
	"Среды разработки",
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Среды разработки' as "Тип навыка"
FROM dds."среды_разработки_и_уровень_знаний_";

DELETE FROM datamart."среды_разработки_и_уровень_знаний_"
USING (SELECT "User ID",
	        "Среды разработки",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."среды_разработки_и_уровень_знаний_"
	   GROUP BY "User ID",
	        "Среды разработки",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "среды_разработки_и_уровень_знаний_"."User ID" = t."User ID" AND
        "среды_разработки_и_уровень_знаний_"."Среды разработки" = t."Среды разработки" AND
        "среды_разработки_и_уровень_знаний_"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.среды_разработки_и_уровень_знаний_ (
	"User ID",
    "Среды разработки",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Среды разработки",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."среды_разработки_и_уровень_знаний_" as sr
full join public.d_date as d
    on d.year_actual >= extract(year from sr."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."типы_систем_и_уровень_знаний_сотру" 
	("User ID", 
	"Дата", 
	"Типы систем", 
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct "User ID",
	"Дата", 
	"Типы систем", 
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Типы систем' as "Тип навыка"
FROM dds."типы_систем_и_уровень_знаний_сотру";

DELETE FROM datamart."типы_систем_и_уровень_знаний_сотру"
USING (SELECT "User ID",
	        "Типы систем",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."типы_систем_и_уровень_знаний_сотру"
	   GROUP BY "User ID",
	        "Типы систем",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "типы_систем_и_уровень_знаний_сотру"."User ID" = t."User ID" AND
        "типы_систем_и_уровень_знаний_сотру"."Типы систем" = t."Типы систем" AND
        "типы_систем_и_уровень_знаний_сотру"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.типы_систем_и_уровень_знаний_сотру (
	"User ID",
    "Типы систем",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Типы систем",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."типы_систем_и_уровень_знаний_сотру" as ts
full join public.d_date as d
    on d.year_actual >= extract(year from ts."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."фреймворки_и_уровень_знаний_сотру" 
	("User ID", 
	"Дата", 
	"Фреймворки", 
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct "User ID",
	"Дата", 
	"Фреймворки", 
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Фреймворки' as "Тип навыка"
FROM dds."фреймворки_и_уровень_знаний_сотру";

DELETE FROM datamart."фреймворки_и_уровень_знаний_сотру"
USING (SELECT "User ID",
	        "Фреймворки",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."фреймворки_и_уровень_знаний_сотру"
	   GROUP BY "User ID",
	        "Фреймворки",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "фреймворки_и_уровень_знаний_сотру"."User ID" = t."User ID" AND
        "фреймворки_и_уровень_знаний_сотру"."Фреймворки" = t."Фреймворки" AND
        "фреймворки_и_уровень_знаний_сотру"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.фреймворки_и_уровень_знаний_сотру (
	"User ID",
    "Фреймворки",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Фреймворки",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."фреймворки_и_уровень_знаний_сотру" as fr
full join public.d_date as d
    on d.year_actual >= extract(year from fr."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."языки_программирования_и_уровень" 
	("User ID", 
	"Дата", 
	"Языки программирования", 
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct "User ID",
	"Дата", 
	"Языки программирования", 
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Языки программирования' as "Тип навыка"
FROM dds."языки_программирования_и_уровень";

DELETE FROM datamart."языки_программирования_и_уровень"
USING (SELECT "User ID",
	        "Языки программирования",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."языки_программирования_и_уровень"
	   GROUP BY "User ID",
	        "Языки программирования",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "языки_программирования_и_уровень"."User ID" = t."User ID" AND
        "языки_программирования_и_уровень"."Языки программирования" = t."Языки программирования" AND
        "языки_программирования_и_уровень"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.языки_программирования_и_уровень (
	"User ID",
    "Языки программирования",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Языки программирования",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."языки_программирования_и_уровень" as lan
full join public.d_date as d
    on d.year_actual >= extract(year from lan."Дата")
where
    d.date_actual <= now()
order by
    date_actual;

INSERT INTO datamart."технологии_и_уровень_знаний_сотру" 
	("User ID", 
	"Дата", 
	"Технологии",
	"Уровень знаний",
	"Тип навыка") 
SELECT distinct "User ID",
	"Дата", 
	"Технологии", 
	case when "Уровень знаний" = 'Novice' OR "Уровень знаний" = 'Данные отсутствуют'
	then 'Junior'
	when "Уровень знаний" = 'Expert' then 'Senior'
	else "Уровень знаний" 
	end as "Уровень знаний",
	'Технологии' as "Тип навыка"
FROM dds."технологии_и_уровень_знаний_сотру";

DELETE FROM datamart."технологии_и_уровень_знаний_сотру"
USING (SELECT "User ID",
	        "Технологии",
	        "Дата",
	         count(*) as "Счетчик дублей"
	   FROM datamart."технологии_и_уровень_знаний_сотру"
	   GROUP BY "User ID",
	        "Технологии",
	        "Дата"
	   HAVING count(*) > 1) as t
WHERE "технологии_и_уровень_знаний_сотру"."User ID" = t."User ID" AND
        "технологии_и_уровень_знаний_сотру"."Технологии" = t."Технологии" AND
        "технологии_и_уровень_знаний_сотру"."Дата" = t."Дата" AND
        "Уровень знаний" = 'Junior';

insert into datamart.технологии_и_уровень_знаний_сотру (
	"User ID",
    "Технологии",
	"Дата",
    "Уровень знаний",
    "Тип навыка"
    )
select
    distinct
    "User ID",
    "Технологии",
	date_actual as "Дата",
    "Уровень знаний",
    "Тип навыка"
from datamart."технологии_и_уровень_знаний_сотру" as t
full join public.d_date as d
    on d.year_actual >= extract(year from t."Дата")
where
    d.date_actual <= now()
order by
    date_actual;