import os
import boto3
import botocore

from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
async def read_root():
    return get_objects()


def get_objects():
    session = boto3.Session(
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        aws_session_token=os.getenv('AWS_SESSION_TOKEN')
    )

    s3 = boto3.resource('s3')
    content = '<ol>'
    bucket = s3.Bucket(os.getenv('S3_BUCKET_NAME'))
    for value in bucket.objects.all():
        content += f'<li>{value.key}</li>'
    content += '</ol>'
    return content
        