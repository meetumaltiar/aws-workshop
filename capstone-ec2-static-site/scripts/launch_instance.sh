#!/bin/bash

set -e

REGION="ap-south-1"
KEY_NAME="ec2-site-key"
SECURITY_GROUP_NAME="ec2-static-sg"
INSTANCE_NAME="EC2StaticWebsite"
USER="ec2-user"
HTML_DIR="../website"
AMI_ID="ami-0c768662cc797cd75"  # Amazon Linux 2 (Mumbai)
INSTANCE_TYPE="t2.micro"
KEY_FILE="${KEY_NAME}.pem"

echo "🔑 Creating/reusing key pair..."

if [ ! -f "$KEY_FILE" ]; then
  aws ec2 delete-key-pair --key-name "$KEY_NAME" --region "$REGION" || true
  aws ec2 create-key-pair \
    --key-name "$KEY_NAME" \
    --query 'KeyMaterial' \
    --output text \
    --region "$REGION" > "$KEY_FILE"
  chmod 400 "$KEY_FILE"
  echo "✅ Key pair created and saved: $KEY_FILE"
else
  echo "ℹ️ Key pair already exists locally: $KEY_FILE"
fi

echo "🔐 Creating/reusing security group..."

SG_ID=$(aws ec2 describe-security-groups \
  --region "$REGION" \
  --filters Name=group-name,Values="$SECURITY_GROUP_NAME" \
  --query 'SecurityGroups[0].GroupId' \
  --output text 2>/dev/null)

if [ "$SG_ID" == "None" ]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "Security group for static site" \
    --region "$REGION" \
    --query 'GroupId' \
    --output text)

  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region "$REGION"

  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region "$REGION"

  echo "✅ Created security group: $SG_ID"
else
  echo "ℹ️ Using existing security group: $SG_ID"
fi

echo "🚀 Launching EC2 instance..."

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Purpose,Value=StaticWebsite}]" \
  --region "$REGION" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "⏳ Waiting for instance to be in running state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID" --region "$REGION"

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "🌐 EC2 instance is ready: http://$PUBLIC_IP"
echo "⏳ Waiting 60 seconds for SSH to be ready..."
sleep 60

echo "📁 Uploading static website and installing Apache..."
scp -i "$KEY_FILE" -o StrictHostKeyChecking=no -r "$HTML_DIR"/* "$USER@$PUBLIC_IP:/home/ec2-user/"
ssh -i "$KEY_FILE" -o StrictHostKeyChecking=no "$USER@$PUBLIC_IP" << EOF
  sudo yum update -y
  sudo yum install -y httpd
  sudo mv ~/index.html /var/www/html/
  sudo systemctl start httpd
  sudo systemctl enable httpd
EOF

echo "✅ Website deployed! Visit: http://$PUBLIC_IP"
