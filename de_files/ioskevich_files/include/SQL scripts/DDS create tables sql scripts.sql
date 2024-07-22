
CREATE TABLE dds.employees (
	"user_id" int4 NULL PRIMARY KEY,
	"active" boolean NULL,
	"job_title" text NULL,
	"emp_role" text NULL,
	"emp_level" text NULL
);

CREATE TABLE dds.foreign_language_emp_skill_level (
	"user_id" int4 NULL,
	"date" date NULL,
	"id" int4 null,
	"foreign_language" text NULL,
	"foreign_language_level" text NULL
);

CREATE TABLE dds.certificates (
	"user_id" int4 NULL,
	"date_of_modification" date NULL,
	"id" int4 NULL,
	"year" int4 NULL,
	"name_of_the_certificate" text NULL
);

CREATE TABLE dds.databases (
	"name" text,
	"date" date,
	"id" int4 NULL
);

CREATE TABLE dds.databases_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 NULL,
	"databases" varchar(50) NULL,
	"date" date NULL,
	"skill_level" varchar(50) NULL,
	"type_of_skill" varchar(50) NULL
);

CREATE TABLE dds.instruments (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.foreign_languages (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.progr_language (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.skill_level (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.foreign_languages_level (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.education_level (
	"name" text NULL,
	"id" SERIAL PRIMARY KEY
);

CREATE TABLE dds.education_of_emp (
	user_id int4 NULL,
	education_level text NULL,
	name_of_the_institution text NULL,
	speciality text NULL,
	qualification text NULL,
	year_of_graduation int4 NULL
);

CREATE TABLE dds.industries (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.platforms (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.frameworks (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.type_of_system (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.technologies (
	"name" text NULL,
	"date" date NULL,
	id int4 NULL
);

CREATE TABLE dds.ide (
	"name" text NULL,
	"date" date NULL,
	"id" int4 NULL
);

CREATE TABLE dds.instruments_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"instruments" varchar(50) NULL,
	"date" date NULL,
	"skill_level" varchar(50) NULL,
	"type_of_skill" varchar(50) NULL
);

CREATE TABLE dds.industries_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 NULL,
	"industries" text NULL,
	"date" date NULL,
	"skill_level" text NULL,
	"type_of_skill" text null
);

CREATE TABLE dds.education_of_emp (
	"user_id" int4 NULL,
	"education_level" text NULL,
	"name_of_the_institution" text NULL,
	"speciality" text NULL,
	"qualification" text NULL,
	"year_of_graduation" int4 NULL
);

CREATE TABLE dds.platforms_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"platforms" text NULL,
	"date" date NULL,
	"skill_level" text NULL,
	"type_of_skill" text null
);

CREATE TABLE dds.ide_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"ide" text NULL,
	"date" date NULL,
	"skill_level" text NULL,
	"type_of_skill" text null
);


CREATE TABLE dds.frameworks_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"frameworks" varchar(50) NULL,
	"date" date NULL,
	"skill_level" varchar(50) NULL,
	"type_of_skill" varchar(50) NULL
);

CREATE TABLE dds.progr_language_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 NULL,
	"programming_languages" text NULL,
	"date" date NULL,
	"skill_level" text NULL,
	"type_of_skill" text null
);

CREATE TABLE dds.technologies_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"technologies" text NULL,
	"date" date NULL,
	"skill_level" text null,
	"type_of_skill" text null
);