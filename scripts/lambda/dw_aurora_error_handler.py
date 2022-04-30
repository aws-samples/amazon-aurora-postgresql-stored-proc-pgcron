import json
import os
import boto3

from botocore.exceptions import ClientError
import logging

def dw_aurora_error_handler(event, context):

    TOPIC_ARN = os.environ["TOPIC_ARN"]
    LOG_LEVEL = os.environ.get('LOG_LEVEL')

    logger = logging.getLogger()
    level = logging.getLevelName(LOG_LEVEL)

    if not isinstance(level, int):
    level = logging.INFO
    logger.setLevel(level)

    snsClient = boto3.client("sns")

    logger.info(f'TOPIC_ARN: {TOPIC_ARN}')

    try:
        res = snsClient.publish(TopicArn=TOPIC_ARN,
                                            Message=event["error"],
                                            Subject="Stored Procedure Error")

    except ClientError as e:
        print(e)
        raise e

    logger.info(f'----------- Finished SP Error Reporting -----------')
