package com.community.domain;

import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * Volunteer Profile Entity
 */
public class VolunteerProfile implements Serializable {
  private static final long serialVersionUID = 1L;

  private Long id;
  private Long userId;
  private String idCard;
  private String gender;  // MALE, FEMALE
  
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private Date birthDate;
  private Integer age;
  private String address;
  private String emergencyContact;
  private String emergencyPhone;
  private String skills;  // Comma separated
  private String serviceArea;
  private String availableTime;
  private String volunteerStatus;  // PENDING, APPROVED, REJECTED, SUSPENDED
  private Date approveTime;
  private Long approveBy;
  private BigDecimal serviceHours;
  private Integer taskCount;
  private BigDecimal averageRating;
  private String introduction;
  private String photoUrl;
  private Date createdTime;
  private Date updatedTime;

  // Associated user info (non-database fields)
  private String username;
  private String fullName;
  private String phone;
  private String email;

  // Skill list (non-database field)
  private List<VolunteerSkill> skillList;

  public VolunteerProfile() {
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

  public String getIdCard() {
    return idCard;
  }

  public void setIdCard(String idCard) {
    this.idCard = idCard;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public Date getBirthDate() {
    return birthDate;
  }

  public void setBirthDate(Date birthDate) {
    this.birthDate = birthDate;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getEmergencyContact() {
    return emergencyContact;
  }

  public void setEmergencyContact(String emergencyContact) {
    this.emergencyContact = emergencyContact;
  }

  public String getEmergencyPhone() {
    return emergencyPhone;
  }

  public void setEmergencyPhone(String emergencyPhone) {
    this.emergencyPhone = emergencyPhone;
  }

  public String getSkills() {
    return skills;
  }

  public void setSkills(String skills) {
    this.skills = skills;
  }

  public String getServiceArea() {
    return serviceArea;
  }

  public void setServiceArea(String serviceArea) {
    this.serviceArea = serviceArea;
  }

  public String getAvailableTime() {
    return availableTime;
  }

  public void setAvailableTime(String availableTime) {
    this.availableTime = availableTime;
  }

  public String getVolunteerStatus() {
    return volunteerStatus;
  }

  public void setVolunteerStatus(String volunteerStatus) {
    this.volunteerStatus = volunteerStatus;
  }

  public Date getApproveTime() {
    return approveTime;
  }

  public void setApproveTime(Date approveTime) {
    this.approveTime = approveTime;
  }

  public Long getApproveBy() {
    return approveBy;
  }

  public void setApproveBy(Long approveBy) {
    this.approveBy = approveBy;
  }

  public BigDecimal getServiceHours() {
    return serviceHours;
  }

  public void setServiceHours(BigDecimal serviceHours) {
    this.serviceHours = serviceHours;
  }

  public Integer getTaskCount() {
    return taskCount;
  }

  public void setTaskCount(Integer taskCount) {
    this.taskCount = taskCount;
  }

  public BigDecimal getAverageRating() {
    return averageRating;
  }

  public void setAverageRating(BigDecimal averageRating) {
    this.averageRating = averageRating;
  }

  public String getIntroduction() {
    return introduction;
  }

  public void setIntroduction(String introduction) {
    this.introduction = introduction;
  }

  public String getPhotoUrl() {
    return photoUrl;
  }

  public void setPhotoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
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

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getFullName() {
    return fullName;
  }

  public void setFullName(String fullName) {
    this.fullName = fullName;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public List<VolunteerSkill> getSkillList() {
    return skillList;
  }

  public void setSkillList(List<VolunteerSkill> skillList) {
    this.skillList = skillList;
  }

  @Override
  public String toString() {
    return "VolunteerProfile{" +
        "id=" + id +
        ", userId=" + userId +
        ", fullName='" + fullName + '\'' +
        ", volunteerStatus='" + volunteerStatus + '\'' +
        ", taskCount=" + taskCount +
        ", serviceHours=" + serviceHours +
        '}';
  }
}
