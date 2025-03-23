#!/bin/bash

REGION="ap-south-1"
FUNCTION_NAME="StudentSubmissionFunction"
API_NAME="StudentSubmissionAPI"
HANDLER="com.aws.workshop.capstone.StudentSubmissionHandler"
ROLE_NAME="lambda-basic-role"
JAR_FILE="target/aws-workshop-1.0-SNAPSHOT.jar"

TRUST_POLICY_PATH="src/main/resources/policy/lambda-trust-policy.json"
INLINE_POLICY_PATH="src/main/resources/policy/dynamodb-putitem-policy.json"

# 1️⃣ Create IAM Role if it doesn't exist
if ! aws iam get-role --role-name $ROLE_NAME --region $REGION &>/dev/null; then
  aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://$TRUST_POLICY_PATH \
    --region $REGION

  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole \
    --region $REGION

  aws iam put-role-policy \
    --role-name $ROLE_NAME \
    --policy-name DynamoDBPutItemPolicy \
    --policy-document file://$INLINE_POLICY_PATH \
    --region $REGION

  aws iam put-role-policy \
    --role-name $ROLE_NAME \
    --policy-name SNSPublishPolicy \
    --policy-document file://src/main/resources/policy/sns-publish-policy.json \
    --region $REGION

  echo "✅ Attached SNS Publish policy to '$ROLE_NAME'."

  echo "✅ IAM role '$ROLE_NAME' created and policies attached."
  sleep 10
else
  echo "ℹ️ IAM role '$ROLE_NAME' already exists."
fi

# 2️⃣ Create Lambda if not exists
if ! aws lambda get-function --function-name $FUNCTION_NAME --region $REGION &>/dev/null; then
  aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime java17 \
    --handler $HANDLER \
    --memory-size 512 \
    --timeout 10 \
    --zip-file fileb://$JAR_FILE \
    --role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/$ROLE_NAME \
    --region $REGION

  echo "✅ Lambda function '$FUNCTION_NAME' created."
else
  echo "ℹ️ Lambda function '$FUNCTION_NAME' already exists. Skipping creation."
fi

# 3️⃣ Create API Gateway
API_ID=$(aws apigateway create-rest-api \
  --name "$API_NAME" \
  --region $REGION \
  --query 'id' \
  --output text)

PARENT_ID=$(aws apigateway get-resources \
  --rest-api-id $API_ID \
  --region $REGION \
  --query 'items[0].id' \
  --output text)

# 4️⃣ Create Resource /submit
RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --parent-id $PARENT_ID \
  --path-part submit \
  --region $REGION \
  --query 'id' \
  --output text)

# 5️⃣ Create Method
aws apigateway put-method \
  --rest-api-id $API_ID \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --authorization-type NONE \
  --region $REGION

# 6️⃣ Lambda Integration
aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/arn:aws:lambda:$REGION:$(aws sts get-caller-identity --query Account --output text):function:$FUNCTION_NAME/invocations \
  --region $REGION

# 7️⃣ Add API Gateway permission to invoke Lambda (with unique statement ID)
UNIQUE_ID=$(date +%s)
aws lambda add-permission \
  --function-name $FUNCTION_NAME \
  --statement-id apigateway-access-$UNIQUE_ID \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn arn:aws:execute-api:$REGION:$(aws sts get-caller-identity --query Account --output text):$API_ID/*/POST/submit \
  --region $REGION

# 8️⃣ Deploy API Gateway
aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name prod \
  --region $REGION

echo "✅ Lambda + API Gateway deployed!"
echo "📬 POST endpoint: https://$API_ID.execute-api.$REGION.amazonaws.com/prod/submit"
