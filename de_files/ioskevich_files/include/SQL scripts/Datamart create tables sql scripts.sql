CREATE TABLE datamart.сотрудники_дар (
	"User ID" int4 NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Должность" text NULL,
	"Роль сотрудника" text NULL,
	"Уровень знаний сотрудника" text NULL
);

CREATE TABLE datamart.языки_пользователей (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Язык" text NULL,
	"Уровень знаний ин. языка" text NULL
);

CREATE TABLE datamart.сертификаты_пользователей (
	"User ID" int4 NULL,
	"Год сертификата" int4 NULL,
	"Наименование сертификата" text NULL
);

CREATE TABLE datamart.базы_данных_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Базы данных" varchar(50) NULL,
	"Дата" date NULL,
	"Уровень знаний" varchar(50) null,
	"Тип навыка" varchar(50) null
);

CREATE TABLE datamart.инструменты_и_уровень_знаний_сотр (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Инструменты" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	"Тип навыка" varchar(50) null
);

CREATE TABLE datamart.опыт_сотрудника_в_отраслях (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Отрасли" varchar(50) NULL,
	"Уровень знаний в отрасли" varchar(128) NULL
);

CREATE TABLE datamart.образование_пользователей (
	"User ID" int4 NULL,
	"Уровень образования" text NULL,
	"Название учебного заведения" text NULL,
	"Фиктивное название" text NULL,
	"Факультет, кафедра" text NULL,
	"Специальность" text NULL,
	"Квалификация" text NULL,
	"Год окончания" int4 NULL
);

CREATE TABLE datamart.платформы_и_уровень_знаний_сотруд (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Платформы" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	"Тип навыка" varchar(50) null	
);

CREATE TABLE datamart.опыт_сотрудника_в_предметных_обла (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Предметные области" varchar(50) NULL,
	"Уровень знаний в предметной облас" varchar(128) NULL
);

CREATE TABLE datamart.среды_разработки_и_уровень_знаний_ (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Среды разработки" varchar(50) NULL,
	"Уровень знаний" varchar(50) NULL,
	"Тип навыка" varchar(50) NULL
);

CREATE TABLE datamart.типы_систем_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Типы систем" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	"Тип навыка" varchar(50) NULL
);

CREATE TABLE datamart.фреймворки_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Фреймворки" text NULL,
	"Уровень знаний" text NULL,
	"Тип навыка" text NULL
);

CREATE TABLE datamart.языки_программирования_и_уровень (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Языки программирования" text NULL,
	"Уровень знаний" text NULL,
	"Тип навыка" text NULL
);

CREATE TABLE datamart.технологии_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Дата" date NULL,
	"Технологии" text NULL,
	"Уровень знаний" text NULL,
	"Тип навыка" text NULL
);