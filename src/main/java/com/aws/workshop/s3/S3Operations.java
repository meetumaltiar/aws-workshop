package com.aws.workshop.s3;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;

public class S3Operations {
    public static void main(String[] args) {
        S3Client s3 = S3Client.create();
        String bucketName = "my-java-s3-bucket";

        CreateBucketRequest createBucketRequest = CreateBucketRequest.builder()
                .bucket(bucketName)
                .build();

        s3.createBucket(createBucketRequest);
        System.out.println("S3 Bucket Created: " + bucketName);
    }
}
