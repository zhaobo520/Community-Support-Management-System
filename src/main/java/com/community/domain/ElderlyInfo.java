package com.community.domain;

import org.springframework.format.annotation.DateTimeFormat;

import java.io.Serializable;
import java.util.Date;

/**
 * Elderly Info Entity
 */
public class ElderlyInfo implements Serializable {
  private static final long serialVersionUID = 1L;

  private Long id;
  private String name;
  private String idCard;
  private String gender;  // MALE, FEMALE
  
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private Date birthDate;
  private Integer age;
  private String phone;
  private String address;
  private String healthStatus;
  private String disabilityLevel;
  private Integer livingAlone;  // 1=yes 0=no
  private String familyContact;
  private String familyPhone;
  private String specialNeeds;
  private String careLevel;  // LOW, MEDIUM, HIGH, URGENT
  private String photoUrl;   // 关爱对象照片URL
  private Integer status;  // 1=active 0=inactive
  private Long familyUserId;  // 关联家属用户ID
  private String auditStatus;  // 审核状态：PENDING待审核 APPROVED已通过 REJECTED已拒绝
  private Date auditTime;  // 审核时间
  private Long auditBy;  // 审核人ID
  private String auditRemark;  // 审核备注
  private Long createdBy;
  private Date createdTime;
  private Date updatedTime;

  public ElderlyInfo() {
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getHealthStatus() {
    return healthStatus;
  }

  public void setHealthStatus(String healthStatus) {
    this.healthStatus = healthStatus;
  }

  public String getDisabilityLevel() {
    return disabilityLevel;
  }

  public void setDisabilityLevel(String disabilityLevel) {
    this.disabilityLevel = disabilityLevel;
  }

  public Integer getLivingAlone() {
    return livingAlone;
  }

  public void setLivingAlone(Integer livingAlone) {
    this.livingAlone = livingAlone;
  }

  public String getFamilyContact() {
    return familyContact;
  }

  public void setFamilyContact(String familyContact) {
    this.familyContact = familyContact;
  }

  public String getFamilyPhone() {
    return familyPhone;
  }

  public void setFamilyPhone(String familyPhone) {
    this.familyPhone = familyPhone;
  }

  public String getSpecialNeeds() {
    return specialNeeds;
  }

  public void setSpecialNeeds(String specialNeeds) {
    this.specialNeeds = specialNeeds;
  }

  public String getCareLevel() {
    return careLevel;
  }

  public void setCareLevel(String careLevel) {
    this.careLevel = careLevel;
  }

  public String getPhotoUrl() {
    return photoUrl;
  }

  public void setPhotoUrl(String photoUrl) {
    this.photoUrl = photoUrl;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public Long getFamilyUserId() {
    return familyUserId;
  }

  public void setFamilyUserId(Long familyUserId) {
    this.familyUserId = familyUserId;
  }

  public String getAuditStatus() {
    return auditStatus;
  }

  public void setAuditStatus(String auditStatus) {
    this.auditStatus = auditStatus;
  }

  public Date getAuditTime() {
    return auditTime;
  }

  public void setAuditTime(Date auditTime) {
    this.auditTime = auditTime;
  }

  public Long getAuditBy() {
    return auditBy;
  }

  public void setAuditBy(Long auditBy) {
    this.auditBy = auditBy;
  }

  public String getAuditRemark() {
    return auditRemark;
  }

  public void setAuditRemark(String auditRemark) {
    this.auditRemark = auditRemark;
  }

  public Long getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(Long createdBy) {
    this.createdBy = createdBy;
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
    return "ElderlyInfo{" +
        "id=" + id +
        ", name='" + name + '\'' +
        ", idCard='" + idCard + '\'' +
        ", gender='" + gender + '\'' +
        ", birthDate=" + birthDate +
        ", age=" + age +
        ", phone='" + phone + '\'' +
        ", address='" + address + '\'' +
        ", careLevel='" + careLevel + '\'' +
        ", photoUrl='" + photoUrl + '\'' +
        ", status=" + status +
        '}';
  }
}
