#!/bin/bash

set -e  # Exit on error

REGION="ap-south-1"
DB_INSTANCE_ID="workshopdb"
DB_NAME="students"
USERNAME="admin"
PASSWORD="Admin12345"  # 🚨 For demo only – change in prod
SECURITY_GROUP_NAME="rds-access-sg"

echo "🔍 Retrieving VPC ID..."
VPC_ID=$(aws ec2 describe-vpcs --region $REGION --query "Vpcs[0].VpcId" --output text)

echo "🔐 Checking or creating Security Group '$SECURITY_GROUP_NAME'..."
SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SECURITY_GROUP_NAME \
  --region $REGION \
  --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)

if [[ "$SG_ID" == "None" ]]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NAME \
    --description "Allow MySQL access from anywhere (demo only)" \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query "GroupId" --output text)

  aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0 \
    --region $REGION

  echo "✅ Security Group '$SECURITY_GROUP_NAME' created and configured: $SG_ID"
else
  echo "ℹ️ Security Group already exists: $SG_ID"
fi

echo "🚀 Launching RDS MySQL instance..."
aws rds create-db-instance \
  --db-instance-identifier $DB_INSTANCE_ID \
  --db-name $DB_NAME \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username $USERNAME \
  --master-user-password $PASSWORD \
  --allocated-storage 20 \
  --no-publicly-accessible \
  --backup-retention-period 0 \
  --vpc-security-group-ids $SG_ID \
  --region $REGION

echo "⏳ Waiting for RDS instance '$DB_INSTANCE_ID' to become available..."
aws rds wait db-instance-available \
  --db-instance-identifier $DB_INSTANCE_ID \
  --region $REGION

ENDPOINT=$(aws rds describe-db-instances \
  --db-instance-identifier $DB_INSTANCE_ID \
  --region $REGION \
  --query "DBInstances[0].Endpoint.Address" \
  --output text)

echo "✅ RDS is now live!"
echo "🔗 Endpoint: $ENDPOINT"
echo "📝 Username: $USERNAME"
echo "🗄️  Database: $DB_NAME"
