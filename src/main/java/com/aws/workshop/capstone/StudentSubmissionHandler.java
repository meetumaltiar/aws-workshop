package com.aws.workshop.capstone;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.aws.workshop.capstone.model.Submission;
import com.aws.workshop.capstone.service.DynamoDBService;
import com.aws.workshop.capstone.service.SNSService;

public class StudentSubmissionHandler implements RequestHandler<Submission, String> {

    @Override
    public String handleRequest(Submission input, Context context) {
        context.getLogger().log("Received submission from: " + input.getName());

        try {
            // 1. Save to DynamoDB
            DynamoDBService.saveSubmission(input);

            // 2. Notify via SNS
            SNSService.notifyNewSubmission(input);

            return "✅ Submission accepted for " + input.getName();
        } catch (Exception e) {
            context.getLogger().log("❌ Error: " + e.getMessage());
            return "❌ Submission failed: " + e.getMessage();
        }
    }
}
