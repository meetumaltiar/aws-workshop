#!/bin/bash

set -e

STACK_NAME="demo-stack"
REGION="ap-south-1"
KEY_NAME="your-key-name"  # 🔁 Replace this with your actual EC2 Key Pair name
TEMPLATE_PATH="src/main/resources/cloudformation/demo_stack.yaml"

# 🚨 Check if key name is set
if [ "$KEY_NAME" = "your-key-name" ]; then
  echo "❌ Please replace 'your-key-name' with your actual EC2 Key Pair name."
  exit 1
fi

# 🚀 Launch the CloudFormation stack
echo "📦 Launching CloudFormation stack '$STACK_NAME' using template '$TEMPLATE_PATH'..."

aws cloudformation create-stack \
  --stack-name "$STACK_NAME" \
  --template-body "file://$TEMPLATE_PATH" \
  --parameters ParameterKey=KeyName,ParameterValue="$KEY_NAME" \
  --capabilities CAPABILITY_NAMED_IAM \
  --region "$REGION"

echo "✅ Stack creation initiated: $STACK_NAME"
echo "⏳ Track progress using:"
echo "   aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION"
