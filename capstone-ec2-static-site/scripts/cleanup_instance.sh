#!/bin/bash

set -e

KEY_NAME="ec2-static-key"
SECURITY_GROUP_NAME="ec2-static-sg"
REGION="ap-south-1"

# Get the instance ID based on tag (optional: modify if needed)
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Purpose,Values=StaticWebsite" \
    --region "$REGION" \
    --query "Reservations[*].Instances[*].InstanceId" \
    --output text)

if [ -z "$INSTANCE_ID" ]; then
  echo "❌ No instance found with tag Purpose=StaticWebsite. Exiting."
  exit 1
fi

echo "🛑 Terminating EC2 instance: $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" --region "$REGION"

# Wait for instance to be fully terminated
echo "⏳ Waiting for EC2 instance to be fully terminated..."
while true; do
  STATUS=$(aws ec2 describe-instances \
      --instance-ids "$INSTANCE_ID" \
      --region "$REGION" \
      --query "Reservations[*].Instances[*].State.Name" \
      --output text 2>/dev/null || echo "terminated")

  if [ "$STATUS" == "terminated" ]; then
    break
  fi

  sleep 5
done

echo "✅ Instance terminated. Proceeding to clean up key pair and security group..."

# Delete key pair
aws ec2 delete-key-pair --key-name "$KEY_NAME" --region "$REGION" || echo "⚠️ Key pair already deleted or not found."

# Get security group ID
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --filters Name=group-name,Values="$SECURITY_GROUP_NAME" \
    --region "$REGION" \
    --query "SecurityGroups[*].GroupId" \
    --output text)

if [ -n "$SECURITY_GROUP_ID" ]; then
  # Delete security group
  aws ec2 delete-security-group --group-id "$SECURITY_GROUP_ID" --region "$REGION" \
    && echo "🧹 Security group deleted." \
    || echo "⚠️ Failed to delete security group (might still be attached to resources)."
else
  echo "ℹ️ Security group not found. Skipping deletion."
fi

echo "✅ Cleanup completed. EC2 environment is removed."
