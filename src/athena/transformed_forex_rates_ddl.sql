CREATE EXTERNAL TABLE transformed_forex_rates(
  base string,
  cad double,
  eur double,
  gbp double,
  jpy double,
  nzd double,
  usd double,
  last_update timestamp)
PARTITIONED BY ( 
  country string
)
ROW FORMAT DELIMITED 
  FIELDS TERMINATED BY ',' 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.mapred.TextInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION
  's3://transformed-forex-rates-david-lopez/'
TBLPROPERTIES (
  'classification'='csv', 
  'partition_filtering.enabled'='true', 
  'skip.header.line.count'='1', 
  'typeOfData'='file')