package com.aws.workshop.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import java.util.Map;
import java.util.HashMap;

public class LambdaHandler implements RequestHandler<Map<String, Object>, Map<String, String>> {

    @Override
    public Map<String, String> handleRequest(Map<String, Object> input, Context context) {
        String name = input.getOrDefault("name", "Guest").toString();
        String message = "Hello, " + name + "!";

        Map<String, String> response = new HashMap<>();
        response.put("message", message);
        return response;
    }
}
