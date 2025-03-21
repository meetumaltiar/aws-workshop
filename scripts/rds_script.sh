#!/bin/bash

REGION="ap-south-1"
DB_INSTANCE_ID="workshopdb"
DB_NAME="students"
USERNAME="admin"
PASSWORD="Admin12345"  # Note: Change for production use

# NOTE: Replace with the actual security group ID that allows port 3306 from EC2
SECURITY_GROUP_ID="sg-xxxxxxxxxxxxxxxxx"

# 1️⃣ Create RDS MySQL instance (Free Tier eligible)
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
  --vpc-security-group-ids $SECURITY_GROUP_ID \
  --region $REGION

echo "✅ RDS instance '$DB_INSTANCE_ID' creation initiated in region $REGION."
echo "⏳ Use 'aws rds describe-db-instances' to check endpoint once available."
echo "📝 Remember to allow port 3306 access in the Security Group from EC2."
