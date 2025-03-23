#!/bin/bash

set -e

REGION="ap-south-1"
AMI_ID="ami-0c768662cc797cd75" # ✅ Amazon Linux 2 for Mumbai
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-key"
SECURITY_GROUP_NAME="elb-demo-sg"
LOAD_BALANCER_NAME="my-loadbalancer"
TARGET_GROUP_NAME="my-targets"

echo "🔍 Fetching default VPC ID..."
VPC_ID=$(aws ec2 describe-vpcs --region $REGION --query "Vpcs[0].VpcId" --output text)

# 1️⃣ Check or Create Security Group
echo "🔐 Checking or creating security group '$SECURITY_GROUP_NAME'..."
SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SECURITY_GROUP_NAME Name=vpc-id,Values=$VPC_ID \
  --region $REGION \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

if [ "$SECURITY_GROUP_ID" == "None" ] || [ -z "$SECURITY_GROUP_ID" ]; then
  SECURITY_GROUP_ID=$(aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NAME \
    --description "Allow HTTP for ELB demo" \
    --vpc-id $VPC_ID \
    --region $REGION \
    --query "GroupId" \
    --output text)

  aws ec2 authorize-security-group-ingress \
    --group-id $SECURITY_GROUP_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

  echo "✅ Created security group: $SECURITY_GROUP_ID"
else
  echo "ℹ️ Reusing existing security group: $SECURITY_GROUP_ID"
fi

# 2️⃣ Launch EC2 Instances with Python HTTP Server
echo "🚀 Launching EC2 instances with web server..."
USER_DATA=$(base64 <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y python3
echo "<h1>Hello from \$(hostname)</h1>" > index.html
nohup python3 -m http.server 80 > /dev/null 2>&1 &
EOF
)

INSTANCE_IDS=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 2 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SECURITY_GROUP_ID \
  --user-data "$USER_DATA" \
  --region $REGION \
  --query "Instances[*].InstanceId" \
  --output text)

echo "🟢 EC2 Instances Launched: $INSTANCE_IDS"
aws ec2 wait instance-running --instance-ids $INSTANCE_IDS --region $REGION

# 3️⃣ Create Target Group
SUBNETS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $REGION \
  --query "Subnets[*].SubnetId" \
  --output text)

echo "🔧 Creating Target Group..."
TARGET_GROUP_ARN=$(aws elbv2 create-target-group \
  --name $TARGET_GROUP_NAME \
  --protocol HTTP \
  --port 80 \
  --vpc-id $VPC_ID \
  --target-type instance \
  --region $REGION \
  --query "TargetGroups[0].TargetGroupArn" \
  --output text)

aws elbv2 register-targets \
  --target-group-arn $TARGET_GROUP_ARN \
  --targets $(for id in $INSTANCE_IDS; do echo -n "Id=$id "; done) \
  --region $REGION

echo "✅ Instances registered with Target Group"

# 4️⃣ Create Load Balancer
echo "🔧 Creating Application Load Balancer..."
LOAD_BALANCER_ARN=$(aws elbv2 create-load-balancer \
  --name $LOAD_BALANCER_NAME \
  --subnets $SUBNETS \
  --security-groups $SECURITY_GROUP_ID \
  --scheme internet-facing \
  --type application \
  --ip-address-type ipv4 \
  --region $REGION \
  --query "LoadBalancers[0].LoadBalancerArn" \
  --output text)

aws elbv2 create-listener \
  --load-balancer-arn $LOAD_BALANCER_ARN \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN \
  --region $REGION > /dev/null

DNS_NAME=$(aws elbv2 describe-load-balancers \
  --load-balancer-arns $LOAD_BALANCER_ARN \
  --region $REGION \
  --query "LoadBalancers[0].DNSName" \
  --output text)

echo "🌐 Load Balancer DNS: http://$DNS_NAME"
echo "✅ Visit in browser and refresh to see alternating server responses!"
