package com.aws.workshop.ec2;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.ec2.model.*;

import java.time.Duration;

public class EC2Operations {

    public static void main(String[] args) throws InterruptedException {
        Ec2Client ec2 = Ec2Client.builder().region(Region.AP_SOUTH_1).build();

        // Step 1️⃣ Launch instance
        String instanceId = launchInstance(ec2);

        // Step 2️⃣ Wait (simulate workload)
        System.out.println("⏳ Instance running. Sleeping for 1 minute...");
        Thread.sleep(Duration.ofMinutes(1).toMillis());

        // Step 3️⃣ Terminate instance
        terminateInstance(ec2, instanceId);

        ec2.close();
    }

    public static String launchInstance(Ec2Client ec2) {
        RunInstancesRequest runRequest = RunInstancesRequest.builder()
                .imageId("ami-0c768662cc797cd75") // ✅ Amazon Linux 2 (Mumbai)
                .instanceType(InstanceType.T2_MICRO)
                .maxCount(1)
                .minCount(1)
                .keyName("my-key") // ✅ Replace with your real key pair
                .securityGroupIds("sg-my-security-group") // ✅ Your actual security group
                .build();

        RunInstancesResponse response = ec2.runInstances(runRequest);
        String instanceId = response.instances().get(0).instanceId();
        System.out.println("✅ Launched EC2 instance with ID: " + instanceId);
        return instanceId;
    }

    public static void terminateInstance(Ec2Client ec2, String instanceId) {
        TerminateInstancesRequest terminateRequest = TerminateInstancesRequest.builder()
                .instanceIds(instanceId)
                .build();

        ec2.terminateInstances(terminateRequest);
        System.out.println("🗑️ Terminated EC2 instance: " + instanceId);
    }
}
