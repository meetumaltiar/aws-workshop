package com.aws.workshop.s3;

import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.S3Object;

public class S3ListObjects {
    public static void main(String[] args) {
        S3Client s3 = S3Client.create();
        String bucketName = "my-java-s3-bucket";

        ListObjectsV2Request listObjects = ListObjectsV2Request.builder()
                .bucket(bucketName)
                .build();

        ListObjectsV2Response response = s3.listObjectsV2(listObjects);
        for (S3Object object : response.contents()) {
            System.out.println(" - " + object.key());
        }
    }
}
