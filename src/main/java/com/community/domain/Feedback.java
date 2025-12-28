package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Feedback Entity
 */
public class Feedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long familyUserId;
    private Long taskId;
    private Long volunteerId;
    private String feedbackType;  // RATING, SUGGESTION, COMPLAINT
    private String title;
    private String content;
    private Integer rating;
    private String status;  // PENDING, PROCESSING, RESOLVED
    private String response;
    private Long respondedBy;
    private Date respondedAt;
    private Date createdAt;
    private Date updatedAt;

    // Associated objects
    private String volunteerName;
    private String taskTitle;

    public Feedback() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFamilyUserId() {
        return familyUserId;
    }

    public void setFamilyUserId(Long familyUserId) {
        this.familyUserId = familyUserId;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Long getRespondedBy() {
        return respondedBy;
    }

    public void setRespondedBy(Long respondedBy) {
        this.respondedBy = respondedBy;
    }

    public Date getRespondedAt() {
        return respondedAt;
    }

    public void setRespondedAt(Date respondedAt) {
        this.respondedAt = respondedAt;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getVolunteerName() {
        return volunteerName;
    }

    public void setVolunteerName(String volunteerName) {
        this.volunteerName = volunteerName;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", feedbackType='" + feedbackType + '\'' +
                ", title='" + title + '\'' +
                ", status='" + status + '\'' +
                ", rating=" + rating +
                '}';
    }
}
