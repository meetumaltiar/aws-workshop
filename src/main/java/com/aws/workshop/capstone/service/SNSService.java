package com.aws.workshop.capstone.service;

import com.aws.workshop.capstone.model.Submission;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;

public class SNSService {

    private static final String TOPIC_ARN = "arn:aws:sns:ap-south-1:123456789012:project-submissions"; // Replace with real ARN

    public static void notifyNewSubmission(Submission submission) {
        SnsClient snsClient = SnsClient.create();

        String message = String.format("New Project Submission:\nName: %s\nEmail: %s\nTitle: %s",
                submission.getName(),
                submission.getEmail(),
                submission.getProjectTitle());

        PublishRequest request = PublishRequest.builder()
                .topicArn(TOPIC_ARN)
                .subject("New Student Project Submission")
                .message(message)
                .build();

        snsClient.publish(request);
    }
}
