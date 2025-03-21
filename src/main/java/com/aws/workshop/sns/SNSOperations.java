// SNSOperations.java
package com.aws.workshop.sns;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.*;

public class SNSOperations {
    public static void main(String[] args) {
        SnsClient sns = SnsClient.builder().region(Region.AP_SOUTH_1).build();

        String topicName = "MyJavaTopic";

        // 1️⃣ Create Topic
        CreateTopicRequest createRequest = CreateTopicRequest.builder().name(topicName).build();
        CreateTopicResponse createResponse = sns.createTopic(createRequest);
        String topicArn = createResponse.topicArn();
        System.out.println("✅ Created topic ARN: " + topicArn);

        // 2️⃣ Publish Message
        PublishRequest pubRequest = PublishRequest.builder()
                .topicArn(topicArn)
                .message("Hello from AWS Java SNS!")
                .build();
        sns.publish(pubRequest);
        System.out.println("📨 Message published to topic.");

        // 3️⃣ List Topics
        ListTopicsResponse listResponse = sns.listTopics();
        System.out.println("📋 Topics:");
        listResponse.topics().forEach(t -> System.out.println(" - " + t.topicArn()));

        sns.close();
    }
}
