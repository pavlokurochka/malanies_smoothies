-- lesson2

--Check the range of values in the Market Segment Column
SELECT DISTINCT c_mktsegment
FROM 
SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
-- SHOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
     -- SHOWFLAKE_SAMPLE_DATA

--Find out which Market Segments have the most customers
SELECT c_mktsegment, COUNT(*)
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
GROUP BY c_mktsegment
ORDER BY COUNT(*);

-- Nations Table
SELECT N_NATIONKEY, N_NAME, N_REGIONKEY
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;

-- Regions Table
SELECT R_REGIONKEY, R_NAME
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION;

-- Join the Tables and Sort
SELECT R_NAME as Region, N_NAME as Nation
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION 
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION 
ON N_REGIONKEY = R_REGIONKEY
ORDER BY R_NAME, N_NAME ASC;

--Group and Count Rows Per Region
SELECT R_NAME as Region, count(N_NAME) as NUM_COUNTRIES
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION 
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION 
ON N_REGIONKEY = R_REGIONKEY
GROUP BY R_NAME;


show user functions in account;

-- did you put it here?
select * 
from util_db.information_schema.functions
where function_name = 'GRADER'
and function_catalog = 'UTIL_DB'
and function_owner = 'ACCOUNTADMIN';


grant usage 
on function UTIL_DB.PUBLIC.GRADER(VARCHAR, BOOLEAN, NUMBER, NUMBER, VARCHAR) 
to SYSADMIN ;


select GRADER(step,(actual = expected), actual, expected, description) as graded_results from (
SELECT 'DORA_IS_WORKING' as step
 ,(select 223 ) as actual
 ,223 as expected
 ,'Dora is working!' as description
); 

-- lesson 3

use role SYSADMIN;
-- create database INTL_DB;
USE database INTL_DB;
use schema PUBLIC;

create warehouse INTL_WH 
with 
warehouse_size = 'XSMALL' 
warehouse_type = 'STANDARD' 
auto_suspend = 600 --600 seconds/10 mins
auto_resume = TRUE;

use warehouse INTL_WH;

create or replace table intl_db.public.INT_STDS_ORG_3166 
(iso_country_name varchar(100), 
 country_name_official varchar(200), 
 sovreignty varchar(40), 
 alpha_code_2digit varchar(2), 
 alpha_code_3digit varchar(3), 
 numeric_country_code integer,
 iso_subdivision varchar(15), 
 internet_domain_code varchar(10)
);

create or replace file format util_db.public.PIPE_DBLQUOTE_HEADER_CR 
  type = 'CSV' --use CSV for any flat file
  compression = 'AUTO' 
  field_delimiter = '|' --pipe or vertical bar
  record_delimiter = '\r' --carriage return
  skip_header = 1  --1 header row
  field_optionally_enclosed_by = '\042'  --double quotes
  trim_space = FALSE;

show stages in account; 

create stage util_db.public.aws_s3_bucket url = 's3://uni-cmcw';

list @util_db.public.aws_s3_bucket;

  copy into intl_db.public.INT_STDS_ORG_3166 
from @util_db.public.aws_s3_bucket
files = ( 'ISO_Countries_UTF8_pipe.csv')
file_format = ( format_name=util_db.public.PIPE_DBLQUOTE_HEADER_CR  );

select count(*) as found, '249' as expected 
from INTL_DB.PUBLIC.INT_STDS_ORG_3166; 

use role accountadmin;
use database util_db; 
use schema public; 

select grader(step, (actual = expected), actual, expected, description) as graded_results from( 
 SELECT 'CMCW01' as step
 ,( select count(*) 
   from snowflake.account_usage.databases
   where database_name = 'INTL_DB' 
   and deleted is null) as actual
 , 1 as expected
 ,'Created INTL_DB' as description
 );

select count(*) as OBJECTS_FOUND
from INTL_DB.INFORMATION_SCHEMA.TABLES 
where table_schema='PUBLIC'
and table_name= 'INT_STDS_ORG_3166';

select row_count
from INTL_DB.INFORMATION_SCHEMA.TABLES 
where table_schema='PUBLIC'
and table_name= 'INT_STDS_ORG_3166';

select grader(step, (actual = expected), actual, expected, description) as graded_results from(
SELECT 'CMCW02' as step
 ,( select count(*) 
   from INTL_DB.INFORMATION_SCHEMA.TABLES 
   where table_schema = 'PUBLIC' 
   and table_name = 'INT_STDS_ORG_3166') as actual
 , 1 as expected
 ,'ISO table created' as a description
);

select grader(step, (actual = expected), actual, expected, description) as graded_results from( 
SELECT 'CMCW03' as step 
 ,(select row_count 
   from INTL_DB.INFORMATION_SCHEMA.TABLES  
   where table_name = 'INT_STDS_ORG_3166') as actual 
 , 249 as expected 
 ,'ISO Table Loaded' as description 
); 

create view intl_db.public.NATIONS_SAMPLE_PLUS_ISO 
( iso_country_name
  ,country_name_official
  ,alpha_code_2digit
  ,region) AS
 select  
     iso_country_name
    ,country_name_official,alpha_code_2digit
    ,r_name as region
from INTL_DB.PUBLIC.INT_STDS_ORG_3166 i
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION n
on upper(i.iso_country_name)= n.n_name
left join SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION r
on n_regionkey = r_regionkey;

select *
from intl_db.public.NATIONS_SAMPLE_PLUS_ISO;

select grader(step, (actual = expected), actual, expected, description) as graded_results from(
SELECT 'CMCW04' as step
 ,( select count(*) 
   from INTL_DB.PUBLIC.NATIONS_SAMPLE_PLUS_ISO) as actual
 , 249 as expected
 ,'Nations Sample Plus Iso' as description
);

