package com.aws.workshop.capstone;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.aws.workshop.capstone.model.Submission;
import com.aws.workshop.capstone.service.DynamoDBService;
import com.aws.workshop.capstone.service.SNSService;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.Map;

public class StudentSubmissionHandler implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    private static final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context context) {
        Map<String, Object> response = new HashMap<>();
        try {
            String body = (String) event.get("body");
            Submission submission = objectMapper.readValue(body, Submission.class);

            context.getLogger().log("📥 Received submission from: " + submission.getName());

            // Save to DynamoDB
            DynamoDBService.saveSubmission(submission);

            // Notify via SNS
            SNSService.notifyNewSubmission(submission);

            response.put("statusCode", 200);
            response.put("headers", Map.of("Content-Type", "application/json"));
            response.put("body", "{\"message\": \"✅ Submission accepted for " + submission.getName() + "\"}");
        } catch (Exception e) {
            context.getLogger().log("❌ Error: " + e.getMessage());

            response.put("statusCode", 500);
            response.put("headers", Map.of("Content-Type", "application/json"));
            response.put("body", "{\"message\": \"❌ Submission failed: " + e.getMessage() + "\"}");
        }

        return response;
    }
}
