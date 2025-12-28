package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Appeal Entity - 用户申诉管理
 */
public class Appeal implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private String userRole;  // VOLUNTEER, FAMILY
    private String username;
    private String phone;
    private String appealType;  // account_blocked, registration_rejected, skill_issue, rating_dispute, payment_issue, demand_rejected, volunteer_issue, service_quality, system_issue, other
    private String description;
    private String attachment;
    private String status;  // PENDING, PROCESSING, RESOLVED, REJECTED
    private String response;
    private Long respondedBy;
    private Date respondedAt;
    private Date createdAt;
    private Date updatedAt;

    // Associated objects
    private String respondedByName;
    private String statusDisplay;
    private String userRoleDisplay;

    public Appeal() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAppealType() {
        return appealType;
    }

    public void setAppealType(String appealType) {
        this.appealType = appealType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAttachment() {
        return attachment;
    }

    public void setAttachment(String attachment) {
        this.attachment = attachment;
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

    public String getRespondedByName() {
        return respondedByName;
    }

    public void setRespondedByName(String respondedByName) {
        this.respondedByName = respondedByName;
    }

    public String getStatusDisplay() {
        return statusDisplay;
    }

    public void setStatusDisplay(String statusDisplay) {
        this.statusDisplay = statusDisplay;
    }

    public String getUserRoleDisplay() {
        return userRoleDisplay;
    }

    public void setUserRoleDisplay(String userRoleDisplay) {
        this.userRoleDisplay = userRoleDisplay;
    }

    @Override
    public String toString() {
        return "Appeal{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", userRole='" + userRole + '\'' +
                ", appealType='" + appealType + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
