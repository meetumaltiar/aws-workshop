#!/bin/bash

REGION="ap-south-1"
NAMESPACE="AWSWorkshop"
METRIC_NAME="WorkshopMetric"

# ⏱️ Timestamp (UTC)
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# 📊 Publish custom metric
aws cloudwatch put-metric-data \
  --namespace "$NAMESPACE" \
  --metric-name "$METRIC_NAME" \
  --value 1 \
  --unit Count \
  --timestamp "$TIMESTAMP" \
  --region "$REGION"

if [ $? -eq 0 ]; then
  echo "✅ Metric '$METRIC_NAME' published to namespace '$NAMESPACE' at $TIMESTAMP."
else
  echo "❌ Failed to publish metric. Check AWS CLI config and permissions."
fi
