#!/bin/bash

set -e

REGION="ap-south-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ROLE_NAME="lambda-execution-role"
FUNCTION_NAME="HelloLambda"
JAR_FILE="target/aws-workshop-1.0-SNAPSHOT.jar"
HANDLER="com.aws.workshop.lambda.LambdaHandler"

# IAM Trust Policy
cat > trust-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF

# Create IAM role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust-policy.json || true
aws iam attach-role-policy --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

sleep 10  # Let the role propagate
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query "Role.Arn" --output text)

# Deploy Lambda
aws lambda create-function \
  --function-name $FUNCTION_NAME \
  --runtime java17 \
  --role $ROLE_ARN \
  --handler $HANDLER \
  --zip-file fileb://$JAR_FILE \
  --region $REGION || true

# Setup API Gateway
API_ID=$(aws apigateway create-rest-api --name "LambdaAPI" --region $REGION --query "id" --output text)
ROOT_ID=$(aws apigateway get-resources --rest-api-id $API_ID --region $REGION --query "items[0].id" --output text)

RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --region $REGION \
  --parent-id $ROOT_ID \
  --path-part hello \
  --query "id" --output text)

aws apigateway put-method \
  --rest-api-id $API_ID \
  --region $REGION \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --authorization-type NONE

aws apigateway put-integration \
  --rest-api-id $API_ID \
  --region $REGION \
  --resource-id $RESOURCE_ID \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:$REGION:lambda:path/2015-03-31/functions/arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$FUNCTION_NAME/invocations

aws lambda add-permission \
  --function-name $FUNCTION_NAME \
  --statement-id apigateway-access \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn arn:aws:execute-api:$REGION:$ACCOUNT_ID:$API_ID/*/POST/hello \
  --region $REGION || true

aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name prod \
  --region $REGION

echo "✅ API Gateway URL: https://$API_ID.execute-api.$REGION.amazonaws.com/prod/hello"

