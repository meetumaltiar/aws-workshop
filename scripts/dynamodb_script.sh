#!/bin/bash

REGION="ap-south-1"
TABLE_NAME="Students"

echo "🔧 Creating DynamoDB table '$TABLE_NAME'..."
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=studentId,AttributeType=S \
  --key-schema AttributeName=studentId,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $REGION || true

echo "⏳ Waiting for table '$TABLE_NAME' to become ACTIVE..."
aws dynamodb wait table-exists \
  --table-name $TABLE_NAME \
  --region $REGION
echo "✅ Table '$TABLE_NAME' is now ACTIVE."

echo "📥 Inserting item into '$TABLE_NAME'..."
aws dynamodb put-item \
  --table-name $TABLE_NAME \
  --item '{"studentId": {"S": "101"}, "name": {"S": "Meetu"}, "email": {"S": "meetu@example.com"}}' \
  --region $REGION

echo "🔍 Retrieving item..."
aws dynamodb get-item \
  --table-name $TABLE_NAME \
  --key '{"studentId": {"S": "101"}}' \
  --region $REGION

echo "🗑️ Deleting item..."
aws dynamodb delete-item \
  --table-name $TABLE_NAME \
  --key '{"studentId": {"S": "101"}}' \
  --region $REGION
