CREATE DATABASE S3_PROJECT;
CREATE SCHEMA S3_PROJ;

CREATE OR REPLACE STORAGE INTEGRATION aws_s3_integration
type = external_stage
storage_provider = 'S3'
enabled=true
storage_aws_role_arn='arn:aws:iam::148471921391:role/snowflake-s3-demo-proj'
storage_allowed_locations=('s3://snowflake-s3-demo-proj/');

show integrations;

DESC integration aws_s3_integration;

GRANT USAGE ON INTEGRATION AWS_S3_INTEGRATION TO ROLE ACCOUNTADMIN;

CREATE OR REPLACE FILE FORMAT PROJ_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1;

CREATE OR REPLACE STAGE PROJ_AWS_STAGE
STORAGE_INTEGRATION = AWS_S3_INTEGRATION
FILE_FORMAT= PROJ_FORMAT
URL = 's3://snowflake-s3-demo-proj/';

LIST @PROJ_AWS_STAGE;

CREATE OR REPLACE TABLE CUSTOMER_SHOPPING_DATA (
invoice_no STRING,
customer_id STRING,
gender STRING,
age STRING,
category STRING,
quantity STRING,
price STRING,
payment_method STRING,
invoice_date STRING,
shopping_mall STRING
);

SELECT * FROM CUSTOMER_SHOPPING_DATA LIMIT 10;

COPY INTO CUSTOMER_SHOPPING_DATA 
FROM @PROJ_AWS_STAGE/customer_shopping_data.csv
FILE_FORMAT = (FORMAT_NAME=PROJ_FORMAT);



