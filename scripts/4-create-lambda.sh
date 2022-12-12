#!/bin/bash

aws iam create-role \
  --role-name lambda-role \
  --assume-role-policy-document file://policy.json

lambda_role_arn=$(aws iam list-roles \
  --query 'Roles[?RoleName==`lambda-role`].Arn | [0]' \
  --output text)

aws iam attach-role-policy \
  --role-name lambda-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

aws lambda create-function --function-name high-cpu-call \
  --runtime java11 \
  --zip-file fileb://lambda/build/distributions/java-events.zip \
  --handler example.HandlerSNS \
  --description 'Handle SNS event' \
  --memory-size 512 \
  --timeout 60 \
  --role $lambda_role_arn

