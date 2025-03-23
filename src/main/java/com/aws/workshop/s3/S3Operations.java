package com.aws.workshop.s3;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;

import java.util.UUID;

public class S3Operations {
    public static void main(String[] args) {
        String uniqueBucketName = "my-bucket" + UUID.randomUUID().toString().substring(0, 8);

        S3Client s3 = S3Client.builder()
                .region(Region.AP_SOUTH_1)
                .build();

        try {
            CreateBucketRequest request = CreateBucketRequest.builder()
                    .bucket(uniqueBucketName)
                    .build();

            s3.createBucket(request);
            System.out.println("✅ S3 Bucket Created: " + uniqueBucketName);
        } catch (S3Exception e) {
            System.err.println("❌ Failed to create bucket: " + e.awsErrorDetails().errorMessage());
        } finally {
            s3.close();
        }
    }
}
