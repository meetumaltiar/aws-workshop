package com.aws.workshop.s3;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;

import java.io.File;

public class S3Upload {
    public static void main(String[] args) {
        String bucketName = "my-bucket456c0a88";
        String key = "lambda/aws-workshop-1.0-SNAPSHOT.jar";
        String filePath = "target/aws-workshop-1.0-SNAPSHOT.jar";

        try (S3Client s3 = S3Client.builder()
                .region(Region.AP_SOUTH_1)
                .build()) {
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3.putObject(putObjectRequest, RequestBody.fromFile(new File(filePath)));
            System.out.println("✅ Upload successful: " + key);
        } catch (S3Exception e) {
            System.err.println("❌ Upload failed: " + e.awsErrorDetails().errorMessage());
        }
    }
}

