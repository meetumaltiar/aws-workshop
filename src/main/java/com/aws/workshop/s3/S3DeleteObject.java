package com.aws.workshop.s3;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;

public class S3DeleteObject {
    public static void main(String[] args) {
        S3Client s3 = S3Client.create();
        String bucketName = "my-java-s3-bucket";
        String key = "test-file.txt";

        DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();

        s3.deleteObject(deleteObjectRequest);
        System.out.println("File deleted: " + key);
    }
}
