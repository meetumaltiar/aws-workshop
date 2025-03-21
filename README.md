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
│   └── test_lambda_api.sh
├── src/
│   ├── main/
│   │   ├── java/com/aws/workshop/
│   │   │   ├── s3/                  # S3 Java code
│   │   │   ├── ec2/                 # EC2 Java code
│   │   │   └── lambda/              # Lambda Java code
│   │   └── resources/awscli/        # AWS CLI commands
```

---

## ✅ Prerequisites
- Java 17
- Maven
- AWS CLI (configured via `aws configure`)
- AWS Free Tier account

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

## 📬 Feedback
Feel free to fork, star ⭐, and raise issues. This project is made to help students learn AWS from the ground up.

---

Happy learning! 🚀
