package com.aws.workshop.s3;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

public class S3Upload {
    public static void main(String[] args) {
        S3Client s3 = S3Client.create();
        String bucketName = "my-java-s3-bucket";
        String key = "test-file.txt";
        String filePath = "path/to/local/file.txt";

        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();

        s3.putObject(putObjectRequest, RequestBody.fromFile(new java.io.File(filePath)));
        System.out.println("File uploaded successfully: " + key);
    }
}
