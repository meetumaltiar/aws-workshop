package com.aws.workshop.s3;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteBucketRequest;

public class S3DeleteBucket {
    public static void main(String[] args) {
        S3Client s3 = S3Client.create();
        String bucketName = "my-java-s3-bucket";

        DeleteBucketRequest deleteBucketRequest = DeleteBucketRequest.builder()
                .bucket(bucketName)
                .build();

        s3.deleteBucket(deleteBucketRequest);
        System.out.println("S3 Bucket Deleted: " + bucketName);
    }
}
