-- lesson3
-- use role sysadmin;
-- create or replace table GARDEN_PLANTS.VEGGIES.ROOT_DEPTH (
--    ROOT_DEPTH_ID number(1), 
--    ROOT_DEPTH_CODE text(1), 
--    ROOT_DEPTH_NAME text(7), 
--    UNIT_OF_MEASURE text(2),
--    RANGE_MIN number(2),
--    RANGE_MAX number(2)
--    ); 

--    USE WAREHOUSE COMPUTE_WH;

-- INSERT INTO GARDEN_PLANTS.VEGGIES.ROOT_DEPTH (
-- 	ROOT_DEPTH_ID ,
-- 	ROOT_DEPTH_CODE ,
-- 	ROOT_DEPTH_NAME ,
-- 	UNIT_OF_MEASURE ,
-- 	RANGE_MIN ,
-- 	RANGE_MAX 
-- )

-- VALUES
-- (
--     1,
--     'S',
--     'Shallow',
--     'cm',
--     30,
--     45
-- )
-- ;

insert into ROOT_DEPTH (root_depth_id, root_depth_code
                        , root_depth_name, unit_of_measure
                        , range_min, range_max)  
values
 (5,'X','short','in',66,77)
,(8,'Y','tall','cm',98,99)
;

SELECT *
FROM ROOT_DEPTH
LIMIT 3;

-- To remove a row you do not want in the table
delete from root_depth
where root_depth_id = 9;

--To change a value in a column for one particular row
update root_depth
set root_depth_id = 7
where root_depth_id = 9;

--To remove all the rows and start over
truncate table root_depth;

-- lesson6
-- create table garden_plants.veggies.vegetable_details
-- (
-- plant_name varchar(25)
-- , root_depth_code varchar(1)    
-- );

create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    TYPE = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    FIELD_DELIMITER = '|' --pipes as column separators
    SKIP_HEADER = 1 --one header row to skip
    ;

create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

-- lesson7

-- use role accountadmin;

-- create or replace api integration dora_api_integration
-- api_provider = aws_api_gateway
-- api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole'
-- enabled = true
-- api_allowed_prefixes = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');

-- use role accountadmin;  

-- create or replace external function util_db.public.grader(
--       step varchar
--     , passed boolean
--     , actual integer
--     , expected integer
--     , description varchar)
-- returns variant
-- api_integration = dora_api_integration 
-- context_headers = (current_timestamp, current_account, current_statement, current_account_name) 
-- as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'
-- ; 


-- use role accountadmin;
-- use database util_db; 
-- use schema public; 

-- select grader(step, (actual = expected), actual, expected, description) as graded_results from
-- (SELECT 
--  'DORA_IS_WORKING' as step
--  ,(select 123) as actual
--  ,123 as expected
--  ,'Dora is working!' as description
-- ); 

-- SELECT * 
-- FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA;

-- SELECT * 
-- FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
-- where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 



-- SELECT count(*) as SCHEMAS_FOUND, '3' as SCHEMAS_EXPECTED 
-- FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
-- where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 


--You can run this code, or you can use the drop lists in your worksheet to get the context settings right.
-- use database UTIL_DB;
-- use schema PUBLIC;
-- use role ACCOUNTADMIN;

-- --Do NOT EDIT ANYTHING BELOW THIS LINE
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT
--  'DWW01' as step
--  ,( select count(*)  
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
--    where schema_name in ('FLOWERS','VEGGIES','FRUITS')) as actual
--   ,3 as expected
--   ,'Created 3 Garden Plant schemas' as description
-- ); 


-- --Remember that every time you run a DORA check, the context needs to be set to the below settings. 
-- use database UTIL_DB;
-- use schema PUBLIC;
-- use role ACCOUNTADMIN;

-- --Do NOT EDIT ANYTHING BELOW THIS LINE
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW02' as step 
--  ,( select count(*) 
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA 
--    where schema_name = 'PUBLIC') as actual 
--  , 0 as expected 
--  ,'Deleted PUBLIC schema.' as description
-- );

-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW03' as step 
--  ,( select count(*) 
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
--    where table_name = 'ROOT_DEPTH') as actual 
--  , 1 as expected 
--  ,'ROOT_DEPTH Table Exists' as description
-- ); 


