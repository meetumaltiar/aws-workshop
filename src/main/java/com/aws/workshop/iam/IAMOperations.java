// IAMOperations.java
package com.aws.workshop.iam;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.iam.IamClient;
import software.amazon.awssdk.services.iam.model.*;

public class IAMOperations {
    public static void main(String[] args) {
        IamClient iam = IamClient.builder().region(Region.AWS_GLOBAL).build();
        String userName = "StudentUser";

        try {
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

            // 4️⃣ List Attached Policies
            ListAttachedUserPoliciesResponse policiesResponse =
                    iam.listAttachedUserPolicies(ListAttachedUserPoliciesRequest.builder().userName(userName).build());

            System.out.println("📎 Attached Policies:");
            policiesResponse.attachedPolicies().forEach(policy ->
                    System.out.println(" - " + policy.policyName()));

            // 5️⃣ Delete User
            // Must detach policies first
            for (AttachedPolicy policy : policiesResponse.attachedPolicies()) {
                iam.detachUserPolicy(DetachUserPolicyRequest.builder()
                        .userName(userName)
                        .policyArn(policy.policyArn())
                        .build());
                System.out.println("🧹 Detached policy: " + policy.policyName());
            }

            iam.deleteUser(DeleteUserRequest.builder().userName(userName).build());
            System.out.println("❌ Deleted IAM User: " + userName);

        } catch (IamException e) {
            System.err.println("❌ IAM Error: " + e.awsErrorDetails().errorMessage());
        } finally {
            iam.close();
        }
    }
}