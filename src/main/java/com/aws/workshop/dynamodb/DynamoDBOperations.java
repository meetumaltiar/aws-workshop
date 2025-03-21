// DynamoDBOperations.java
package com.aws.workshop.dynamodb;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.*;
import java.util.HashMap;
import java.util.Map;

public class DynamoDBOperations {
    private static final String TABLE_NAME = "Students";
    private static final Region REGION = Region.AP_SOUTH_1;

    public static void main(String[] args) {
        DynamoDbClient ddb = DynamoDbClient.builder().region(REGION).build();

        createTable(ddb);
        putItem(ddb);
        getItem(ddb);
        deleteItem(ddb);

        ddb.close();
    }

    public static void createTable(DynamoDbClient ddb) {
        CreateTableRequest request = CreateTableRequest.builder()
                .tableName(TABLE_NAME)
                .keySchema(KeySchemaElement.builder()
                        .attributeName("studentId")
                        .keyType(KeyType.HASH).build())
                .attributeDefinitions(AttributeDefinition.builder()
                        .attributeName("studentId")
                        .attributeType(ScalarAttributeType.S).build())
                .provisionedThroughput(ProvisionedThroughput.builder()
                        .readCapacityUnits(5L)
                        .writeCapacityUnits(5L)
                        .build())
                .build();

        try {
            ddb.createTable(request);
            System.out.println("✅ Table created: " + TABLE_NAME);
        } catch (ResourceInUseException e) {
            System.out.println("⚠️ Table already exists.");
        }
    }

    public static void putItem(DynamoDbClient ddb) {
        Map<String, AttributeValue> item = new HashMap<>();
        item.put("studentId", AttributeValue.fromS("101"));
        item.put("name", AttributeValue.fromS("Meetu"));
        item.put("email", AttributeValue.fromS("meetu@example.com"));

        PutItemRequest request = PutItemRequest.builder()
                .tableName(TABLE_NAME)
                .item(item)
                .build();

        ddb.putItem(request);
        System.out.println("✅ Item inserted.");
    }

    public static void getItem(DynamoDbClient ddb) {
        Map<String, AttributeValue> key = new HashMap<>();
        key.put("studentId", AttributeValue.fromS("101"));

        GetItemRequest request = GetItemRequest.builder()
                .tableName(TABLE_NAME)
                .key(key)
                .build();

        GetItemResponse response = ddb.getItem(request);
        System.out.println("🔍 Retrieved item: " + response.item());
    }

    public static void deleteItem(DynamoDbClient ddb) {
        Map<String, AttributeValue> key = new HashMap<>();
        key.put("studentId", AttributeValue.fromS("101"));

        DeleteItemRequest request = DeleteItemRequest.builder()
                .tableName(TABLE_NAME)
                .key(key)
                .build();

        ddb.deleteItem(request);
        System.out.println("❌ Item deleted.");
    }
}
