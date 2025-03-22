#!/bin/bash

set -e

STACK_NAME="capstone-stack"
REGION="ap-south-1"
BUCKET_NAME="maltiar-capstone-bucket"
LAMBDA_JAR_KEY="lambda/aws-workshop-1.0-SNAPSHOT.jar"

echo "🧹 Cleaning up AWS Capstone Project..."

# 1. Delete CloudFormation stack
echo "📦 Deleting CloudFormation stack: $STACK_NAME"
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"

# 2. Wait for stack deletion to complete
echo "⏳ Waiting for stack to be deleted..."
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" --region "$REGION"
echo "✅ CloudFormation stack deleted."

# 3. Delete Lambda JAR from S3
echo "🗑️ Deleting Lambda JAR from S3..."
aws s3 rm "s3://$BUCKET_NAME/$LAMBDA_JAR_KEY" --region "$REGION"

# 4. Optionally delete bucket (if only used for this)
echo "🧺 Deleting S3 bucket..."
aws s3 rb "s3://$BUCKET_NAME" --force --region "$REGION"

# 5. Done
echo "🎉 Cleanup complete! All workshop resources removed."
