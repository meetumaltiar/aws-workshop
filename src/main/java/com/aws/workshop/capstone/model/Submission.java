package com.aws.workshop.capstone.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Submission {
    @JsonProperty("name")
    private String name;

    @JsonProperty("email")
    private String email;

    @JsonProperty("projectTitle")
    private String projectTitle;

    @JsonProperty("description")
    private String description;

    public Submission() {}

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getProjectTitle() {
        return projectTitle;
    }
    public void setProjectTitle(String projectTitle) {
        this.projectTitle = projectTitle;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Submission{name='" + name + "', email='" + email + "', projectTitle='" + projectTitle + "', description='" + description + "'}";
    }
}