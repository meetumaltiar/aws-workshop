#!/bin/bash

REGION="ap-south-1"
TOPIC_NAME="MyJavaTopic"

# Prompt for email input
read -p "📧 Enter your email to subscribe to SNS Topic: " EMAIL

# 1️⃣ Create SNS Topic
echo "🔧 Creating SNS topic '$TOPIC_NAME'..."
TOPIC_ARN=$(aws sns create-topic \
  --name $TOPIC_NAME \
  --region $REGION \
  --query "TopicArn" --output text)

echo "✅ Topic created: $TOPIC_ARN"

# 2️⃣ Publish initial message
echo "📨 Publishing welcome message to SNS..."
aws sns publish \
  --topic-arn $TOPIC_ARN \
  --message "Hello from AWS CLI SNS Script!" \
  --region $REGION

echo "✅ Message published to $TOPIC_NAME."

# 3️⃣ Subscribe email
echo "🔔 Subscribing email: $EMAIL"
aws sns subscribe \
  --topic-arn $TOPIC_ARN \
  --protocol email \
  --notification-endpoint "$EMAIL" \
  --region $REGION

echo "📬 Confirmation email sent to $EMAIL. Please confirm from your inbox."

# 4️⃣ List all topics
echo "📋 Listing all topics:"
aws sns list-topics --region $REGION