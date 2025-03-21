package com.aws.workshop.ec2;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.ec2.Ec2Client;
import software.amazon.awssdk.services.ec2.model.*;

public class EC2Operations {
    public static void main(String[] args) {
        Region region = Region.AP_SOUTH_1; // Mumbai region
        Ec2Client ec2 = Ec2Client.builder().region(region).build();

        // 1️⃣ Describe running EC2 instances
        describeInstances(ec2);

        // 2️⃣ Launch new EC2 instance (Optional: Uncomment to use)
        //launchInstance(ec2);

        // 3️⃣ Stop an instance (Optional: Uncomment and provide instance ID)
        //stopInstance(ec2, "i-xxxxxxxxxxxxxxxxx");

        // 4️⃣ Terminate an instance (Optional: Uncomment and provide instance ID)
        //terminateInstance(ec2, "i-xxxxxxxxxxxxxxxxx");

        ec2.close();
    }

    public static void describeInstances(Ec2Client ec2) {
        DescribeInstancesRequest request = DescribeInstancesRequest.builder().build();
        DescribeInstancesResponse response = ec2.describeInstances(request);

        System.out.println("Listing EC2 Instances:");
        for (Reservation reservation : response.reservations()) {
            for (Instance instance : reservation.instances()) {
                System.out.printf("- Instance ID: %s, State: %s, Type: %s\n",
                        instance.instanceId(), instance.state().name(), instance.instanceType());
            }
        }
    }

    public static void launchInstance(Ec2Client ec2) {
        RunInstancesRequest runRequest = RunInstancesRequest.builder()
                .imageId("ami-0c768662cc797cd75") // Amazon Linux 2 (Mumbai)
                .instanceType(InstanceType.T2_MICRO)
                .maxCount(1)
                .minCount(1)
                .keyName("my-key-pair") // Replace with your key pair name
                .securityGroups("my-security-group") // Replace with your security group
                .build();

        RunInstancesResponse response = ec2.runInstances(runRequest);
        String instanceId = response.instances().get(0).instanceId();
        System.out.println("Launched EC2 instance with ID: " + instanceId);
    }

    public static void stopInstance(Ec2Client ec2, String instanceId) {
        StopInstancesRequest stopRequest = StopInstancesRequest.builder()
                .instanceIds(instanceId)
                .build();

        ec2.stopInstances(stopRequest);
        System.out.println("Stopping EC2 instance: " + instanceId);
    }

    public static void terminateInstance(Ec2Client ec2, String instanceId) {
        TerminateInstancesRequest terminateRequest = TerminateInstancesRequest.builder()
                .instanceIds(instanceId)
                .build();

        ec2.terminateInstances(terminateRequest);
        System.out.println("Terminating EC2 instance: " + instanceId);
    }
}
