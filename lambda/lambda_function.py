import json
import logging
import json
import time
from time import time
from deltalake import write_deltalake

logging.getLogger().setLevel(logging.INFO)

def send_msg_async(msg):
    print("Sending message")
    try:
        import json
        from deltalake.writer import write_deltalake
        import pyarrow
        from pyarrow import json as pjson
        import pyarrow as pa
        
        schema = pa.schema([
    ("resource", pa.string()),
    ("path", pa.string()),
    ("httpMethod", pa.string()),
    ("headers", pa.struct({'Content-Type': pa.string(), 'Host' : pa.string(), 'User-Agent': pa.string(), 'X-Amzn-Trace-Id' : pa.string(), 'x-b3-parentspanid' : pa.string(), 'x-b3-sampled' : pa.string(), 'x-b3-spanid' : pa.string(), 'x-b3-traceid' : pa.string(), 'X-Forwarded-For' : pa.string(), 'X-Forwarded-Port' : pa.string(), 'X-Forwarded-Proto' : pa.string(), 'x-txpush-signature' : pa.string()})),
    ("multiValueHeaders", pa.struct({'Content-Type': pa.list_(pa.string()), 'Host' : pa.list_(pa.string()), 'User-Agent': pa.list_(pa.string()), 'X-Amzn-Trace-Id' : pa.list_(pa.string()), 'x-b3-parentspanid' : pa.list_(pa.string()), 'x-b3-sampled' : pa.list_(pa.string()), 'x-b3-spanid' : pa.list_(pa.string()), 'x-b3-traceid' : pa.list_(pa.string()), 'X-Forwarded-For' : pa.list_(pa.string()), 'X-Forwarded-Port' : pa.list_(pa.string()), 'X-Forwarded-Proto' : pa.list_(pa.string()), 'x-txpush-signature' : pa.list_(pa.string())})),
    ("queryStringParameters", pa.string()), 
  ("multiValueQueryStringParameters", pa.string()), 
    ("pathParameters", pa.string()),
   ("stageVariables", pa.string()),
    ("requestContext", pa.struct({'resourceId': pa.string(), 'resourcePath': pa.string(), 'httpMethod' : pa.string(), 'extendedRequestId' : pa.string(), 'requestTime' : pa.string(), 'accountId' : pa.string(), 'protocol' : pa.string(), 'stage' : pa.string(), 'domainPrefix' : pa.string(), 'requestTimeEpoch' : pa.float64(), 'requestId' : pa.string(), 'identity' : pa.struct({'cognitoIdentityPoolId' : pa.string(), 'accountId' : pa.string(), 'cognitoIdentityId' : pa.string(), 'caller' : pa.string(), 'sourceIp' : pa.string(), 'principalOrgId' : pa.string(), 'accessKey' : pa.string(), 'cognitoAuthenticationType' : pa.string(), 'cognitoAuthenticationProvider' : pa.string(), 'userArn' : pa.string(), 'userAgent' : pa.string(), 'user' : pa.string()}), 'domainName' : pa.string(), 'apiId' : pa.string() } )),
  ("body", pa.string()),
    ("isBase64Encoded", pa.bool_())
])


        table = pa.json.read_json(pa.py_buffer(bytes(msg, 'utf-8')), parse_options = pa.json.ParseOptions(explicit_schema=schema))
        print(table.take([0]))
        write_deltalake('s3://lakehouse-delta/api_txns15', table, mode='append')

    except Exception as ex:
        print("Error : ", ex)

def lambda_handler(event, context):

    # first try will register this API with the Finicity service
    try: 
        res = event['queryStringParameters']['txpush_verification_code']
        return {
        "statusCode": 200,
        "body": res, 
        "headers" : {"Content-Type" :  "text/plain"}
         }
         
    except:
        send_msg_async(json.dumps(event))

        return {
        'statusCode' : 200, 
        'body' : json.dumps(event)
        }

