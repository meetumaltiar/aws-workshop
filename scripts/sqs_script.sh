#!/bin/bash

REGION="ap-south-1"
QUEUE_NAME="MyJavaQueue"

# 1️⃣ Create Queue
QUEUE_URL=$(aws sqs create-queue \
  --queue-name $QUEUE_NAME \
  --region $REGION \
  --query "QueueUrl" --output text)

echo "✅ Queue created: $QUEUE_URL"

# 2️⃣ Send Message
aws sqs send-message \
  --queue-url $QUEUE_URL \
  --message-body "Hello from SQS CLI script!" \
  --region $REGION

echo "📤 Message sent."

# 3️⃣ Receive Message
RESPONSE=$(aws sqs receive-message \
  --queue-url $QUEUE_URL \
  --region $REGION)

MESSAGE=$(echo "$RESPONSE" | jq -r '.Messages[0].Body')
RECEIPT_HANDLE=$(echo "$RESPONSE" | jq -r '.Messages[0].ReceiptHandle')

echo "📥 Received: $MESSAGE"

# 4️⃣ Delete Message
aws sqs delete-message \
  --queue-url $QUEUE_URL \
  --receipt-handle "$RECEIPT_HANDLE" \
  --region $REGION

echo "🗑️ Message deleted."
