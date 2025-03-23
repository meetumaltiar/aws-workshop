package com.aws.workshop.s3;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.services.s3.model.S3Object;

public class S3ListObjects {
    public static void main(String[] args) {
        String bucketName = "my-bucket604bf308";

        S3Client s3 = S3Client.builder()
                .region(Region.AP_SOUTH_1) // ✅ Specify your region
                .build();

        try {
            ListObjectsV2Request request = ListObjectsV2Request.builder()
                    .bucket(bucketName)
                    .build();

            ListObjectsV2Response response = s3.listObjectsV2(request);

            if (response.hasContents() && !response.contents().isEmpty()) {
                System.out.println("📂 Objects in bucket: " + bucketName);
                for (S3Object object : response.contents()) {
                    System.out.println(" - " + object.key());
                }
            } else {
                System.out.println("ℹ️ No objects found in bucket: " + bucketName);
            }

        } catch (S3Exception e) {
            System.err.println("❌ S3 Error: " + e.awsErrorDetails().errorMessage());
        } finally {
            s3.close();
        }
    }
}