-- -- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW04' as step
--  ,( select count(*) as SCHEMAS_FOUND 
--    from UTIL_DB.INFORMATION_SCHEMA.SCHEMATA) as actual
--  , 2 as expected
--  , 'UTIL_DB Schemas' as description
-- ); 

-- -- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW05' as step
--  ,( select count(*) 
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
--    where table_name = 'VEGETABLE_DETAILS') as actual
--  , 1 as expected
--  ,'VEGETABLE_DETAILS Table' as description
-- ); 


-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
--  SELECT 'DWW06' as step 
-- ,( select row_count 
--   from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
--   where table_name = 'ROOT_DEPTH') as actual 
-- , 3 as expected 
-- ,'ROOT_DEPTH row count' as description
-- );
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW07' as step
--  ,( select row_count 
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
--    where table_name = 'VEGETABLE_DETAILS') as actual
--  , 41 as expected
--  , 'VEG_DETAILS row count' as description
-- ); 
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
--    SELECT 'DWW08' as step 
--    ,( select count(*) 
--      from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
--      where FIELD_DELIMITER =',' 
--      and FIELD_OPTIONALLY_ENCLOSED_BY ='"') as actual 
--    , 1 as expected 
--    , 'File Format 1 Exists' as description 
-- ); 
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW09' as step
--  ,( select count(*) 
--    from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
--    where FIELD_DELIMITER ='|' 
--    ) as actual
--  , 1 as expected
--  ,'File Format 2 Exists' as description
-- ); 

-- lesson8 

-- list @LIKE_A_WINDOW_INTO_AN_S3_BUCKET

-- list @LIKE_A_WINDOW_INTO_AN_S3_BUCKET/THIS_file.TXT
-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--  SELECT 'DWW10' as step
--   ,( select count(*) 
--     from UTIL_DB.INFORMATION_SCHEMA.stages
--     where stage_url='s3://uni-lab-files' 
--     and stage_type='External Named') as actual
--   , 1 as expected
--   , 'External stage created' as description
--  ); 

-- use database GARDEN_PLANTS; 

-- create or replace table vegetable_details_soil_type
-- ( plant_name varchar(25)
--  ,soil_type number(1,0)
-- );

-- copy into vegetable_details_soil_type
-- from @util_db.public.like_a_window_into_an_s3_bucket
-- files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
-- file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );

-- select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
--   SELECT 'DWW11' as step
--   ,( select row_count 
--     from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
--     where table_name = 'VEGETABLE_DETAILS_SOIL_TYPE') as actual
--   , 42 as expected
--   , 'Veg Det Soil Type Count' as description
--  ); 



create OR REPLACE file format garden_plants.veggies.L8_CHALLENGE_FF 
    TYPE = 'CSV'--csv for comma separated files
    SKIP_HEADER = 1 --one header row  
    FIELD_DELIMITER = '\t' 
    -- FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;
    

--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  


--Same file but with the other file format we created earlier
-- select $1, $2, $3
-- from @util_db.public.like_a_window_into_an_s3_bucket/LU_SOIL_TYPE.tsv
-- (file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );

use database GARDEN_PLANTS;
USE SCHEMA veggies;
create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
 );


 copy into LU_SOIL_TYPE
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'LU_SOIL_TYPE.tsv')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.L8_CHALLENGE_FF );

create or replace table VEGETABLE_DETAILS_PLANT_HEIGHT 
(plant_name varchar(50) ,
UOM char(1),
Low_End_of_Range number,
High_End_of_Range number);

select $1, $2, $3, $4
from @util_db.public.like_a_window_into_an_s3_bucket/veg_plant_height.csv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

 copy into VEGETABLE_DETAILS_PLANT_HEIGHT
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'veg_plant_height.csv')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW );


