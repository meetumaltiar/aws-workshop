#!/bin/bash

REGION="ap-south-1"
FUNCTION_NAME="StudentSubmissionFunction"
API_NAME="StudentSubmissionAPI"
ROLE_NAME="lambda-basic-role"
INLINE_POLICY_NAME="DynamoDBPutItemPolicy"

# 1️⃣ Delete Lambda Function
echo "🛑 Deleting Lambda function..."
aws lambda delete-function \
  --function-name $FUNCTION_NAME \
  --region $REGION || echo "⚠️ Lambda function may not exist."

# 2️⃣ Delete API Gateway
echo "🧼 Finding and deleting REST API '$API_NAME'..."
API_ID=$(aws apigateway get-rest-apis \
  --region $REGION \
  --query "items[?name=='$API_NAME'].id" \
  --output text)

if [ -n "$API_ID" ]; then
  aws apigateway delete-rest-api \
    --rest-api-id $API_ID \
    --region $REGION
  echo "✅ API Gateway '$API_NAME' deleted."
else
  echo "⚠️ API Gateway '$API_NAME' not found."
fi

# 3️⃣ Detach Inline Policy from Role
echo "🧹 Detaching inline policy from IAM role..."
aws iam delete-role-policy \
  --role-name $ROLE_NAME \
  --policy-name $INLINE_POLICY_NAME \
  --region $REGION || echo "⚠️ Inline policy may not exist."

# 4️⃣ Detach Managed Policy
echo "🔓 Detaching AWSLambdaBasicExecutionRole..."
aws iam detach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole \
  --region $REGION || echo "⚠️ Managed policy may already be detached."

# 5️⃣ Delete IAM Role
echo "🗑 Deleting IAM role '$ROLE_NAME'..."
aws iam delete-role \
  --role-name $ROLE_NAME \
  --region $REGION || echo "⚠️ Role may be in use or already deleted."

echo "✅ Capstone Lambda cleanup completed!"
