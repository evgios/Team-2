
INSERT INTO datamart.dim_employee (
	"emp_id",
	"emp_active",
	"emp_job_title",
	"emp_role",
	"emp_level"
	)
SELECT
	"user_id",
	"active",
	"job_title",
	"emp_role",
	"emp_level"
from dds.employees;

insert into datamart.dim_skill_level (
	"sk_l_id",
	"skill_level")
select "id",
	"name"
from dds.skill_level;
insert into datamart.dim_skill_level (
	"sk_l_id",
	"skill_level")
select "id",
	"name"
from dds.foreign_languages_level ;

insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	1
from dds.databases ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	2
from dds.instruments ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	3
from dds.platforms ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	4
from dds.technologies ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	5
from dds.frameworks ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	6
from dds.progr_language ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	7
from dds.type_of_system ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	8
from dds.ide ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	9
from dds.industries ;
insert into datamart.dim_skills (
	"sk_id",
	"skill",
	"sk_type")
select "id",
	"name",
	10
from dds.foreign_languages ;

insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.databases_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "databases" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on databases_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.instruments_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "instruments" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on instruments_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.technologies_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "technologies" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on technologies_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.platforms_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "platforms" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on platforms_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.frameworks_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "frameworks" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on frameworks_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.progr_language_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "programming_languages" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on progr_language_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.type_of_system_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "type_of_system" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on type_of_system_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.ide_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "ide" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on ide_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id"
from dds.industries_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skill_types
on "skill_type" = "type_of_skill"
inner join datamart.dim_skills
on "industries" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on industries_emp_skill_level."skill_level" = dim_skill_level."skill_level"
where "sk_type" = "sk_t_dim_key";
insert into datamart.fact_skills (
	"sk_f_id",
	"emp_key",
	"sk_dim_key",
	"sk_l_dim_key",
	"sk_t_dim_key",
	"is_skill",
	"is_industry",
	"date_dim_id")
select
	"id",
	"emp_dim_key",
	"sk_dim_key",
	"sk_l_dim_key",
	10,
	'1':: boolean,
	'0':: boolean,
	"date_dim_id"
from dds.foreign_language_emp_skill_level
inner join datamart.dim_employee
on "user_id" = "emp_id"
inner join datamart.dim_skills
on "foreign_language" = "skill"
inner join datamart.dim_date
on "date"= "date_actual"
inner join datamart.dim_skill_level
on foreign_language_emp_skill_level."foreign_language_level" = dim_skill_level."skill_level"
where "sk_type" = 10 ;