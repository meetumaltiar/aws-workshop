#!/bin/bash

REGION="ap-south-1"
TABLE_NAME="Students"

# 1️⃣ Create Table
aws dynamodb create-table \
  --table-name $TABLE_NAME \
  --attribute-definitions AttributeName=studentId,AttributeType=S \
  --key-schema AttributeName=studentId,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region $REGION || true

# 2️⃣ Insert Item
aws dynamodb put-item \
  --table-name $TABLE_NAME \
  --item '{"studentId": {"S": "101"}, "name": {"S": "Meetu"}, "email": {"S": "meetu@example.com"}}' \
  --region $REGION

# 3️⃣ Get Item
aws dynamodb get-item \
  --table-name $TABLE_NAME \
  --key '{"studentId": {"S": "101"}}' \
  --region $REGION

# 4️⃣ Delete Item
aws dynamodb delete-item \
  --table-name $TABLE_NAME \
  --key '{"studentId": {"S": "101"}}' \
  --region $REGION
