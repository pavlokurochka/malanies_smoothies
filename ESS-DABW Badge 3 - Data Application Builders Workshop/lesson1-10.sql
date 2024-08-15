-- lesson 1-2

-- create database SMOOTHIES;

create table FRUIT_OPTIONS (
FRUIT_id number,
fruit_name varchar(50)
);

use util_db;
-- DO NOT EDIT ANYTHING BELOW THIS LINE
select grader(step, (actual = expected), actual, expected, description) as graded_results from 
  ( SELECT 
  'DORA_IS_WORKING' as step
 ,(select 223) as actual
 , 223 as expected
 ,'Dora is working!' as description
); 

-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DABW001' as step
 ,( select count(*) 
   from SMOOTHIES.PUBLIC.FRUIT_OPTIONS) as actual
 , 25 as expected
 ,'Fruit Options table looks good' as description
);

create table ORDERS (
ingredients varchar(200)
);

insert into smoothies.public.orders(ingredients) values ('Elderberries Guava Honeydew Cantaloupe Strawberries');

select * from ORDERS;
-- truncate table orders;

use util_db;
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
SELECT 'DABW002' as step
 ,(select IFF(count(*)>=5,5,0)
    from (select ingredients from smoothies.public.orders
    group by ingredients)
 ) as actual
 ,  5 as expected
 ,'At least 5 different orders entered' as description
);


select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DABW003' as step
 ,(select ascii(fruit_name) from smoothies.public.fruit_options
where fruit_name ilike 'z%') as actual
 , 90 as expected
 ,'A mystery check for the inquisitive' as description
);

-- lesson 4
create or replace TABLE SMOOTHIES.PUBLIC.ORDERS (
	INGREDIENTS VARCHAR(200),
	NAME_ON_ORDER VARCHAR(100),
	ORDER_FILLED BOOLEAN DEFAULT 'FALSE' 
);
-- select * from SMOOTHIES.PUBLIC.ORDERS;
-- list @~/worksheet_data;

-- alter table  SMOOTHIES.PUBLIC.ORDERS alter column order_filled   set default 'FALSE';

update smoothies.public.orders
       set order_filled = false
       where name_on_order is not null;

delete from smoothies.public.orders where name_on_order = 'Tanya';

select  * from smoothies.information_schema.columns
   where table_schema = 'PUBLIC' 
    and table_name = 'ORDERS'
       and column_name = 'ORDER_FILLED'
    and column_default = 'FALSE'
    and data_type = 'BOOLEAN'
    ;
    
use util_db;
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DABW004' as step
 ,( select count(*) from smoothies.information_schema.columns
    where table_schema = 'PUBLIC' 
    and table_name = 'ORDERS'
    and column_name = 'ORDER_FILLED'
    and column_default = 'FALSE'
    and data_type = 'BOOLEAN') as actual
 , 1 as expected
 ,'Order Filled is Boolean' as description
);

-- lesson 7

set mystery_bag = 'Bag is empt!';

select $mystery_bag;

create function sum_mystery_bag_vars(var1 number, var2 number , var3 number)
    returns number as 'select var1+var2+var3';

select sum_mystery_bag_vars(12,36,204);  


set this = -10.5;
set that = 2;
set the_other =  1000;


-- DO NOT EDIT ANYTHING BELOW THIS LINE
select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
  SELECT 'DABW006' as step
 ,( select util_db.public.sum_mystery_bag_vars($this,$that,$the_other)) as actual
 , 991.5 as expected
 ,'Mystery Bag Function Output' as description
);


create function NEUTRALIZE_WHINING(whiny text)  
    returns text as 'select INITCAP(whiny)';

select NEUTRALIZE_WHINING('wHY aRE yOU lIKE THIS?');


select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
 SELECT 'DABW007' as step
 ,( select hash(neutralize_whining('bUt mOm i wAsHeD tHe dIsHes yEsTeRdAy'))) as actual
 , -4759027801154767056 as expected
 ,'WHINGE UDF Works' as description
);

