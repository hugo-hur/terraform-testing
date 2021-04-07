import json

def lambda_handler(event, context):
    # TODO implement
    print("Hello world!")
    print(json.dumps(event["Records"][0]))
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
