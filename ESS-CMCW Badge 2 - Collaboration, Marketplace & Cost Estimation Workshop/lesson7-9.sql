-- lesson 7

ALTER DATABASE GLOBAL_WEATHER__CLIMATE_DATA_FOR_BI rename to Weathersource;

select distinct country from WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY;


select POSTAL_CODE, count(1) count_ from  WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY
where left(postal_code,3) in ('481','482')
group by 1;

create database MARKETING;
use database MARKETING;
create schema MAILERS;

create view MARKETING.MAILERS.DETROIT_ZIPS as
select POSTAL_CODE, count(1) count_ from  WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY
where left(postal_code,3) in ('481','482')
group by 1;

select count(1) from WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY;

select count(1) from WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY hd
join MARKETING.MAILERS.DETROIT_ZIPS dz using (POSTAL_CODE);


select min(DATE_VALID_STD ) first_day,
max(DATE_VALID_STD ) last_day
from WEATHERSOURCE.STANDARD_TILE.HISTORY_DAY;

select min(DATE_VALID_STD ) first_day,
max(DATE_VALID_STD ) last_day
from WEATHERSOURCE.STANDARD_TILE.FORECAST_DAY;


select DATE_VALID_STD, avg (AVG_CLOUD_COVER_TOT_PCT) AVG_CLOUD_COVER_TOT_PCT 
from WEATHERSOURCE.STANDARD_TILE.FORECAST_DAY hd
join MARKETING.MAILERS.DETROIT_ZIPS dz using (POSTAL_CODE)
group by all
order by 2 ;


create database UTIL_DB ;
use database UTIL_DB ;

use role accountadmin;
create or replace api integration dora_api_integration api_provider = aws_api_gateway api_aws_role_arn = 'arn:aws:iam::321463406630:role/snowflakeLearnerAssumedRole' enabled = true api_allowed_prefixes = ('https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora');

show integrations;

create or replace external function util_db.public.grader(        
 step varchar     
 , passed boolean     
 , actual integer     
 , expected integer    
 , description varchar) 
 returns variant 
 api_integration = dora_api_integration 
 context_headers = (current_timestamp, current_account, current_statement, current_account_name) 
 as 'https://awy6hshxy4.execute-api.us-west-2.amazonaws.com/dev/edu_dora/grader'  
; 

--THIS DORA CHECK MUST BE RUN IN THE ACME ACCOUNT!!!!!
select grader(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'CMCW10' as step
 ,( select count(*)
    from snowflake.account_usage.databases
    where (database_name in ('WEATHERSOURCE','INTERNATIONAL_CURRENCIES')
           and type = 'IMPORTED DATABASE'
           and deleted is null)
    or (database_name = 'MARKETING'
          and type = 'STANDARD'
          and deleted is null)
   ) as actual
 , 3 as expected
 ,'ACME Account Set up nicely' as description
);  


--RUN THIS DORA CHECK IN YOUR ACME ACCOUNT

select grader(step, (actual = expected), actual, expected, description) as graded_results from (
SELECT 
  'CMCW11' as step
 ,( select count(*) 
   from MARKETING.MAILERS.DETROIT_ZIPS) as actual
 , 9 as expected
 ,'Detroit Zips' as description
); 


-- lesson 9

create database STOCK;
create schema UNSOLD;
drop schema PUBLIC;
create or replace table stock.unsold.lotstock
(
  vin varchar(25)
, exterior varchar(50)	
, interior varchar(50)
, manuf_name varchar(25)
, vehicle_type varchar(25)
, make_name varchar(25)
, plant_name varchar(25)
, model_year varchar(25)
, model_name varchar(25)
, desc1 varchar(25)
, desc2 varchar(25)
, desc3 varchar(25)
, desc4 varchar(25)
, desc5 varchar(25)
, engine varchar(25)
, drive_type varchar(25)
, transmission varchar(25)
, mpg varchar(25)
);

create stage stock.unsold.aws_s3_bucket url = 's3://uni-cmcw';

list @stock.unsold.aws_s3_bucket;

select $1, $2, $3
from @stock.unsold.aws_s3_bucket/Lotties_LotStock_Data.csv;

create file format util_db.public.CSV_COMMA_LF_HEADER
  type = 'CSV' 
  field_delimiter = ',' 
  record_delimiter = '\n' -- the n represents a Line Feed character
  skip_header = 1 
;

select $1 as VIN
, $2 as Exterior, $3 as Interior
from @stock.unsold.aws_s3_bucket/Lotties_LotStock_Data.csv
(file_format => util_db.public.CSV_COMMA_LF_HEADER);

CREATE FILE FORMAT util_db.public.CSV_COL_COUNT_DIFF 
type = 'CSV' 
field_delimiter = ',' 
record_delimiter = '\n' 
field_optionally_enclosed_by = '"'
trim_space = TRUE
error_on_column_count_mismatch = FALSE
parse_header = TRUE;


-- With a parsed header, Snowflake can MATCH BY COLUMN NAME during the COPY INTO
copy into stock.unsold.lotstock
from @stock.unsold.aws_s3_bucket/Lotties_LotStock_Data.csv
file_format = (format_name = util_db.public.csv_col_count_diff)
match_by_column_name='CASE_INSENSITIVE';

SELECT * from LOTSTOCK;

select * 
from table(ADU_VIN.DECODE.PARSE_AND_ENHANCE_VIN('5UXCR6C0XL9C77256'));

select * 
from stock.unsold.lotstock
where vin = '5J8YD4H86LL013641';

