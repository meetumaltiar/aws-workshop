// IAMOperations.java
package com.aws.workshop.iam;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.iam.IamClient;
import software.amazon.awssdk.services.iam.model.*;

public class IAMOperations {
    public static void main(String[] args) {
        IamClient iam = IamClient.builder().region(Region.AWS_GLOBAL).build();
        String userName = "StudentUser";

        // 1️⃣ List Users
        ListUsersResponse listUsersResponse = iam.listUsers();
        System.out.println("👥 Existing IAM Users:");
        listUsersResponse.users().forEach(user -> System.out.println(" - " + user.userName()));

        // 2️⃣ Create a User (if not exists)
        boolean userExists = listUsersResponse.users().stream()
                .anyMatch(u -> u.userName().equals(userName));

        if (!userExists) {
            CreateUserRequest createUserRequest = CreateUserRequest.builder().userName(userName).build();
            iam.createUser(createUserRequest);
            System.out.println("✅ Created IAM User: " + userName);
        } else {
            System.out.println("ℹ️ User already exists: " + userName);
        }

        // 3️⃣ Attach ReadOnlyAccess Policy
        AttachUserPolicyRequest attachPolicyRequest = AttachUserPolicyRequest.builder()
                .userName(userName)
                .policyArn("arn:aws:iam::aws:policy/ReadOnlyAccess")
                .build();
        iam.attachUserPolicy(attachPolicyRequest);
        System.out.println("🔐 Attached ReadOnlyAccess policy to " + userName);

        iam.close();
    }
}
