#!/bin/bash

REGION="ap-south-1"
TABLE_NAME="StudentProjects"
TOPIC_NAME="project-submissions"

# 1️⃣ Create DynamoDB Table
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=email,AttributeType=S \
  --key-schema AttributeName=email,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $REGION

echo "✅ DynamoDB table '$TABLE_NAME' created."

# 2️⃣ Create SNS Topic
aws sns create-topic \
  --name $TOPIC_NAME \
  --region $REGION

echo "✅ SNS topic '$TOPIC_NAME' created."

# 3️⃣ Subscribe email (requires confirmation)
read -p "Enter your admin email to receive notifications: " EMAIL

aws sns subscribe \
  --topic-arn arn:aws:sns:$REGION:$(aws sts get-caller-identity --query Account --output text):$TOPIC_NAME \
  --protocol email \
  --notification-endpoint "$EMAIL" \
  --region $REGION

echo "📬 Confirmation email sent to $EMAIL. Please check and confirm subscription."
