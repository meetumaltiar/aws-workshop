#!/bin/bash

REGION="ap-south-1"

# 1️⃣ Publish a custom metric to CloudWatch
aws cloudwatch put-metric-data \
  --namespace "AWSWorkshop" \
  --metric-name "WorkshopMetric" \
  --value 1 \
  --unit Count \
  --region $REGION

echo "✅ Custom metric 'WorkshopMetric' published to namespace 'AWSWorkshop'."
