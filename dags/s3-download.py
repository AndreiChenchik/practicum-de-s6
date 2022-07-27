import os
import boto3

AWS_ACCESS_KEY_ID = os.environ["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY = os.environ["AWS_SECRET_ACCESS_KEY"]

session = boto3.session.Session()
s3_client = session.client(
    service_name="s3",
    endpoint_url="https://storage.yandexcloud.net",
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
)
s3_client.download_file(
    Bucket="sprint6", Key="groups.csv", Filename="/data/groups.csv"
)

# 3.2.1 Двигайтесь дальше! Ваш код: NSVMjNvvxQ
