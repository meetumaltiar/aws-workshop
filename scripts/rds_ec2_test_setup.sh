#!/bin/bash

set -e

REGION="ap-south-1"
KEY_NAME="my-key"
KEY_FILE="my-key.pem"
SEC_GROUP_NAME="ec2-rds-access"
INSTANCE_NAME="RDS-Test-Instance"
AMI_ID="ami-0f58b397bc5c1f2e8"  # Amazon Linux 2 (ap-south-1)
INSTANCE_TYPE="t2.micro"
RDS_INSTANCE_ID="workshopdb"

# 1️⃣ Create Key Pair (if not exists)
if [ ! -f "$KEY_FILE" ]; then
  echo "🔑 Creating EC2 key pair '$KEY_NAME'..."
  aws ec2 create-key-pair \
    --key-name $KEY_NAME \
    --query 'KeyMaterial' \
    --output text \
    --region $REGION > $KEY_FILE
  chmod 400 $KEY_FILE
else
  echo "ℹ️ Key pair '$KEY_FILE' already exists."
fi

# 2️⃣ Create Security Group
SEC_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SEC_GROUP_NAME \
  --region $REGION \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

if [ "$SEC_GROUP_ID" == "None" ]; then
  echo "🔐 Creating Security Group '$SEC_GROUP_NAME'..."
  SEC_GROUP_ID=$(aws ec2 create-security-group \
    --group-name $SEC_GROUP_NAME \
    --description "Allow SSH and MySQL access" \
    --region $REGION \
    --query 'GroupId' \
    --output text)

  aws ec2 authorize-security-group-ingress \
    --group-id $SEC_GROUP_ID \
    --protocol tcp --port 22 --cidr 0.0.0.0/0 \
    --region $REGION

  aws ec2 authorize-security-group-ingress \
    --group-id $SEC_GROUP_ID \
    --protocol tcp --port 3306 --cidr 0.0.0.0/0 \
    --region $REGION

  echo "✅ Security group created: $SEC_GROUP_ID"
else
  echo "ℹ️ Security group already exists: $SEC_GROUP_ID"
fi

# 3️⃣ Launch EC2 Instance
echo "🚀 Launching EC2 instance '$INSTANCE_NAME'..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SEC_GROUP_ID \
  --region $REGION \
  --query "Instances[0].InstanceId" \
  --output text)

# 4️⃣ Tag it
aws ec2 create-tags \
  --resources $INSTANCE_ID \
  --tags Key=Name,Value=$INSTANCE_NAME \
  --region $REGION

echo "⏳ Waiting for EC2 to be running..."
aws ec2 wait instance-running \
  --instance-ids $INSTANCE_ID \
  --region $REGION

# 5️⃣ Fetch Public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --region $REGION \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "🌐 EC2 Public IP: $PUBLIC_IP"

# 6️⃣ Detect SSH user (Amazon Linux vs Ubuntu)
echo "🔎 Detecting EC2 SSH username..."
AMI_NAME=$(aws ec2 describe-images \
  --image-ids $AMI_ID \
  --region $REGION \
  --query "Images[0].Name" \
  --output text)

if [[ "$AMI_NAME" == *"ubuntu"* ]]; then
  SSH_USER="ubuntu"
else
  SSH_USER="ec2-user"
fi

echo "👤 Detected user: $SSH_USER"

# 7️⃣ Install MySQL client (via SSH)
echo "📦 Installing MySQL client on EC2..."
ssh -o StrictHostKeyChecking=no -i $KEY_FILE $SSH_USER@$PUBLIC_IP <<EOF
  if command -v yum &> /dev/null; then
    sudo yum update -y && sudo yum install -y mysql
  elif command -v apt &> /dev/null; then
    sudo apt update && sudo apt install -y mysql-client
  else
    echo "❌ Unsupported package manager"
    exit 1
  fi
EOF

# 8️⃣ Get RDS Endpoint
echo "🔍 Fetching RDS endpoint for '$RDS_INSTANCE_ID'..."
RDS_ENDPOINT=$(aws rds describe-db-instances \
  --db-instance-identifier $RDS_INSTANCE_ID \
  --region $REGION \
  --query "DBInstances[0].Endpoint.Address" \
  --output text)

echo "✅ RDS Endpoint: $RDS_ENDPOINT"

# 9️⃣ Final message
echo "🎯 Done. To connect from EC2, run:"
echo ""
echo "ssh -i $KEY_FILE $SSH_USER@$PUBLIC_IP"
echo "mysql -h $RDS_ENDPOINT -u admin -p"
