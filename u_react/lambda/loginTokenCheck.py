import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    #Secrets manager that holds app secret
    secret_name = "prod/Orgs/LoginAuth"
    region_name = "us-west-1"
    clientName = "utah_nal_lab"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    #Get the value of the secret
    secret_value_response = client.get_secret_value(SecretId=secret_name)
    cognitoSecretNew = json.loads(secret_value_response["SecretString"])[clientName]
    

    if event['request']['validationData']['loginAuth'] == cognitoSecretNew:
        return event
    raise Exception("Cannot register for a orginzation that has not given permission token!")
    # Return to Amazon Cognito
    #return event