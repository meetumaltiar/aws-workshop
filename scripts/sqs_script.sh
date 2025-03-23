#!/bin/bash

set -e  # Exit on error

REGION="ap-south-1"
QUEUE_NAME="MyJavaQueue"

echo "📦 Creating SQS queue '$QUEUE_NAME'..."
QUEUE_URL=$(aws sqs create-queue \
  --queue-name $QUEUE_NAME \
  --region $REGION \
  --query "QueueUrl" --output text)

echo "✅ Queue created: $QUEUE_URL"

echo "📤 Sending message to SQS..."
aws sqs send-message \
  --queue-url $QUEUE_URL \
  --message-body "Hello from SQS CLI script!" \
  --region $REGION

echo "📥 Receiving message from queue..."
RESPONSE=$(aws sqs receive-message \
  --queue-url $QUEUE_URL \
  --region $REGION)

MESSAGE=$(echo "$RESPONSE" | jq -r '.Messages[0].Body // empty')
RECEIPT_HANDLE=$(echo "$RESPONSE" | jq -r '.Messages[0].ReceiptHandle // empty')

if [[ -z "$MESSAGE" || -z "$RECEIPT_HANDLE" ]]; then
  echo "⚠️ No messages received. Queue might be empty."
else
  echo "✅ Received message: $MESSAGE"

  echo "🗑️ Deleting message..."
  aws sqs delete-message \
    --queue-url $QUEUE_URL \
    --receipt-handle "$RECEIPT_HANDLE" \
    --region $REGION

  echo "🧹 Message deleted."
fi