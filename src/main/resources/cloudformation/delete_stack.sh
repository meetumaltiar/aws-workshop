#!/bin/bash

STACK_NAME="demo-stack"
REGION="ap-south-1"

# 🧹 Delete the CloudFormation stack
aws cloudformation delete-stack \
  --stack-name $STACK_NAME \
  --region $REGION

echo "🧼 Deletion initiated for stack: $STACK_NAME"
echo "⏳ Use 'aws cloudformation describe-stacks --stack-name $STACK_NAME' to check deletion progress."
