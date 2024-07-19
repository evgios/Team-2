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



