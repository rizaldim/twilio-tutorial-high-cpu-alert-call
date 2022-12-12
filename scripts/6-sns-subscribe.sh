#!/bin/bash

lambda_arn=$(aws lambda list-functions \
  --query 'Functions[?FunctionName==`high-cpu-call`] | [0].FunctionArn' \
  --output text)

sns_topic_arn=$(aws sns list-topics \
  --query 'Topics[?ends_with(TopicArn, `:HighUsageCpuTopic`)] | [0].TopicArn' \
  --output text)

aws sns subscribe \
  --topic-arn $sns_topic_arn \
  --protocol lambda \
  --notification-endpoint $lambda_arn

aws lambda add-permission \
  --function-name high-cpu-call \
  --action lambda:InvokeFunction \
  --statement-id sns-topic-HighUsageCpuTopic \
  --principal sns.amazonaws.com \
  --source-arn $sns_topic_arn

