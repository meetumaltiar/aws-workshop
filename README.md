# 🧠 AWS Hands-On Workshop (Java + AWS CLI)

Welcome to the **AWS Hands-On Workshop** designed for engineering students. This repo includes Java examples, AWS CLI scripts, CloudFormation templates, and deployment helpers to help you learn AWS by doing.

---

## ✨ What You’ll Learn
- Launch and manage **EC2** instances
- Upload/download files using **S3**
- Trigger **Lambda** functions via **API Gateway**
- Store and query data with **DynamoDB**
- Send notifications using **SNS**
- Queue messages with **SQS**
- Monitor metrics with **CloudWatch**
- Manage access using **IAM**
- Set up and connect to **RDS (MySQL)** using EC2
- Deploy simple infrastructure using **CloudFormation**

---

## ✅ Before You Begin
Make sure you have the following ready:
- [ ] Java 17 installed
- [ ] Maven installed
- [ ] AWS CLI configured (`aws configure`)
- [ ] AWS Free Tier account
- [ ] `jq` installed for CLI JSON parsing

---

## 📦 Project Structure
```
aws-workshop/
├── pom.xml                        # Maven build config
├── README.md                      # This guide 😄
├── scripts/                       # CLI automation scripts
│   ├── deploy_lambda_api.sh
│   ├── test_lambda_api.sh
│   ├── dynamodb_script.sh
│   ├── sns_script.sh
│   ├── sqs_script.sh
│   ├── cloudwatch_script.sh
│   └── rds_script.sh
├── src/main/java/com/aws/workshop/
│   ├── s3/                        # S3 Java code
│   ├── ec2/                       # EC2 Java code
│   ├── lambda/                    # Lambda Java code
│   ├── dynamodb/                  # DynamoDB Java code
│   ├── sns/                       # SNS Java code
│   ├── sqs/                       # SQS Java code
│   ├── iam/                       # IAM Java code
│   └── cloudwatch/               # CloudWatch Java code
├── resources/
│   ├── awscli/                    # CLI command files
│   └── cloudformation/
│       └── demo_stack.yaml       # Basic EC2 + S3 CloudFormation template
```

---

## 🚀 Build & Run Java Code
```bash
mvn clean package
```
Run any Java main class:
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.<service>.<ClassName>
```
_Replace `<service>` and `<ClassName>` accordingly._

---

## 🛠 Lambda + API Gateway
```bash
cd scripts/
chmod +x deploy_lambda_api.sh
./deploy_lambda_api.sh
```
Then test it:
```bash
chmod +x test_lambda_api.sh
./test_lambda_api.sh
```

---

## 📊 DynamoDB (Java + CLI)
```bash
chmod +x scripts/dynamodb_script.sh
./scripts/dynamodb_script.sh

java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.dynamodb.DynamoDBOperations
```

---

## 📣 SNS (Java + CLI)
```bash
chmod +x scripts/sns_script.sh
./scripts/sns_script.sh

java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.sns.SNSOperations
```

---

## 📥 SQS (Java + CLI)
```bash
chmod +x scripts/sqs_script.sh
./scripts/sqs_script.sh

java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.sqs.SQSOperations
```

---

## 🔐 IAM (Java Only)
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.iam.IAMOperations
```
📌 IAM operations are Java-only (AWS CLI available but not demoed here).

---

## 📊 CloudWatch Metrics (Java + CLI)
```bash
chmod +x scripts/cloudwatch_script.sh
./scripts/cloudwatch_script.sh

java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.cloudwatch.CloudWatchOperations
```
📈 View metrics in CloudWatch Console under **AWSWorkshop** namespace.

---

## 🗄️ RDS MySQL (CLI + EC2 Connection)
```bash
chmod +x scripts/rds_script.sh
./scripts/rds_script.sh
```

To connect from EC2:
```bash
# SSH into EC2 instance
ssh -i your-key.pem ec2-user@<ec2-ip>

# Install MySQL client
sudo yum install mysql -y  # For Amazon Linux

# Connect to RDS endpoint
mysql -h <rds-endpoint> -u admin -p
```
✅ Make sure RDS security group allows port 3306 from EC2.

---

## 🧱 CloudFormation Demo Template
We provide a basic CloudFormation template to create:
- An S3 bucket
- An EC2 instance
- A security group allowing SSH

To launch the stack:
```bash
aws cloudformation create-stack \
  --stack-name demo-stack \
  --template-body file://resources/cloudformation/demo_stack.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=your-key-name \
  --capabilities CAPABILITY_NAMED_IAM
```
To delete the stack:
```bash
aws cloudformation delete-stack --stack-name demo-stack
```
✅ Replace `your-key-name` with your actual EC2 key pair.

---

## 🧪 Mini Practice Assignments
- Create a new EC2 instance with a different AMI.
- Upload a file to a new folder in S3 and read it back.
- Extend Lambda to accept query parameters.
- Create multiple messages in SQS and process all.
- Trigger a CloudWatch alarm when a custom metric exceeds a value.
- Modify the CloudFormation template to add a second EC2 instance.

---

## 🙌 Feedback
Fork ⭐ this repo, file issues, or reach out with improvements!

---

Happy learning and building on AWS! 🚀
