create streaming table sales as 
select * from stream read_files("/Volumes/dev/bronze/raw/sales/",format=>"csv");

create streaming table products as 
select * from stream read_files("/Volumes/dev/bronze/raw/products/",format=>"csv");

create streaming table customers as 
select * from stream read_files("/Volumes/dev/bronze/raw/customers/",format=>"csv");