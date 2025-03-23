#!/bin/bash

set -e

REGION="ap-south-1"
RDS_INSTANCE_ID="workshopdb"
EC2_INSTANCE_NAME="RDS-Test-Instance"
KEY_NAME="my-key"
KEY_FILE="my-key.pem"
SG_RDS="rds-access-sg"
SG_EC2="ec2-rds-access"

echo "⚠️ Starting cleanup of RDS + EC2 setup..."

# 1️⃣ Terminate EC2 instance by Name tag
echo "🔍 Finding EC2 instance tagged '$EC2_INSTANCE_NAME'..."
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$EC2_INSTANCE_NAME" \
  --region $REGION \
  --query "Reservations[].Instances[?State.Name != 'terminated'].InstanceId" \
  --output text)

if [ -n "$INSTANCE_ID" ]; then
  echo "🛑 Terminating EC2 instance: $INSTANCE_ID"
  aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION
  aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID --region $REGION
  echo "✅ EC2 instance terminated."
else
  echo "ℹ️ No active EC2 instance found."
fi

# 2️⃣ Delete RDS Instance
echo "🗑️ Deleting RDS instance: $RDS_INSTANCE_ID"
aws rds delete-db-instance \
  --db-instance-identifier $RDS_INSTANCE_ID \
  --skip-final-snapshot \
  --region $REGION

aws rds wait db-instance-deleted \
  --db-instance-identifier $RDS_INSTANCE_ID \
  --region $REGION
echo "✅ RDS instance deleted."

# 3️⃣ Delete security groups
for SG_NAME in $SG_RDS $SG_EC2; do
  SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SG_NAME" \
    --region $REGION \
    --query "SecurityGroups[0].GroupId" \
    --output text 2>/dev/null)

  if [ "$SG_ID" != "None" ]; then
    echo "🗑️ Deleting security group: $SG_NAME ($SG_ID)"
    aws ec2 delete-security-group --group-id $SG_ID --region $REGION
  else
    echo "ℹ️ Security group '$SG_NAME' not found."
  fi
done

# 4️⃣ Delete key pair
echo "🗑️ Deleting key pair: $KEY_NAME"
aws ec2 delete-key-pair --key-name $KEY_NAME --region $REGION

# 5️⃣ Delete local PEM file
if [ -f "$KEY_FILE" ]; then
  echo "🧹 Deleting local key file: $KEY_FILE"
  rm -f $KEY_FILE
fi

echo "✅ Cleanup complete. All RDS + EC2 test resources deleted."
