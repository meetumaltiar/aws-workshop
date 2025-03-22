# 🚀 AWS Workshop (Java + AWS CLI)

This is a hands-on AWS workshop designed for developers and students. Using **Java**, **AWS SDK v2**, and **AWS CLI**, this workshop helps you build real-world applications across multiple AWS services – all within the **Free Tier**.

---

## 🧱 Workshop Modules

| Module         | Java Code | AWS CLI | Status        |
|----------------|-----------|---------|---------------|
| EC2            | ✅        | ✅      | ✅ Complete   |
| S3             | ✅        | ✅      | ✅ Complete   |
| Lambda         | ✅        | ✅      | ✅ Complete   |
| DynamoDB       | ✅        | ✅      | ✅ Complete   |
| SNS            | ✅        | ✅      | ✅ Complete   |
| SQS            | ✅        | ✅      | ✅ Complete   |
| IAM            | ✅        | ✅      | ✅ Complete   |
| CloudWatch     | ✅        | ✅      | ✅ Complete   |
| RDS            | ❌        | ✅      | ✅ Complete   |
| CloudFormation | ✅ (YAML) | ✅      | ✅ Complete   |

---

## 🛠 Getting Started

```bash
# Clone the repository
git clone https://github.com/your-username/aws-workshop.git
cd aws-workshop

# Build the project using Maven
mvn clean package

# Set your AWS credentials
aws configure
```

---

## 📜 Useful Scripts

| Script                        | Purpose                                |
|------------------------------|----------------------------------------|
| `scripts/ec2_script.sh`      | Launch EC2 instance                    |
| `scripts/s3_script.sh`       | Manage S3 buckets                      |
| `scripts/lambda_script.sh`   | Deploy Lambda function                 |
| `scripts/dynamodb_script.sh` | CRUD on DynamoDB table                 |
| `scripts/sns_script.sh`      | Create & publish to SNS topic         |
| `scripts/sqs_script.sh`      | Create and send messages to SQS queue |
| `scripts/rds_script.sh`      | Launch RDS and connect from EC2       |
| `scripts/capstone_deploy.sh` | Deploy full Capstone infrastructure   |
| `scripts/deploy_capstone_lambda.sh` | Upload Lambda JAR to S3 & link |
| `scripts/cleanup_all.sh`     | Delete all created AWS resources      |

---

## 💼 Capstone Project: Student Project Submission Portal

### 🧩 Overview

A fully working backend using:
- AWS Lambda (Java)
- API Gateway (REST)
- DynamoDB (NoSQL storage)
- SNS (Email notifications)
- CloudFormation (Infra-as-Code)

### 📁 Folder Structure

```
src/
 └── main/
      ├── java/com/aws/workshop/
      │     ├── s3/
      │     ├── ec2/
      │     ├── dynamodb/
      │     ├── sns/
      │     ├── sqs/
      │     ├── capstone/      <-- Capstone Code (Lambda, Models, Services)
      │
      └── resources/
            └── cloudformation/
                  capstone_stack.yaml
```

### 🚀 Deploy Capstone Infra

```bash
# Upload Lambda JAR to S3
aws s3 mb s3://maltiar-capstone-bucket --region ap-south-1
aws s3 cp target/aws-workshop-1.0-SNAPSHOT.jar   s3://maltiar-capstone-bucket/lambda/aws-workshop-1.0-SNAPSHOT.jar

# Deploy stack
aws cloudformation create-stack   --stack-name capstone-stack   --template-body file://src/main/resources/cloudformation/capstone_stack.yaml   --capabilities CAPABILITY_NAMED_IAM   --region ap-south-1   --parameters ParameterKey=AdminEmail,ParameterValue=alpha.meetu.aws@gmail.com
```

### 🔍 Get API Gateway URL

```bash
aws cloudformation describe-stacks   --stack-name capstone-stack   --region ap-south-1   --query "Stacks[0].Outputs[?OutputKey=='APIEndpoint'].OutputValue"   --output text
```

### 📤 Submit a Test Project (using curl)

```bash
curl -X POST <API_URL_FROM_ABOVE>   -H "Content-Type: application/json"   -d '{
    "name": "John Doe",
    "email": "john.doe@gmail.com",
    "projectTitle": "Resume Project",
    "description": "Built on AWS."
  }'
```

### 🧪 Test with Postman

A prebuilt Postman collection is available for API testing. Import it from the `postman/` folder.

---

## 🧹 Cleanup Resources

```bash
./scripts/cleanup_all.sh
```

---

## 🙌 Author

**Meetu Maltiar**  
Speaker, AWS Workshop | [GitHub](https://github.com/meetumaltiar) | [LinkedIn](https://www.linkedin.com/in/mmaltiar/)

---

## 🏁 License

This project is licensed under the MIT License.
