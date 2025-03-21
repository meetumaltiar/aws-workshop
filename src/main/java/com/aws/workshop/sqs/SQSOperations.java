package com.aws.workshop.sqs;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.*;

import java.util.List;

public class SQSOperations {
    public static void main(String[] args) {
        Region region = Region.AP_SOUTH_1;
        SqsClient sqsClient = SqsClient.builder().region(region).build();

        String queueName = "MyJavaQueue";

        // 1️⃣ Create Queue
        CreateQueueRequest createQueueRequest = CreateQueueRequest.builder()
                .queueName(queueName)
                .build();
        String queueUrl = sqsClient.createQueue(createQueueRequest).queueUrl();
        System.out.println("✅ Queue created: " + queueUrl);

        // 2️⃣ Send Message
        SendMessageRequest sendRequest = SendMessageRequest.builder()
                .queueUrl(queueUrl)
                .messageBody("Hello from SQS via Java!")
                .build();
        sqsClient.sendMessage(sendRequest);
        System.out.println("📤 Message sent to queue.");

        // 3️⃣ Receive Message
        ReceiveMessageRequest receiveRequest = ReceiveMessageRequest.builder()
                .queueUrl(queueUrl)
                .maxNumberOfMessages(1)
                .build();

        List<Message> messages = sqsClient.receiveMessage(receiveRequest).messages();
        for (Message message : messages) {
            System.out.println("📥 Received message: " + message.body());

            // 4️⃣ Delete Message
            DeleteMessageRequest deleteRequest = DeleteMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .receiptHandle(message.receiptHandle())
                    .build();
            sqsClient.deleteMessage(deleteRequest);
            System.out.println("🗑️ Message deleted.");
        }

        sqsClient.close();
    }
}
