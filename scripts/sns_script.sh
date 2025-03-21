#!/bin/bash

REGION="ap-south-1"
TOPIC_NAME="MyJavaTopic"
EMAIL="your@email.com" # <-- Change this to a valid email

# 1️⃣ Create SNS Topic
TOPIC_ARN=$(aws sns create-topic \
  --name $TOPIC_NAME \
  --region $REGION \
  --query "TopicArn" --output text)

echo "✅ Created Topic ARN: $TOPIC_ARN"

# 2️⃣ Publish Message
aws sns publish \
  --topic-arn $TOPIC_ARN \
  --message "Hello from AWS CLI SNS Script!" \
  --region $REGION

echo "📨 Message published."

# 3️⃣ Subscribe Email (User must confirm via inbox)
aws sns subscribe \
  --topic-arn $TOPIC_ARN \
  --protocol email \
  --notification-endpoint $EMAIL \
  --region $REGION

echo "📧 Subscription sent to: $EMAIL (Check your inbox to confirm!)"

# 4️⃣ List Topics
aws sns list-topics --region $REGION