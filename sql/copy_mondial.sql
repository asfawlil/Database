DROP TABLE IF EXISTS student37.my_country;
DROP TABLE IF EXISTS student37.my_countrypops;
create table student37.my_country as select * from country;
create table student37.my_countrypops as select * from countrypops;