use database util_db; 
use schema public; 
-- DO NOT EDIT ANYTHING BELOW THIS LINE. THE CODE MUST BE RUN EXACTLY AS IT IS WRITTEN
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
      SELECT 'DWW12' as step 
      ,( select row_count 
        from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
        where table_name = 'VEGETABLE_DETAILS_PLANT_HEIGHT') as actual 
      , 41 as expected 
      , 'Veg Detail Plant Height Count' as description   
); 

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW13' as step 
     ,( select row_count 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.TABLES 
       where table_name = 'LU_SOIL_TYPE') as actual 
     , 8 as expected 
     ,'Soil Type Look Up Table' as description   
); 

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from ( 
     SELECT 'DWW14' as step 
     ,( select count(*) 
       from GARDEN_PLANTS.INFORMATION_SCHEMA.FILE_FORMATS 
       where FILE_FORMAT_NAME='L8_CHALLENGE_FF' 
       and FIELD_DELIMITER = '\t') as actual 
     , 1 as expected 
     ,'Challenge File Format Created' as description  
); 

-- lesson9

use role sysadmin;

-- // Create a new database and set the context to use the new database
-- CREATE DATABASE LIBRARY_CARD_CATALOG COMMENT = 'DWW Lesson 9 ';
-- USE DATABASE LIBRARY_CARD_CATALOG;

-- // Create Author table
-- CREATE OR REPLACE TABLE AUTHOR (
--    AUTHOR_UID NUMBER 
--   ,FIRST_NAME VARCHAR(50)
--   ,MIDDLE_NAME VARCHAR(50)
--   ,LAST_NAME VARCHAR(50)
-- );

-- // Insert the first two authors into the Author table
-- INSERT INTO AUTHOR(AUTHOR_UID,FIRST_NAME,MIDDLE_NAME, LAST_NAME) 
-- Values
-- (1, 'Fiona', '','Macdonald')
-- ,(2, 'Gian','Paulo','Faleschini');

-- SELECT * 
-- FROM AUTHOR;

-- use role sysadmin;



-- drop sequence SEQ_AUTHOR_UID;

-- create or replace  sequence SEQ_AUTHOR_UID
-- start = 3
-- increment  = 1
-- ORDER
-- comment = 'Use this to fill in the AUTHOR_UID every time you add a row';;

-- //See how the nextval function works
-- SELECT SEQ_AUTHOR_UID.nextval;


-- //Add the remaining author records and use the nextval function instead 
-- //of putting in the numbers
-- INSERT INTO AUTHOR(AUTHOR_UID,FIRST_NAME,MIDDLE_NAME, LAST_NAME) 
-- Values
-- (SEQ_AUTHOR_UID.nextval, 'Laura', 'K','Egendorf')
-- ,(SEQ_AUTHOR_UID.nextval, 'Jan', '','Grover')
-- ,(SEQ_AUTHOR_UID.nextval, 'Jennifer', '','Clapp')
-- ,(SEQ_AUTHOR_UID.nextval, 'Kathleen', '','Petelinsek');

USE DATABASE LIBRARY_CARD_CATALOG;

// Create a new sequence, this one will be a counter for the book table
CREATE OR REPLACE SEQUENCE "LIBRARY_CARD_CATALOG"."PUBLIC"."SEQ_BOOK_UID" 
START 1 
INCREMENT 1 
COMMENT = 'Use this to fill in the BOOK_UID everytime you add a row';

// Create the book table and use the NEXTVAL as the 
// default value each time a row is added to the table
CREATE OR REPLACE TABLE BOOK
( BOOK_UID NUMBER DEFAULT SEQ_BOOK_UID.nextval
 ,TITLE VARCHAR(50)
 ,YEAR_PUBLISHED NUMBER(4,0)
);

// Insert records into the book table
// You don't have to list anything for the
// BOOK_UID field because the default setting
// will take care of it for you
INSERT INTO BOOK(TITLE,YEAR_PUBLISHED)
VALUES
 ('Food',2001)
,('Food',2006)
,('Food',2008)
,('Food',2016)
,('Food',2015);

// Create the relationships table
// this is sometimes called a "Many-to-Many table"
CREATE TABLE BOOK_TO_AUTHOR
(  BOOK_UID NUMBER
  ,AUTHOR_UID NUMBER
);

//Insert rows of the known relationships
INSERT INTO BOOK_TO_AUTHOR(BOOK_UID,AUTHOR_UID)
VALUES
 (1,1)  // This row links the 2001 book to Fiona Macdonald