use role SYSADMIN;


-- create database INTL_DB;
USE database INTL_DB;
use schema PUBLIC;
create table intl_db.public.CURRENCIES 
(
  currency_ID integer, 
  currency_char_code varchar(3), 
  currency_symbol varchar(4), 
  currency_digital_code varchar(3), 
  currency_digital_name varchar(30)
)
  comment = 'Information about currencies including character codes, symbols, digital codes, etc.';

  create table intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE 
  (
    country_char_code varchar(3), 
    country_numeric_code integer, 
    country_name varchar(100), 
    currency_name varchar(100), 
    currency_char_code varchar(3), 
    currency_numeric_code integer
  ) 
  comment = 'Mapping table currencies to countries';

   create file format util_db.public.CSV_COMMA_LF_HEADER
  type = 'CSV' 
  field_delimiter = ',' 
  record_delimiter = '\n' -- the n represents a Line Feed character
  skip_header = 1 
;

  copy into intl_db.public.CURRENCIES 
from @util_db.public.aws_s3_bucket
files = ( 'currencies.csv')
file_format = ( format_name=util_db.public.CSV_COMMA_LF_HEADER  );

  copy into intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE 
from @util_db.public.aws_s3_bucket
files = ( 'country_code_to_currency_code.csv')
file_format = ( format_name=util_db.public.CSV_COMMA_LF_HEADER  );

use role accountadmin;
use database util_db; 
use schema public; 
select grader(step, (actual = expected), actual, expected, description) as graded_results from(
SELECT 'CMCW05' as step
 ,(select row_count 
  from INTL_DB.INFORMATION_SCHEMA.TABLES 
  where table_schema = 'PUBLIC' 
  and table_name = 'COUNTRY_CODE_TO_CURRENCY_CODE') as actual
 , 265 as expected
 ,'CCTCC Table Loaded' as description
);

select grader(step, (actual = expected), actual, expected, description) as graded_results from(
SELECT 'CMCW06' as step
 ,(select row_count 
  from INTL_DB.INFORMATION_SCHEMA.TABLES 
  where table_schema = 'PUBLIC' 
  and table_name = 'CURRENCIES') as actual
 , 151 as expected
 ,'Currencies table loaded' as description
);



create or replace view intl_db.public.simple_currency as
select country_char_code as cty_code , currency_char_code as cur_code
from intl_db.public.COUNTRY_CODE_TO_CURRENCY_CODE ;


use role SYSADMIN;
use database util_db; 
use schema public; 

--DO NOT EDIT BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description) as graded_results from(
 SELECT 'CMCW07' as step 
,( select count(*) 
  from INTL_DB.PUBLIC.SIMPLE_CURRENCY ) as actual
, 265 as expected
,'Simple Currency Looks Good' as description
);


-- lesson 4-6

alter view intl_db.public.NATIONS_SAMPLE_PLUS_ISO
set secure; 

alter view intl_db.public.SIMPLE_CURRENCY
set secure; 




use role ACCOUNTADMIN;
use database util_db; 
use schema public; 


--This DORA Check Requires that you RUN two Statements, one right after the other
show shares in account;
--the above command puts information into memory that can be accessed using result_scan(last_query_id())
-- If you have to run this check more than once, always run the SHOW command immediately prior
select grader(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'CMCW08' as step
 ,( select IFF(count(*)>0,1,0) 
    from table(result_scan(last_query_id())) 
    where "kind" = 'OUTBOUND'
    and "database_name" = 'INTL_DB') as actual
 , 1 as expected
 ,'Outbound Share Created From INTL_DB' as description
); 


select *
    from table(result_scan( )) ;

   select result_scan(last_query_id());

   select *
    from table(result_scan(last_query_id())) 
    where "kind" = 'OUTBOUND'
    and "database_name" = 'INTL_DB';



alter RESOURCE MONITOR IDENTIFIER('"DAILY_3_CREDIT_LIMIT"') set CREDIT_QUOTA = 10 TRIGGERS ON 85 PERCENT DO SUSPEND ON 95 PERCENT DO SUSPEND_IMMEDIATE ON 75 PERCENT DO NOTIFY;

--This DORA Check Requires that you RUN two Statements, one right after the other
show resource monitors in account;

--the above command puts information into memory that can be accessed using result_scan(last_query_id())
-- If you have to run this check more than once, always run the SHOW command immediately prior
select grader(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'CMCW09' as step
 ,( select IFF(count(*)>0,1,0) 
    from table(result_scan(last_query_id())) 
    where "name" = 'DAILY_3_CREDIT_LIMIT'
    and "credit_quota" = 3
    and "frequency" = 'DAILY') as actual
 , 1 as expected
 ,'Resource Monitors Exist' as description
);     

 -- lesson7
use role SYSADMIN;
-- create database INTL_DB;
USE database WEATHERSOURCE;
use schema STANDARD_TILE;

-- lesson 9
--RUN THIS DORA CHECK IN YOUR ORIGINAL TRIAL ACCOUNT
select grader(step, (actual = expected), actual, expected, description) as graded_results from ( SELECT 'CMCW12' as step ,( select count(*) from SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS where account_name = 'ACME' 
 and region like 'AZURE_%' and deleted_on is null) as actual , 1 as expected ,'ACME Account Added on Azure Platform' as description ); 

 select grader(step, (actual = expected), actual, expected, description) as graded_results from (
SELECT 
  'CMCW13' as step
 ,( select count(*) 
   from SNOWFLAKE.ORGANIZATION_USAGE.ACCOUNTS 
   where account_name = 'AUTO_DATA_UNLIMITED' 
   and region like 'GCP_%'
   and deleted_on is null) as actual
 , 1 as expected
 ,'ADU Account Added on GCP' as description
); 


