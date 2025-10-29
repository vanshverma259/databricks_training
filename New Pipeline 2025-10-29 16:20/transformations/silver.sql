create streaming table dev.silver.sales_cleaned 
( CONSTRAINT valid_order_id EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW 
)
select distinct * from stream dev.bronze.sales;

-- products scd 1
-- https://docs.databricks.com/aws/en/dlt-ref/dlt-sql-ref-apply-changes-into
-- Create a streaming table, then use AUTO CDC to populate it:

CREATE OR REFRESH STREAMING TABLE silver.products_silver;
CREATE FLOW product_flow
AS AUTO CDC INTO
  silver.products_silver
FROM stream(bronze.products)
  KEYS (product_id)
  APPLY AS DELETE WHEN operation = "DELETE"
  SEQUENCE BY seqNum
  COLUMNS * EXCEPT (operation, seqNum,_rescued_data)
  STORED AS SCD TYPE 1;
  --TRACK HISTORY ON * EXCEPT (city)



-- customers scd 2 

CREATE OR REFRESH STREAMING TABLE silver.customers_silver;
CREATE FLOW customers_flow
AS AUTO CDC INTO
  silver.customers_silver
FROM stream(bronze.customers)
  KEYS (customer_id)
  APPLY AS DELETE WHEN operation = "DELETE"
  SEQUENCE BY sequenceNum
  COLUMNS * EXCEPT (operation, sequenceNum,_rescued_data)
  STORED AS SCD TYPE 2;