package com.community.domain;

import java.util.Date;

/**
 * 志愿者排班实体类
 */
public class VolunteerSchedule {
    private Long id;
    private Long volunteerId;
    private Integer dayOfWeek; // 1-7
    private String timeSlot; // MORNING, AFTERNOON, EVENING
    private Integer isAvailable; // 1: available, 0: unavailable
    private String assignSource; // VOLUNTEER 或 ADMIN
    private String confirmStatus; // PENDING / CONFIRMED / REJECTED
    private String rejectReason;
    private Date createdAt;
    private Date updatedAt;
    
    // 扩展字段：用于关联查询
    private String volunteerName;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public Integer getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(Integer dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getTimeSlot() {
        return timeSlot;
    }

    public void setTimeSlot(String timeSlot) {
        this.timeSlot = timeSlot;
    }

    public Integer getIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(Integer isAvailable) {
        this.isAvailable = isAvailable;
    }

    public String getAssignSource() {
        return assignSource;
    }

    public void setAssignSource(String assignSource) {
        this.assignSource = assignSource;
    }

    public String getConfirmStatus() {
        return confirmStatus;
    }

    public void setConfirmStatus(String confirmStatus) {
        this.confirmStatus = confirmStatus;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
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
}
