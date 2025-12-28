package com.community.domain;

import java.io.Serializable;
import java.sql.Time;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * 关爱计划服务记录实体类
 */
public class CarePlanServiceRecord implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long planId;  // 关爱计划ID
    private Long volunteerId;
    private Integer periodNumber;  // 周期编号
    private Integer serviceNumber;  // 本周期第几次服务
    private Date serviceDate;
    private Time serviceTimeStart;
    private Time serviceTimeEnd;
    private String serviceContent;
    private String servicePhotos;  // 多个URL用逗号分隔
    private String elderlyCondition;  // 关爱对象状况描述
    private String remarks;
    private String auditStatus;  // PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝
    private Long auditBy;
    private Date auditTime;
    private String auditRemark;
    private Date createdAt;
    private Date updatedAt;

    // 关联对象
    private String volunteerName;
    private String volunteerAvatar;
    private String auditorName;
    private String planName;  // 计划名称
    private String elderlyName;  // 关爱对象姓名
    private CarePlan carePlan;

    public CarePlanServiceRecord() {
    }

    // ========== Getters and Setters ==========

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPlanId() {
        return planId;
    }

    public void setPlanId(Long planId) {
        this.planId = planId;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public Integer getPeriodNumber() {
        return periodNumber;
    }

    public void setPeriodNumber(Integer periodNumber) {
        this.periodNumber = periodNumber;
    }

    public Integer getServiceNumber() {
        return serviceNumber;
    }

    public void setServiceNumber(Integer serviceNumber) {
        this.serviceNumber = serviceNumber;
    }

    public Date getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(Date serviceDate) {
        this.serviceDate = serviceDate;
    }

    public Time getServiceTimeStart() {
        return serviceTimeStart;
    }

    public void setServiceTimeStart(Time serviceTimeStart) {
        this.serviceTimeStart = serviceTimeStart;
    }

    public Time getServiceTimeEnd() {
        return serviceTimeEnd;
    }

    public void setServiceTimeEnd(Time serviceTimeEnd) {
        this.serviceTimeEnd = serviceTimeEnd;
    }

    public String getServiceContent() {
        return serviceContent;
    }

    public void setServiceContent(String serviceContent) {
        this.serviceContent = serviceContent;
    }

    public String getServicePhotos() {
        return servicePhotos;
    }

    public void setServicePhotos(String servicePhotos) {
        this.servicePhotos = servicePhotos;
    }

    public String getElderlyCondition() {
        return elderlyCondition;
    }

    public void setElderlyCondition(String elderlyCondition) {
        this.elderlyCondition = elderlyCondition;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus) {
        this.auditStatus = auditStatus;
    }

    public Long getAuditBy() {
        return auditBy;
    }

    public void setAuditBy(Long auditBy) {
        this.auditBy = auditBy;
    }

    public Date getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(Date auditTime) {
        this.auditTime = auditTime;
    }

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
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

    public String getVolunteerAvatar() {
        return volunteerAvatar;
    }

    public void setVolunteerAvatar(String volunteerAvatar) {
        this.volunteerAvatar = volunteerAvatar;
    }

    public String getAuditorName() {
        return auditorName;
    }

    public void setAuditorName(String auditorName) {
        this.auditorName = auditorName;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public String getElderlyName() {
        return elderlyName;
    }

    public void setElderlyName(String elderlyName) {
        this.elderlyName = elderlyName;
    }

    public CarePlan getCarePlan() {
        return carePlan;
    }

    public void setCarePlan(CarePlan carePlan) {
        this.carePlan = carePlan;
    }

    // ========== 辅助方法 ==========

    /**
     * 获取照片列表
     */
    public List<String> getPhotoList() {
        if (servicePhotos == null || servicePhotos.trim().isEmpty()) {
            return Collections.emptyList();
        }
        return Arrays.asList(servicePhotos.split(","));
    }

    /**
     * 获取照片数量
     */
    public int getPhotoCount() {
        return getPhotoList().size();
    }

    /**
     * 获取审核状态显示文本
     */
    public String getAuditStatusText() {
        if (auditStatus == null) return "未知";
        switch (auditStatus) {
            case "PENDING": return "待审核";
            case "APPROVED": return "已通过";
            case "REJECTED": return "已拒绝";
            default: return auditStatus;
        }
    }

    /**
     * 是否待审核
     */
    public boolean isPending() {
        return "PENDING".equals(auditStatus);
    }

    /**
     * 是否已通过
     */
    public boolean isApproved() {
        return "APPROVED".equals(auditStatus);
    }

    /**
     * 是否已拒绝
     */
    public boolean isRejected() {
        return "REJECTED".equals(auditStatus);
    }

    @Override
    public String toString() {
        return "CarePlanServiceRecord{" +
                "id=" + id +
                ", planId=" + planId +
                ", periodNumber=" + periodNumber +
                ", serviceNumber=" + serviceNumber +
                ", auditStatus='" + auditStatus + '\'' +
                '}';
    }
}
