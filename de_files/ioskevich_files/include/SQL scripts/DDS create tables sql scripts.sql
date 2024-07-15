CREATE TABLE dds.сотрудники_дар (
	"User ID" int4 NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Последняя авторизация" date NULL,
	"Должность" text NULL,
	"ЦФО" text NULL,
	"Подразделения" text NULL
);
CREATE TABLE dds.уровень_образования (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.языки (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.уровни_владения_ин (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.языки_пользователей (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Язык" text NULL,
	"Уровень знаний ин. языка" text NULL,
	CONSTRAINT FK_lang_lev FOREIGN KEY("Уровень знаний ин. языка")
        REFERENCES dds.уровни_владения_ин("Название"),
	CONSTRAINT FK_lang FOREIGN KEY("Язык")
        REFERENCES dds.языки("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.сертификаты_пользователей (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Год сертификата" int4 NULL,
	"Наименование сертификата" text NULL,
	"Организация, выдавшая сертификат" text NULL
);
CREATE TABLE dds.уровни_знаний (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.базы_данных (
	"Название" varchar(50) NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.базы_данных_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Базы данных" varchar(50) NULL,
	"Дата" date NULL,
	"Уровень знаний" varchar(50) NULL,
	CONSTRAINT FK_bd_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_bd FOREIGN KEY("Базы данных")
        REFERENCES dds.базы_данных("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.инструменты (
	"Название" varchar(50) PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.инструменты_и_уровень_знаний_сотр (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Инструменты" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	CONSTRAINT FK_inst_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_inst FOREIGN KEY("Инструменты")
        REFERENCES dds.инструменты("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.отрасли (
	"Название" varchar(50) NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.уровни_знаний_в_отрасли (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.опыт_сотрудника_в_отраслях (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Отрасли" varchar(50) NULL,
	"Уровень знаний в отрасли" varchar(128) NULL,
	CONSTRAINT FK_otr_lev FOREIGN KEY("Уровень знаний в отрасли")
        REFERENCES dds.уровни_знаний_в_отрасли("Название"),
	CONSTRAINT FK_otr FOREIGN KEY("Отрасли")
        REFERENCES dds.отрасли("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.образование_пользователей (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Уровень образования" text NULL,
	"Название учебного заведения" text NULL,
	"Фиктивное название" text NULL,
	"Факультет, кафедра" text NULL,
	"Специальность" text NULL,
	"Квалификация" text NULL,
	"Год окончания" int4 NULL,
	CONSTRAINT FK_otr_lev FOREIGN KEY("Уровень образования")
        REFERENCES dds.уровень_образования("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.платформы (
	"Название" varchar(50) NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.платформы_и_уровень_знаний_сотруд (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Платформы" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	CONSTRAINT FK_inst_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_inst FOREIGN KEY("Платформы")
        REFERENCES dds.платформы("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.предметная_область (
	"Название" varchar(50) NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.уровни_знаний_в_предметной_област (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.опыт_сотрудника_в_предметных_обла (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Предметные области" varchar(50) NULL,
	"Уровень знаний в предметной облас" varchar(128) NULL,
	CONSTRAINT FK_otr_obl FOREIGN KEY("Уровень знаний в предметной облас")
        REFERENCES dds.уровни_знаний_в_предметной_област("Название"),
	CONSTRAINT FK_obl FOREIGN KEY("Предметные области")
        REFERENCES dds.предметная_область("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.среды_разработки (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.среды_разработки_и_уровень_знаний_ (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Среды разработки" varchar(50) NULL,
	"Уровень знаний" varchar(50) NULL,
	CONSTRAINT FK_sr_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_sr FOREIGN KEY("Среды разработки")
        REFERENCES dds.среды_разработки("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.типы_систем (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.типы_систем_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Типы систем" varchar(64) NULL,
	"Уровень знаний" varchar(50) NULL,
	CONSTRAINT FK_ts_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_ts FOREIGN KEY("Типы систем")
        REFERENCES dds.типы_систем("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.фреймворки (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.фреймворки_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Уровень знаний" text NULL,
	"Фреймворки" text NULL,
	CONSTRAINT FK_ts_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_ts FOREIGN KEY("Фреймворки")
        REFERENCES dds.фреймворки("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.языки_программирования (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.языки_программирования_и_уровень (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Уровень знаний" text NULL,
	"Языки программирования" text NULL,
	CONSTRAINT FK_lenpr_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_lenpr FOREIGN KEY("Языки программирования")
        REFERENCES dds.языки_программирования("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);
CREATE TABLE dds.технологии (
	"Название" text NULL PRIMARY KEY,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL
);
CREATE TABLE dds.технологии_и_уровень_знаний_сотру (
	"User ID" int4 NULL,
	"Активность" boolean NULL,
	"Дата изм." date NULL,
	"ID" int4 NULL PRIMARY KEY,
	"Дата" date NULL,
	"Технологии" text NULL,
	"Уровень знаний" text NULL,
	CONSTRAINT FK_teh_lev FOREIGN KEY("Уровень знаний")
        REFERENCES dds.уровни_знаний("Название"),
	CONSTRAINT FK_teh FOREIGN KEY("Технологии")
        REFERENCES dds.технологии("Название"),
	CONSTRAINT FK_user FOREIGN KEY("User ID")
        REFERENCES dds.сотрудники_дар("User ID")
);