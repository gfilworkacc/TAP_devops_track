## AWS lab 5:

### Task 1:

Followed this guide https://docs.aws.amazon.com/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html :

- Enabled static website hosting;

- Allowed public access;

- Added bucket policy:

![](bucket_policy.png)

S3 bucket in now publicly accessible for reading:

```bash
curl -IL http://tap-georgif-bucket.s3-website.eu-central-1.amazonaws.com/index.html
```

```bash
HTTP/1.1 200 OK
x-amz-id-2: HLEWOnbKGY8NOpKUA1tN2bh7cRNcQFYWdLIwsax5V6cooHtXQn/YCrqiJYsGnAuX4ip8g5zdyg4=
x-amz-request-id: K646YCHQD0M1PDR3
Date: Fri, 21 Jan 2022 10:39:52 GMT
Last-Modified: Fri, 21 Jan 2022 10:25:51 GMT
ETag: "6ea250d1b4ead3a22f412c74d29ac817"
Content-Type: text/html
Server: AmazonS3
Content-Length: 3520
```

### Task 2:

Follow this guide https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html#with-s3-example-configure-event-source for Lambda function creation :

Created the function and added the S3 trigger separately:

![](trigger.png)

Used pre-generated function code, Webhook URL and POST method example from https://infinitelambda.slack.com/services/B02UTU4DMSS?added=1 and altered the function code like this:

```python
import json
import urllib.parse
import boto3
from botocore.vendored import requests

url = "https://hooks.slack.com/services/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"

payload = "{\"channel\": \"#tap-devops-2021-for-lambda-testing\", \"username\": \"webhookbot\", \"text\": \"Simple notification for new object in tap-georgif-bucket.\", \"icon_emoji\": \":call_me_hand:\"}"

s3 = boto3.client('s3')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        response_bucket = s3.get_object(Bucket=bucket, Key=key)
        requests.request("POST", url, data=payload)
        return
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
```

![](func.png)