-- here we use ls for lotstock table and pf for parse function
-- this more complete statement lets us combine the data already in the table 
-- with the data returned from the parse function
select ls.vin, ls.exterior, ls.interior, pf.*
from
(select * 
from table(ADU_VIN.DECODE.PARSE_AND_ENHANCE_VIN('5J8YD4H86LL013641'))
) pf
join stock.unsold.lotstock ls
where pf.vin = ls.vin;
;

set my_vin = '5J8YD4H86LL013641';

select $my_vin;
select ls.vin, pf.manuf_name, pf.vehicle_type
        , pf.make_name, pf.plant_name, pf.model_year
        , pf.desc1, pf.desc2, pf.desc3, pf.desc4, pf.desc5
        , pf.engine, pf.drive_type, pf.transmission, pf.mpg
from stock.unsold.lotstock ls
join 
    (   select 
          vin, manuf_name, vehicle_type
        , make_name, plant_name, model_year
        , desc1, desc2, desc3, desc4, desc5
        , engine, drive_type, transmission, mpg
        from table(ADU_VIN.DECODE.PARSE_AND_ENHANCE_VIN($my_vin))
    ) pf
on pf.vin = ls.vin;

-- We're using "s" for "source." The joined data from the LotStock table and the parsing function will be a source of data for us. 
-- We're using "t" for "target." The LotStock table is the target table we want to update.
 
update stock.unsold.lotstock t
set manuf_name = s.manuf_name
, vehicle_type = s.vehicle_type
, make_name = s.make_name
, plant_name = s.plant_name
, model_year = s.model_year
, desc1 = s.desc1
, desc2 = s.desc2
, desc3 = s.desc3
, desc4 = s.desc4
, desc5 = s.desc5
, engine = s.engine
, drive_type = s.drive_type
, transmission = s.transmission
, mpg = s.mpg
from 
(
    select ls.vin, pf.manuf_name, pf.vehicle_type
        , pf.make_name, pf.plant_name, pf.model_year
        , pf.desc1, pf.desc2, pf.desc3, pf.desc4, pf.desc5
        , pf.engine, pf.drive_type, pf.transmission, pf.mpg
    from stock.unsold.lotstock ls
    join 
    (   select 
          vin, manuf_name, vehicle_type
        , make_name, plant_name, model_year
        , desc1, desc2, desc3, desc4, desc5
        , engine, drive_type, transmission, mpg
        from table(ADU_VIN.DECODE.PARSE_AND_ENHANCE_VIN($my_vin))
    ) pf
    on pf.vin = ls.vin
) s
where t.vin = s.vin;

set row_count = (select count(*) 
                from stock.unsold.lotstock
                where manuf_name is null);

select $row_count;

-- This scripting block runs very slow, but it shows how blocks work for people who are new to using them
DECLARE
    update_stmt varchar(2000);
    res RESULTSET;
    cur CURSOR FOR select vin from stock.unsold.lotstock where manuf_name is null;
BEGIN
    OPEN cur;
    FOR each_row IN cur DO
        update_stmt := 'update stock.unsold.lotstock t '||
            'set manuf_name = s.manuf_name ' ||
            ', vehicle_type = s.vehicle_type ' ||
            ', make_name = s.make_name ' ||
            ', plant_name = s.plant_name ' ||
            ', model_year = s.model_year ' ||
            ', desc1 = s.desc1 ' ||
            ', desc2 = s.desc2 ' ||
            ', desc3 = s.desc3 ' ||
            ', desc4 = s.desc4 ' ||
            ', desc5 = s.desc5 ' ||
            ', engine = s.engine ' ||
            ', drive_type = s.drive_type ' ||
            ', transmission = s.transmission ' ||
            ', mpg = s.mpg ' ||
            'from ' ||
            '(       select ls.vin, pf.manuf_name, pf.vehicle_type ' ||
                    ', pf.make_name, pf.plant_name, pf.model_year ' ||
                    ', pf.desc1, pf.desc2, pf.desc3, pf.desc4, pf.desc5 ' ||
                    ', pf.engine, pf.drive_type, pf.transmission, pf.mpg ' ||
                'from stock.unsold.lotstock ls ' ||
                'join ' ||
                '(   select' || 
                '     vin, manuf_name, vehicle_type' ||
                '    , make_name, plant_name, model_year ' ||
                '    , desc1, desc2, desc3, desc4, desc5 ' ||
                '    , engine, drive_type, transmission, mpg ' ||
                '    from table(ADU_VIN.DECODE.PARSE_AND_ENHANCE_VIN(\'' ||
                  each_row.vin || '\')) ' ||
                ') pf ' ||
                'on pf.vin = ls.vin ' ||
            ') s ' ||
            'where t.vin = s.vin;';
        res := (EXECUTE IMMEDIATE :update_stmt);
    END FOR;
        CLOSE cur;   
END;

-- set the worksheet drop lists to match the location of your GRADER function
--DO NOT MAKE ANY CHANGES BELOW THIS LINE

--RUN THIS DORA CHECK IN YOUR ACME ACCOUNT



use role accountadmin;
use database util_db;
use schema public;

select grader(step, (actual = expected), actual, expected, description) as graded_results from (
SELECT 
  'CMCW14' as step
 ,( select count(*) 
   from STOCK.UNSOLD.LOTSTOCK
   where engine like '%.5 L%'
   or plant_name like '%z, Sty%'
   or desc2 like '%xDr%') as actual
 , 145 as expected
 ,'Intentionally cryptic test' as description
); 

