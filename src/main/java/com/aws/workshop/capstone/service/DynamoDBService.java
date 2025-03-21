package com.aws.workshop.capstone.service;

import com.aws.workshop.capstone.model.Submission;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

import java.util.HashMap;
import java.util.Map;

public class DynamoDBService {

    private static final String TABLE_NAME = "StudentProjects";

    public static void saveSubmission(Submission submission) {
        DynamoDbClient dynamoDbClient = DynamoDbClient.create();

        Map<String, AttributeValue> item = new HashMap<>();
        item.put("email", AttributeValue.builder().s(submission.getEmail()).build());
        item.put("name", AttributeValue.builder().s(submission.getName()).build());
        item.put("projectTitle", AttributeValue.builder().s(submission.getProjectTitle()).build());
        item.put("description", AttributeValue.builder().s(submission.getDescription()).build());

        PutItemRequest request = PutItemRequest.builder()
                .tableName(TABLE_NAME)
                .item(item)
                .build();

        dynamoDbClient.putItem(request);
    }
}
