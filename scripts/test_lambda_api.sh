#!/bin/bash

# Replace with your real deployed API Gateway URL
API_URL="https://<your-api-id>.execute-api.ap-south-1.amazonaws.com/prod/hello"

curl -X POST $API_URL \
  -H "Content-Type: application/json" \
  -d '{"name": "John"}'

