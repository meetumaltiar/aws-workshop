#!/bin/bash

STACK_NAME="demo-stack"
REGION="ap-south-1"
KEY_NAME="your-key-name"  # Replace this with your actual EC2 Key Pair name

# 🚀 Launch the CloudFormation stack
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://resources/cloudformation/demo_stack.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION

echo "✅ Stack creation initiated: $STACK_NAME"
echo "⏳ Use 'aws cloudformation describe-stacks --stack-name $STACK_NAME' to check progress."