-- lesson 10

select * from ORDERS;

-- alter table SMOOTHIES.PUBLIC.FRUIT_OPTIONS add column SEARCH_ON varchar(50);
select * from FRUIT_OPTIONS;

UPDATE fruit_options SET  SEARCH_ON = 	'Apple'	WHERE  FRUIT_ID = 	1	;
UPDATE fruit_options SET  SEARCH_ON = 	'Blackberry'	WHERE  FRUIT_ID = 	2	;
UPDATE fruit_options SET  SEARCH_ON = 	'Melon'	WHERE  FRUIT_ID = 	3	;
UPDATE fruit_options SET  SEARCH_ON = 	'Dragonfruit'	WHERE  FRUIT_ID = 	4	;
				
UPDATE fruit_options SET  SEARCH_ON = 	'Fig'	WHERE  FRUIT_ID = 	6	;
UPDATE fruit_options SET  SEARCH_ON = 	'Guava'	WHERE  FRUIT_ID = 	7	;
UPDATE fruit_options SET  SEARCH_ON = 	'Melon'	WHERE  FRUIT_ID = 	8	;
UPDATE fruit_options SET  SEARCH_ON = 	'Jackfruit'	WHERE  FRUIT_ID = 	9	;
UPDATE fruit_options SET  SEARCH_ON = 	'Kiwi'	WHERE  FRUIT_ID = 	10	;
UPDATE fruit_options SET  SEARCH_ON = 	'Lime'	WHERE  FRUIT_ID = 	11	;
UPDATE fruit_options SET  SEARCH_ON = 	'Mango'	WHERE  FRUIT_ID = 	12	;
UPDATE fruit_options SET  SEARCH_ON = 	'Peach'	WHERE  FRUIT_ID = 	13	;
UPDATE fruit_options SET  SEARCH_ON = 	'Orange'	WHERE  FRUIT_ID = 	14	;
UPDATE fruit_options SET  SEARCH_ON = 	'Papaya'	WHERE  FRUIT_ID = 	15	;
				
UPDATE fruit_options SET  SEARCH_ON = 	'Raspberry'	WHERE  FRUIT_ID = 	17	;
UPDATE fruit_options SET  SEARCH_ON = 	'Strawberry'	WHERE  FRUIT_ID = 	18	;
UPDATE fruit_options SET  SEARCH_ON = 	'Tangerine'	WHERE  FRUIT_ID = 	19	;
				
				
UPDATE fruit_options SET  SEARCH_ON = 	'Watermelon'	WHERE  FRUIT_ID = 	22	;

select GRADER(step, (actual = expected), actual, expected, description) as graded_results from (
   SELECT 'DABW008' as step 
   ,( select sum(hash_ing) from
      (select hash(ingredients) as hash_ing
       from smoothies.public.orders
       where order_ts is not null 
       and name_on_order is not null 
       and (name_on_order = 'Kevin' and order_filled = FALSE and hash_ing = 7976616299844859825) 
       or (name_on_order ='Divya' and order_filled = TRUE and hash_ing = -6112358379204300652)
       or (name_on_order ='Xi' and order_filled = TRUE and hash_ing = 1016924841131818535))
     ) as actual 
   , 2881182761772377708 as expected 
   ,'Followed challenge lab directions' as description
); 


select hash(ingredients) as hash_ing, name_on_order
       from smoothies.public.orders
       where order_ts is not null 
       and name_on_order is not null 
       and (name_on_order = 'Kevin' and order_filled = FALSE --and hash_ing = 7976616299844859825
       ) 
       or (name_on_order ='Divya' and order_filled = TRUE -- and hash_ing = -6112358379204300652
       )
       or (name_on_order ='Xi' and order_filled = TRUE  -- and hash_ing = 1016924841131818535
       );

    update    smoothies.public.orders set ingredients = ingredients || ' ';
