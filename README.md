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

This Capstone app demonstrates how to integrate **Lambda**, **API Gateway**, **DynamoDB**, and **SNS** using Java and AWS CLI.

### 📋 Functionality
- Student submits name, email, project title, and description.
- Lambda stores it in DynamoDB table `StudentProjects`.
- Admin is notified by email via SNS topic `project-submissions`.

### 🔧 Setup Steps

#### ✅ 1. Provision Required Resources
```bash
chmod +x scripts/capstone_deploy.sh
./scripts/capstone_deploy.sh
```
This will:
- Create `StudentProjects` DynamoDB table
- Create `project-submissions` SNS topic
- Ask for your email to subscribe (confirm in inbox)

#### ✅ 2. Deploy Lambda + API Gateway
```bash
chmod +x scripts/deploy_capstone_lambda.sh
./scripts/deploy_capstone_lambda.sh
```
This will:
- Create IAM Role + Lambda Function
- Configure `/submit` resource on API Gateway
- Deploy REST API and output public endpoint

### 🧪 Testing the Endpoint
#### Option A: `curl`
```bash
curl -X POST https://<api_id>.execute-api.ap-south-1.amazonaws.com/prod/submit \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice",
    "email": "alice@example.com",
    "projectTitle": "IoT Air Quality Monitor",
    "description": "Tracks indoor pollution levels in real-time."
  }'
```
#### Option B: Postman (recommended)
Import the included **Postman Collection** from `resources/postman/CapstoneCollection.json`

---

## 🧳 Capstone Folder Structure
```
com/aws/workshop/capstone/
├── StudentSubmissionHandler.java       # Lambda handler
├── model/Submission.java               # Data model
└── service/
    ├── DynamoDBService.java            # Save to DynamoDB
    └── SNSService.java                 # Notify via SNS
```

---

## ✅ Results
- ✅ Project submission is stored in DynamoDB
- ✅ Admin receives real-time email
- ✅ Full Java-based Lambda integrated with AWS services

Ready for your students to build real-world cloud applications! 🚀