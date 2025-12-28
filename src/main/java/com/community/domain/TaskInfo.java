package com.community.domain;

import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * Entity
 */
public class TaskInfo implements Serializable {
  private static final long serialVersionUID = 1L;

  private Long id;
  private String taskTitle;
  private String taskType;  // SHOPPING, MEDICAL, CLEANING, ACCOMPANY, REPAIR, OTHER
  private Long elderlyId;
  private String elderlyName;
  private String description;
  private String address;
  private String contactPhone;
  
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private Date scheduledDate;
  private String scheduledTime;
  private String priority;  // LOW, MEDIUM, HIGH, URGENT
  private String status;  // PENDING, CLAIMED, IN_PROGRESS, COMPLETED, APPROVED, CANCELLED
  private Long volunteerId;
  private String volunteerName;
  private String volunteerAvatar;  // 志愿者头像URL
  private Date claimedTime;
  private Date completedTime;
  private String completionNote;
  private Integer rating;
  private String feedback;
  private Long createdBy;
  private Long demandId;  // 关联的需求ID
  private Demand demand;  // 关联的需求对象（用于查询）
  private Date createdTime;
  private Date updatedTime;
  
  // 地理位置坐标
  private Double latitude;
  private Double longitude;

  // 关爱对象照片URL（从elderly_info关联查询）
  private String elderlyPhotoUrl;

  // 执行照片（多张，用逗号分隔）
  private String executionPhotos;

  public TaskInfo() {
  }

  public Double getLatitude() {
    return latitude;
  }

  public void setLatitude(Double latitude) {
    this.latitude = latitude;
  }

  public Double getLongitude() {
    return longitude;
  }

  public void setLongitude(Double longitude) {
    this.longitude = longitude;
  }

  public String getElderlyPhotoUrl() {
    return elderlyPhotoUrl;
  }

  public void setElderlyPhotoUrl(String elderlyPhotoUrl) {
    this.elderlyPhotoUrl = elderlyPhotoUrl;
  }

  public String getExecutionPhotos() {
    return executionPhotos;
  }

  public void setExecutionPhotos(String executionPhotos) {
    this.executionPhotos = executionPhotos;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getTaskTitle() {
    return taskTitle;
  }

  public void setTaskTitle(String taskTitle) {
    this.taskTitle = taskTitle;
  }

  public String getTaskType() {
    return taskType;
  }

  public void setTaskType(String taskType) {
    this.taskType = taskType;
  }

  public Long getElderlyId() {
    return elderlyId;
  }

  public void setElderlyId(Long elderlyId) {
    this.elderlyId = elderlyId;
  }

  public String getElderlyName() {
    return elderlyName;
  }

  public void setElderlyName(String elderlyName) {
    this.elderlyName = elderlyName;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getContactPhone() {
    return contactPhone;
  }

  public void setContactPhone(String contactPhone) {
    this.contactPhone = contactPhone;
  }

  public Date getScheduledDate() {
    return scheduledDate;
  }

  public void setScheduledDate(Date scheduledDate) {
    this.scheduledDate = scheduledDate;
  }

  public String getScheduledTime() {
    return scheduledTime;
  }

  public void setScheduledTime(String scheduledTime) {
    this.scheduledTime = scheduledTime;
  }

  public String getPriority() {
    return priority;
  }

  public void setPriority(String priority) {
    this.priority = priority;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Long getVolunteerId() {
    return volunteerId;
  }

  public void setVolunteerId(Long volunteerId) {
    this.volunteerId = volunteerId;
  }

  public String getVolunteerName() {
    return volunteerName;
  }

  public void setVolunteerName(String volunteerName) {
    this.volunteerName = volunteerName;
  }

  public String getVolunteerAvatar() {
    return volunteerAvatar;
  }

  public void setVolunteerAvatar(String volunteerAvatar) {
    this.volunteerAvatar = volunteerAvatar;
  }

  public Date getClaimedTime() {
    return claimedTime;
  }

  public void setClaimedTime(Date claimedTime) {
    this.claimedTime = claimedTime;
  }

  public Date getCompletedTime() {
    return completedTime;
  }

  public void setCompletedTime(Date completedTime) {
    this.completedTime = completedTime;
  }

  public String getCompletionNote() {
    return completionNote;
  }

  public void setCompletionNote(String completionNote) {
    this.completionNote = completionNote;
  }

  public Integer getRating() {
    return rating;
  }

  public void setRating(Integer rating) {
    this.rating = rating;
  }

  public String getFeedback() {
    return feedback;
  }

  public void setFeedback(String feedback) {
    this.feedback = feedback;
  }

  public Long getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(Long createdBy) {
    this.createdBy = createdBy;
  }

  public Long getDemandId() {
    return demandId;
  }

  public void setDemandId(Long demandId) {
    this.demandId = demandId;
  }

  public Demand getDemand() {
    return demand;
  }

  public void setDemand(Demand demand) {
    this.demand = demand;
  }

  public Date getCreatedTime() {
    return createdTime;
  }

  public void setCreatedTime(Date createdTime) {
    this.createdTime = createdTime;
  }

  public Date getUpdatedTime() {
    return updatedTime;
  }

  public void setUpdatedTime(Date updatedTime) {
    this.updatedTime = updatedTime;
  }

  @Override
  public String toString() {
    return "TaskInfo{" +
        "id=" + id +
        ", taskTitle='" + taskTitle + '\'' +
        ", taskType='" + taskType + '\'' +
        ", elderlyName='" + elderlyName + '\'' +
        ", status='" + status + '\'' +
        ", priority='" + priority + '\'' +
        ", scheduledDate=" + scheduledDate +
        '}';
  }
}
