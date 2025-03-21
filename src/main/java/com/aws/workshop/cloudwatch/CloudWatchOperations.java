// CloudWatchOperations.java
package com.aws.workshop.cloudwatch;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.cloudwatch.CloudWatchClient;
import software.amazon.awssdk.services.cloudwatch.model.*;

import java.time.Instant;

public class CloudWatchOperations {
    public static void main(String[] args) {
        Region region = Region.AP_SOUTH_1;

        // 1️⃣ Publish custom metric
        CloudWatchClient cw = CloudWatchClient.builder().region(region).build();

        MetricDatum datum = MetricDatum.builder()
                .metricName("WorkshopMetric")
                .unit(StandardUnit.COUNT)
                .value(1.0)
                .timestamp(Instant.now())
                .build();

        PutMetricDataRequest request = PutMetricDataRequest.builder()
                .namespace("AWSWorkshop")
                .metricData(datum)
                .build();

        cw.putMetricData(request);
        System.out.println("📊 Published custom metric to CloudWatch.");

        cw.close();
    }
}