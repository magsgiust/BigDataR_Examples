-- do this because the join would take to long
alter table small_data_train_ids add row_id serial;

drop table if exists small_data_random_train;
create table small_data_random_train as 
  select *
  from small_data_train_ids
  order by random()
  limit (select count(*) from small_data_train) * .60;

drop table if exists small_data_random_test;
create table small_data_random_test as
  select 
    a.userid
    ,a.userid_id
    ,a.sku
    ,a.sku_id
    ,a.category
    ,a.category_id
    ,a.query
    ,a.query_id
    ,a.query_time
    ,a.click_time
  from small_data_train_ids a
  where a.row_id not in (select row_id from small_data_random_train);

-- BIG data
-- alter table big_data_train_ids add row_id serial;

-- drop table if exists big_data_random_train;
-- create table big_data_random_train as 
--   select *
--   from big_data_train_ids
--   order by random()
--   limit (select count(*) from big_data_train) * .60;

-- drop table if exists big_data_random_test;
-- create table big_data_random_test as
--   select 
--     a.userid
--     ,a.userid_id
--     ,a.sku
--     ,a.sku_id
--     ,a.category
--     ,a.category_id
--     ,a.query
--     ,a.query_id
--     ,a.query_time
--     ,a.click_time
--   from big_data_train_ids a
--   where a.row_id not in (select row_id from big_data_random_train);

-- export the sku mappings for predictions
drop table if exists small_data_temp;
create table small_data_temp as
select
  sku_id
  ,sku
from small_data_random_train;

-- drop table if exists big_data_temp;
-- create table big_data_temp as
-- select
--   sku_id
--   ,sku
-- from big_data_random_train;

copy small_data_temp to '/mnt/small_data_sku_mapping' with csv;
copy small_data_random_train to '/mnt/small_data_random_train' with csv;
copy small_data_random_test to '/mnt/small_data_random_test' with csv;
-- copy big_data_temp to '/mnt/big_data_sku_mapping' with csv;
-- copy big_data_train_ids to '/mnt/big_data_train_ids' with csv;
-- copy big_data_test_ids to '/mnt/big_data_test_ids' with csv;



