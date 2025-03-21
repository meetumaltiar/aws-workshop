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
- Deploy infrastructure using **CloudFormation**
- Build and deploy a full-stack **Capstone Project**

---

## 🧠 Capstone Project: Student Submission Portal
This project uses API Gateway + Lambda + DynamoDB + SNS.

### 🔧 Setup (Run Once)
```bash
chmod +x scripts/capstone_deploy.sh
./scripts/capstone_deploy.sh
```
This will:
- Create `StudentProjects` table in DynamoDB
- Create an SNS topic `project-submissions`
- Prompt you to enter an email for SNS notifications

### 🖥️ Test with `curl` or Postman
Replace `<API_ENDPOINT>` with the API Gateway endpoint:
```bash
curl -X POST <API_ENDPOINT> \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice",
    "email": "alice@example.com",
    "projectTitle": "IoT Air Quality Monitor",
    "description": "Tracks indoor pollution levels in real-time."
  }'
```
You will get a success message from Lambda and an SNS email notification.

---

## 📦 Project Structure (updated)
```
aws-workshop/
├── pom.xml
├── README.md
├── scripts/
│   ├── capstone_deploy.sh
│   ├── launch_stack.sh
│   ├── delete_stack.sh
│   └── ...
├── src/main/java/com/aws/workshop/
│   ├── capstone/
│   │   ├── StudentSubmissionHandler.java
│   │   ├── model/Submission.java
│   │   └── service/
│   │       ├── DynamoDBService.java
│   │       └── SNSService.java
└── resources/
    └── cloudformation/
        └── demo_stack.yaml
```

---

All other modules (EC2, S3, DynamoDB, Lambda, SQS, SNS, CloudWatch, IAM, RDS) are documented in sections above. ✅

Happy building and presenting your Capstone! 🚀
