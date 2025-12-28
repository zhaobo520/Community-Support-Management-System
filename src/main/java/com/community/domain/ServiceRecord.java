package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Service Record Entity
 */
public class ServiceRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long taskId;
    private Long volunteerId;
    private Long elderlyId;
    private Long familyUserId;
    private Date serviceDate;
    private String serviceContent;
    private Integer serviceDuration;
    private String servicePhotos;
    private String serviceNotes;
    private String familyFeedback;
    private Integer rating;
    private Date createdAt;
    private Date updatedAt;

    // Associated objects
    private Task task;
    private User volunteer;
    private String volunteerName;

    public ServiceRecord() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Long getElderlyId() {
        return elderlyId;
    }

    public void setElderlyId(Long elderlyId) {
        this.elderlyId = elderlyId;
    }

    public Long getFamilyUserId() {
        return familyUserId;
    }

    public void setFamilyUserId(Long familyUserId) {
        this.familyUserId = familyUserId;
    }

    public Date getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Date serviceDate) {
        this.serviceDate = serviceDate;
    }

    public String getServiceContent() {
        return serviceContent;
    }

    public void setServiceContent(String serviceContent) {
        this.serviceContent = serviceContent;
    }

    public Integer getServiceDuration() {
        return serviceDuration;
    }

    public void setServiceDuration(Integer serviceDuration) {
        this.serviceDuration = serviceDuration;
    }

    public String getServicePhotos() {
        return servicePhotos;
    }

    public void setServicePhotos(String servicePhotos) {
        this.servicePhotos = servicePhotos;
    }

    public String getServiceNotes() {
        return serviceNotes;
    }

    public void setServiceNotes(String serviceNotes) {
        this.serviceNotes = serviceNotes;
    }

    public String getFamilyFeedback() {
        return familyFeedback;
    }

    public void setFamilyFeedback(String familyFeedback) {
        this.familyFeedback = familyFeedback;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
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

    public Task getTask() {
        return task;
    }

    public void setTask(Task task) {
        this.task = task;
    }

    public User getVolunteer() {
        return volunteer;
    }

    public void setVolunteer(User volunteer) {
        this.volunteer = volunteer;
    }

    public String getVolunteerName() {
        return volunteerName;
    }

    public void setVolunteerName(String volunteerName) {
        this.volunteerName = volunteerName;
    }

    @Override
    public String toString() {
        return "ServiceRecord{" +
                "id=" + id +
                ", taskId=" + taskId +
                ", volunteerId=" + volunteerId +
                ", serviceDate=" + serviceDate +
                ", serviceDuration=" + serviceDuration +
                ", rating=" + rating +
                '}';
    }
}
