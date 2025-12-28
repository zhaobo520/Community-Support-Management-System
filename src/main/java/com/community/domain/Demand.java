package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Demand Entity
 */
public class Demand implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String title;
    private Long targetId;
    private Long familyUserId;
    private String demandType;
    private String urgency;
    private String requiredSkill;
    private String timeRequirement;
    private Date expectedStartTime;
    private Date expectedEndTime;
    private String description;
    private String serviceAddress;
    private String contactPerson;
    private String contactPhone;
    private String status;
    private Long reviewerId;
    private Date reviewTime;
    private String reviewComment;
    private Long taskId;
    private String attachmentUrl;  // 附件/情景图片URL
    private Date createdAt;
    private Date updatedAt;

    // Associated objects for queries
    private User familyUser;
    private User reviewer;
    private HelpTarget target;
    private Task task;

    public Demand() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getTargetId() {
        return targetId;
    }

    public void setTargetId(Long targetId) {
        this.targetId = targetId;
    }

    public Long getFamilyUserId() {
        return familyUserId;
    }

    public void setFamilyUserId(Long familyUserId) {
        this.familyUserId = familyUserId;
    }

    public String getDemandType() {
        return demandType;
    }

    public void setDemandType(String demandType) {
        this.demandType = demandType;
    }

    public String getUrgency() {
        return urgency;
    }

    public void setUrgency(String urgency) {
        this.urgency = urgency;
    }

    public String getRequiredSkill() {
        return requiredSkill;
    }

    public void setRequiredSkill(String requiredSkill) {
        this.requiredSkill = requiredSkill;
    }

    public String getTimeRequirement() {
        return timeRequirement;
    }

    public void setTimeRequirement(String timeRequirement) {
        this.timeRequirement = timeRequirement;
    }

    public Date getExpectedStartTime() {
        return expectedStartTime;
    }

    public void setExpectedStartTime(Date expectedStartTime) {
        this.expectedStartTime = expectedStartTime;
    }

    public Date getExpectedEndTime() {
        return expectedEndTime;
    }

    public void setExpectedEndTime(Date expectedEndTime) {
        this.expectedEndTime = expectedEndTime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getServiceAddress() {
        return serviceAddress;
    }

    public void setServiceAddress(String serviceAddress) {
        this.serviceAddress = serviceAddress;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getReviewerId() {
        return reviewerId;
    }

    public void setReviewerId(Long reviewerId) {
        this.reviewerId = reviewerId;
    }

    public Date getReviewTime() {
        return reviewTime;
    }

    public void setReviewTime(Date reviewTime) {
        this.reviewTime = reviewTime;
    }

    public String getReviewComment() {
        return reviewComment;
    }

    public void setReviewComment(String reviewComment) {
        this.reviewComment = reviewComment;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getAttachmentUrl() {
        return attachmentUrl;
    }

    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
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

    public User getFamilyUser() {
        return familyUser;
    }

    public void setFamilyUser(User familyUser) {
        this.familyUser = familyUser;
    }

    public User getReviewer() {
        return reviewer;
    }

    public void setReviewer(User reviewer) {
        this.reviewer = reviewer;
    }

    public HelpTarget getTarget() {
        return target;
    }

    public void setTarget(HelpTarget target) {
        this.target = target;
    }

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    @Override
    public String toString() {
        return "Demand{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", demandType='" + demandType + '\'' +
                ", urgency='" + urgency + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