,(1,2)  // This row links the 2001 book to Gian Paulo Faleschini
,(2,3)  // Links 2006 book to Laura K Egendorf
,(3,4)  // Links 2008 book to Jan Grover
,(4,5)  // Links 2016 book to Jennifer Clapp
,(5,6); // Links 2015 book to Kathleen Petelinsek


//Check your work by joining the 3 tables together
//You should get 1 row for every author
select * 
from book_to_author ba 
join author a 
on ba.author_uid = a.author_uid 
join book b 
on b.book_uid=ba.book_uid; 

use role accountadmin;
use database util_db; 
use schema public; 

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (  
     SELECT 'DWW15' as step 
     ,( select count(*) 
      from LIBRARY_CARD_CATALOG.PUBLIC.Book_to_Author ba 
      join LIBRARY_CARD_CATALOG.PUBLIC.author a 
      on ba.author_uid = a.author_uid 
      join LIBRARY_CARD_CATALOG.PUBLIC.book b 
      on b.book_uid=ba.book_uid) as actual 
     , 6 as expected 
     , '3NF DB was Created.' as description  
); 

-- lesson 10
-- // JSON DDL Scripts
-- USE LIBRARY_CARD_CATALOG;

-- // Create an Ingestion Table for JSON Data
-- CREATE TABLE LIBRARY_CARD_CATALOG.PUBLIC.AUTHOR_INGEST_JSON 
-- (
--   RAW_AUTHOR VARIANT
-- );

-- CREATE FILE FORMAT LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT 
-- TYPE = 'JSON' 
-- COMPRESSION = 'AUTO' 
-- ENABLE_OCTAL = TRUE
-- ALLOW_DUPLICATE = TRUE 
-- STRIP_OUTER_ARRAY = TRUE
-- STRIP_NULL_VALUES = TRUE 
-- IGNORE_UTF8_ERRORS = TRUE; 


 copy into LIBRARY_CARD_CATALOG.PUBLIC.AUTHOR_INGEST_JSON 
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'author_with_header.json')
file_format = ( format_name=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT  );

USE DATABASE LIBRARY_CARD_CATALOG;
USE SCHEMA PUBLIC;
select RAW_AUTHOR from AUTHOR_INGEST_JSON;

//returns AUTHOR_UID value from top-level object's attribute
select raw_author:AUTHOR_UID
from author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;

use role accountadmin;
use database util_db; 
use schema public; 

-- Set your worksheet drop lists. DO NOT EDIT THE DORA CODE.
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW16' as step
  ,( select row_count 
    from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
    where table_name = 'AUTHOR_INGEST_JSON') as actual
  ,6 as expected
  ,'Check number of rows' as description
 ); 

-- lesson 11

USE DATABASE LIBRARY_CARD_CATALOG;
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON 
(
  "RAW_NESTED_BOOK" VARIANT
);


 copy into LIBRARY_CARD_CATALOG.PUBLIC.NESTED_INGEST_JSON 
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'json_book_author_nested.txt')
file_format = ( format_name=LIBRARY_CARD_CATALOG.PUBLIC.JSON_FILE_FORMAT  );

//a few simple queries
SELECT RAW_NESTED_BOOK
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:year_published
FROM NESTED_INGEST_JSON;

SELECT RAW_NESTED_BOOK:authors
FROM NESTED_INGEST_JSON;

//Use these example flatten commands to explore flattening the nested book and author data
SELECT value:first_name
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);

SELECT value:first_name
FROM NESTED_INGEST_JSON
,table(flatten(RAW_NESTED_BOOK:authors));

//Add a CAST command to the fields returned
SELECT value:first_name::VARCHAR, value:last_name::VARCHAR
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);

//Assign new column  names to the columns using "AS"
SELECT value:first_name::VARCHAR AS FIRST_NM
, value:last_name::VARCHAR AS LAST_NM
FROM NESTED_INGEST_JSON
,LATERAL FLATTEN(input => RAW_NESTED_BOOK:authors);



use role accountadmin;
use database util_db; 
use schema public; 


