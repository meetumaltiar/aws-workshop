#!/bin/bash

# Exit if any command fails
set -e

# Replace this with your actual API Gateway URL
API_URL="https://6g7709veae.execute-api.ap-south-1.amazonaws.com/prod/hello"

# Check if the placeholder is still present
if [[ "$API_URL" == *"<your-api-id>"* ]]; then
  echo "❌ Please replace <your-api-id> in the API_URL before running this script."
  exit 1
fi

echo "📡 Sending test POST request to Lambda API..."
RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d '{"name": "John"}')

echo "✅ Response from Lambda:"
echo "$RESPONSE"
