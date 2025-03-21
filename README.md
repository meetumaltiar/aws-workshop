# 🧠 AWS Hands-On Workshop (Java + AWS CLI)

Welcome to the AWS Workshop for engineering students! This repo includes Java code examples, AWS CLI commands, and automation scripts to help you learn AWS services by doing.

---

## 📦 Project Structure

```
aws-workshop/
├── pom.xml                          # Maven project config
├── README.md                        # You're reading it 😄
├── scripts/                         # CLI deployment & testing scripts
│   ├── deploy_lambda_api.sh
│   ├── test_lambda_api.sh
│   ├── dynamodb_script.sh
│   ├── sns_script.sh
│   └── sqs_script.sh
├── src/
│   ├── main/
│   │   ├── java/com/aws/workshop/
│   │   │   ├── s3/                  # S3 Java code
│   │   │   ├── ec2/                 # EC2 Java code
│   │   │   ├── lambda/              # Lambda Java code
│   │   │   ├── dynamodb/            # DynamoDB Java code
│   │   │   ├── sns/                 # SNS Java code
│   │   │   └── sqs/                 # SQS Java code
│   │   └── resources/awscli/        # AWS CLI commands
```

---

## ✅ Prerequisites
- Java 17
- Maven
- AWS CLI (configured via `aws configure`)
- AWS Free Tier account
- `jq` installed (for parsing JSON in scripts)

---

## 🚀 Build & Run Java Code
```bash
mvn clean package
```
To run a specific main class:
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.s3.S3Operations
```

---

## 🛠 Deploy Lambda + API Gateway
```bash
cd scripts/
chmod +x deploy_lambda_api.sh
./deploy_lambda_api.sh
```
This creates an IAM role, deploys the Lambda, sets up an API Gateway, and prints the test URL.

---

## 🌐 Test the API Gateway
Edit `test_lambda_api.sh` and add your generated API Gateway URL:
```bash
chmod +x test_lambda_api.sh
./test_lambda_api.sh
```

---

## 📊 DynamoDB CRUD (Java + CLI)
To test DynamoDB operations via CLI:
```bash
cd scripts/
chmod +x dynamodb_script.sh
./dynamodb_script.sh
```
This script creates a `Students` table and performs insert, fetch, and delete operations.

To run the Java version:
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.dynamodb.DynamoDBOperations
```

---

## 📣 SNS Notifications (Java + CLI)
To test SNS messaging via CLI:
```bash
cd scripts/
chmod +x sns_script.sh
./sns_script.sh
```
This script creates a topic, publishes a message, and subscribes an email (requires inbox confirmation).

To run the Java version:
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.sns.SNSOperations
```

---

## 📥 SQS Messaging (Java + CLI)
To test SQS messaging via CLI:
```bash
cd scripts/
chmod +x sqs_script.sh
./sqs_script.sh
```
This script creates a queue, sends a message, receives it, and deletes it. (Requires `jq` to be installed.)

To run the Java version:
```bash
java -cp target/aws-workshop-1.0-SNAPSHOT.jar com.aws.workshop.sqs.SQSOperations
```

---

## 📬 Feedback
Feel free to fork, star ⭐, and raise issues. This project is made to help students learn AWS from the ground up.

---

Happy learning! 🚀