select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (   
     SELECT 'DWW17' as step 
      ,( select row_count 
        from LIBRARY_CARD_CATALOG.INFORMATION_SCHEMA.TABLES 
        where table_name = 'NESTED_INGEST_JSON') as actual 
      , 5 as expected 
      ,'Check number of rows' as description  
); 


//Create a new database to hold the Twitter file
CREATE DATABASE SOCIAL_MEDIA_FLOODGATES 
COMMENT = 'There\'s so much data from social media - flood warning';

USE DATABASE SOCIAL_MEDIA_FLOODGATES;

//Create a table in the new database
CREATE TABLE SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST 
("RAW_STATUS" VARIANT) 
COMMENT = 'Bring in tweets, one row per tweet or status entity';

//Create a JSON file format in the new database
CREATE FILE FORMAT SOCIAL_MEDIA_FLOODGATES.PUBLIC.JSON_FILE_FORMAT 
TYPE = 'JSON' 
COMPRESSION = 'AUTO' 
ENABLE_OCTAL = FALSE 
ALLOW_DUPLICATE = FALSE 
STRIP_OUTER_ARRAY = TRUE 
STRIP_NULL_VALUES = FALSE 
IGNORE_UTF8_ERRORS = FALSE;

 copy into SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST 
from @util_db.public.like_a_window_into_an_s3_bucket
files = ( 'nutrition_tweets.json')
file_format = ( format_name=SOCIAL_MEDIA_FLOODGATES.PUBLIC.JSON_FILE_FORMAT  );

//select statements as seen in the video
SELECT RAW_STATUS
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities
FROM TWEET_INGEST;

SELECT RAW_STATUS:entities:hashtags
FROM TWEET_INGEST;

//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
SELECT RAW_STATUS:entities:hashtags[0].text
FROM TWEET_INGEST;

//This version adds a WHERE clause to get rid of any tweet that 
//doesn't include any hashtags
SELECT RAW_STATUS:entities:hashtags[0].text
FROM TWEET_INGEST
WHERE RAW_STATUS:entities:hashtags[0].text is not null;

//Perform a simple CAST on the created_at key
//Add an ORDER BY clause to sort by the tweet's creation date
SELECT RAW_STATUS:created_at::DATE
FROM TWEET_INGEST
ORDER BY RAW_STATUS:created_at::DATE;

//Flatten statements that return the whole hashtag entity
SELECT value
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

SELECT value
FROM TWEET_INGEST
,TABLE(FLATTEN(RAW_STATUS:entities:hashtags));

//Flatten statement that restricts the value to just the TEXT of the hashtag
SELECT value:text
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);


//Flatten and return just the hashtag text, CAST the text as VARCHAR
SELECT value:text::VARCHAR
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

//Flatten and return just the hashtag text, CAST the text as VARCHAR
// Use the AS command to name the column
SELECT value:text::VARCHAR AS THE_HASHTAG
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);

//Add the Tweet ID and User ID to the returned table
SELECT RAW_STATUS:user:id AS USER_ID
,RAW_STATUS:id AS TWEET_ID
,value:text::VARCHAR AS HASHTAG_TEXT
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags);



use role accountadmin;
use database util_db; 
use schema public; 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
   SELECT 'DWW18' as step
  ,( select row_count 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.TABLES 
    where table_name = 'TWEET_INGEST') as actual
  , 9 as expected
  ,'Check number of rows' as description  
 ); 

create or replace view SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED as
(SELECT RAW_STATUS:user:id AS USER_ID
,RAW_STATUS:id AS TWEET_ID
,value:text::VARCHAR AS HASHTAG_TEXT
FROM TWEET_INGEST
,LATERAL FLATTEN
(input => RAW_STATUS:entities:hashtags)
);

select * from  SOCIAL_MEDIA_FLOODGATES.PUBLIC.HASHTAGS_NORMALIZED;

use role accountadmin;
use database util_db; 
use schema public; 
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from
(
  SELECT 'DWW19' as step
  ,( select count(*) 
    from SOCIAL_MEDIA_FLOODGATES.INFORMATION_SCHEMA.VIEWS 
    where table_name = 'HASHTAGS_NORMALIZED') as actual
  , 1 as expected
  ,'Check number of rows' as description
 ); 



 

