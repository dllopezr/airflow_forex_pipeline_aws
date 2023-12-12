import boto3
import csv
from io import StringIO
import json
import requests


def upload_data(outdata: dict, s3: "botocore.client.S3"):

    bucket_name = "forex-rates-data-david-lopez"
    base = outdata['base']
    last_update = outdata['last_update']
    filename = f"{base}/{last_update}.json"
    s3.put_object(
            Bucket=bucket_name,
            Key=filename,
            Body=json.dumps(outdata)
        )
    print(f"{filename} uploaded")

def lambda_handler(event, context):

    s3 = boto3.client("s3")
    BASE_URL = "https://gist.githubusercontent.com/marclamberti/f45f872dea4dfd3eaa015a4a1af4b39b/raw/"
    ENDPOINTS = {
        'USD': 'api_forex_exchange_usd.json',
        'EUR': 'api_forex_exchange_eur.json'
    }

    # Read currencies file from S3
    currencies_bucket = "airflow-forex-pipeline-david-lopez" #TODO: Change for an env variable inside the lambda function
    file_key = "forex_currencies.csv"
    forex_currencies = s3.get_object(Bucket=currencies_bucket, Key=file_key)
    forex_currencies = forex_currencies['Body'].read().decode('utf-8')
    reader = csv.DictReader(StringIO(forex_currencies), delimiter=';')

    # Request and save rates data in s3
    for idx, row in enumerate(reader):
        base = row['base']
        with_pairs = row['with_pairs'].split(' ')
        indata = requests.get(f"{BASE_URL}{ENDPOINTS[base]}").json()
        outdata = {'base': base, 'rates': {}, 'last_update': indata['date']}
        for pair in with_pairs:
            outdata['rates'][pair] = indata['rates'][pair]
        upload_data(outdata, s3)