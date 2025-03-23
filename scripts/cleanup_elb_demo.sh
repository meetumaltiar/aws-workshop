#!/bin/bash

REGION="ap-south-1"
SECURITY_GROUP_NAME="elb-demo-sg"
TARGET_GROUP_NAME="my-targets"
LOAD_BALANCER_NAME="my-loadbalancer"

echo "🔍 Fetching EC2 instance IDs..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=ELB-Demo-Instance" \
  --region $REGION \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "⚠️ No EC2 instances found for cleanup."
else
  echo "🛑 Terminating EC2 Instances: $INSTANCE_IDS"
  aws ec2 terminate-instances \
    --instance-ids $INSTANCE_IDS \
    --region $REGION
fi

echo "⏳ Waiting for EC2 termination..."
aws ec2 wait instance-terminated \
  --instance-ids $INSTANCE_IDS \
  --region $REGION

echo "🧹 Fetching Load Balancer ARN..."
LB_ARN=$(aws elbv2 describe-load-balancers \
  --names $LOAD_BALANCER_NAME \
  --region $REGION \
  --query "LoadBalancers[0].LoadBalancerArn" \
  --output text 2>/dev/null)

if [ "$LB_ARN" != "None" ]; then
  echo "🔻 Deleting Load Balancer..."
  aws elbv2 delete-load-balancer \
    --load-balancer-arn $LB_ARN \
    --region $REGION
  echo "⏳ Waiting for Load Balancer to delete..."
  sleep 60
else
  echo "⚠️ Load Balancer not found."
fi

echo "🧹 Fetching Target Group ARN..."
TG_ARN=$(aws elbv2 describe-target-groups \
  --names $TARGET_GROUP_NAME \
  --region $REGION \
  --query "TargetGroups[0].TargetGroupArn" \
  --output text 2>/dev/null)

if [ "$TG_ARN" != "None" ]; then
  echo "🧨 Deleting Target Group..."
  aws elbv2 delete-target-group \
    --target-group-arn $TG_ARN \
    --region $REGION
else
  echo "⚠️ Target Group not found."
fi

echo "🧹 Deleting Security Group..."
SEC_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SECURITY_GROUP_NAME \
  --region $REGION \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

if [ "$SEC_GROUP_ID" != "None" ]; then
  aws ec2 delete-security-group \
    --group-id $SEC_GROUP_ID \
    --region $REGION
  echo "✅ Security Group '$SECURITY_GROUP_NAME' deleted."
else
  echo "⚠️ Security Group not found."
fi

echo "✅ ELB Demo cleanup complete."
