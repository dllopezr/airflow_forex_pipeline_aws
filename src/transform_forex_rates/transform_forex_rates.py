import boto3
import json
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import lit, map_keys

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init("glueetl")

input_bucket_name = "forex-rates-data-david-lopez"
output_bucket_name = "transformed-forex-rates-david-lopez"
client = boto3.client('s3')

# Get the file names
response = client.list_objects(Bucket=input_bucket_name)
contents = response['Contents']
files = [file['Key'] for file in contents]


def normalize_df(base_currency, df):
    df = df.select("base", "last_update", "rates.*")
    df = df.withColumn(base_currency, lit(1.0))
    
    return df

def order_columns(df):
    currencies_columns = df.columns[2:]
    sorted_currencies_columns = sorted(currencies_columns)
    df_normalized = df.select("base")
    for column in sorted_currencies_columns:
      value = df.select(column).first()[0]
      df_normalized = df_normalized.withColumn(column, lit(value))
    last_update = df.select("last_update").first()[0]
    df_normalized= df_normalized.withColumn("last_update", lit(last_update))
    
    return df_normalized

# Transform files
for file in files:
    base_currency = file.split('/')[0]
    last_update = file.split('/')[1].split('.')[0]
    df = spark.read.json(f"s3a://{input_bucket_name}/{file}")
    df = normalize_df(base_currency, df)
    df.show(truncate=False)
    df = order_columns(df)

    # Save to s3
    df.write.csv(f"s3a://{output_bucket_name}/{base_currency}", header=True, mode="overwrite")

job.commit()