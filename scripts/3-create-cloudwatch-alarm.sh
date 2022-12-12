#!/bin/bash

instance_id=$(aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?ImageId==`ami-08c40ec9ead489470`] | [0][0].InstanceId' \
    --output text)

sns_topic_arn=$(aws sns list-topics \
    --query 'Topics[?ends_with(TopicArn, `:HighUsageCpuTopic`)] | [0].TopicArn' \
    --output text)

aws cloudwatch put-metric-alarm \
    --alarm-name cpu-monitor \
    --alarm-description "Alarm when CPU exceeds 70 percent" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 60 \
    --threshold 70 \
    --comparison-operator GreaterThanThreshold \
    --dimensions "Name=InstanceId,Value=$instance_id" \
    --evaluation-periods 2 \
    --alarm-actions $sns_topic_arn \
    --unit Percent
