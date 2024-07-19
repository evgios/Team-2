CREATE TABLE datamart.dim_date
(
  date_dim_id              INT NOT NULL,
  date_actual              DATE NOT NULL,
  epoch                    BIGINT NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             BOOLEAN NOT NULL
);

ALTER TABLE datamart.dim_date ADD CONSTRAINT d_date_date_dim_id_pk PRIMARY KEY (date_dim_id);

CREATE INDEX d_date_date_actual_idx
  ON datamart.dim_date(date_actual);
INSERT INTO datamart.dim_date
SELECT TO_CHAR(datum,'yyyymmdd')::INT AS date_dim_id,
       datum AS date_actual,
       EXTRACT(epoch FROM datum) AS epoch,
       TO_CHAR(datum,'Dth') AS day_suffix,
       TO_CHAR(datum,'Day') AS day_name,
       EXTRACT(isodow FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter',datum)::DATE +1 AS day_of_quarter,
       EXTRACT(doy FROM datum) AS day_of_year,
       TO_CHAR(datum,'W')::INT AS week_of_month,
       EXTRACT(week FROM datum) AS week_of_year,
       TO_CHAR(datum,'YYYY"-W"IW-D') AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum,'Month') AS month_name,
       TO_CHAR(datum,'Mon') AS month_name_abbreviated,
       EXTRACT(quarter FROM datum) AS quarter_actual,
       CASE
         WHEN EXTRACT(quarter FROM datum) = 1 THEN 'First'
         WHEN EXTRACT(quarter FROM datum) = 2 THEN 'Second'
         WHEN EXTRACT(quarter FROM datum) = 3 THEN 'Third'
         WHEN EXTRACT(quarter FROM datum) = 4 THEN 'Fourth'
       END AS quarter_name,
       EXTRACT(isoyear FROM datum) AS year_actual,
       datum +(1 -EXTRACT(isodow FROM datum))::INT AS first_day_of_week,
       datum +(7 -EXTRACT(isodow FROM datum))::INT AS last_day_of_week,
       datum +(1 -EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH',datum) +INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter',datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter',datum) +INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(isoyear FROM datum) || '-01-01','YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(isoyear FROM datum) || '-12-31','YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum,'mmyyyy') AS mmyyyy,
       TO_CHAR(datum,'mmddyyyy') AS mmddyyyy,
       CASE
         WHEN EXTRACT(isodow FROM datum) IN (6,7) THEN FALSE
         ELSE FALSE
       END AS weekend_indr
FROM (SELECT '1997-07-02'::DATE+ SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES (0,29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;
CREATE TABLE dds.type_of_system_emp_skill_level (
	"user_id" int4 NULL,
	"id" int4 null,
	"type_of_system" text NULL,
	"date" date NULL,
	"skill_level" text NULL,
	"type_of_skill" text null
);

CREATE TABLE datamart.dim_employee (
    "emp_dim_key" SERIAL PRIMARY KEY,
	"emp_id" int4 NULL,
	"emp_active" boolean NULL,
	"emp_job_title" text NULL,
	"emp_role" text NULL,
	"emp_level" text NULL
);

CREATE TABLE datamart.dim_skills (
	sk_dim_key serial4 NOT NULL,
	sk_id int4 NULL,
	skill text NULL,
	sk_type int4 NULL,
	CONSTRAINT dim_skills_pkey PRIMARY KEY (sk_dim_key),
	CONSTRAINT f_dim_sk FOREIGN KEY (sk_type) REFERENCES datamart.dim_skill_types(sk_t_dim_key)
);

CREATE TABLE datamart.dim_skill_level (
    "sk_l_dim_key" SERIAL PRIMARY KEY,
    "sk_l_id" int4 null,
    "skill_level" text null
);

CREATE TABLE datamart.dim_skill_types (
    "sk_t_dim_key" SERIAL PRIMARY KEY,
    "skill_type" text NULL,
    "is_skill" boolean NULL,
    "is_industry" boolean NULL
);

CREATE TABLE datamart.fact_skills (
	sk_f_key serial4 NOT NULL,
	sk_f_id int4 NULL,
	emp_key int4 NULL,
	sk_dim_key int4 NULL,
	sk_l_dim_key int4 NULL,
	sk_t_dim_key int4 NULL,
	is_skill bool NULL,
	is_industry bool NULL,
	date_dim_id int4 NULL,
	CONSTRAINT fact_skills_pkey PRIMARY KEY (sk_f_key),
	CONSTRAINT f_dim_d FOREIGN KEY (date_dim_id) REFERENCES datamart.dim_date(date_dim_id),
	CONSTRAINT f_dim_emp FOREIGN KEY (emp_key) REFERENCES datamart.dim_employee(emp_dim_key),
	CONSTRAINT f_dim_sk FOREIGN KEY (sk_dim_key) REFERENCES datamart.dim_skills(sk_dim_key),
	CONSTRAINT f_dim_sk_l FOREIGN KEY (sk_l_dim_key) REFERENCES datamart.dim_skill_level(sk_l_dim_key),
	CONSTRAINT f_dim_sk_t FOREIGN KEY (sk_t_dim_key) REFERENCES datamart.dim_skill_types(sk_t_dim_key)
);



