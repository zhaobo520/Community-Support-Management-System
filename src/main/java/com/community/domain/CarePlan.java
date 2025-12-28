package com.community.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 关爱计划实体类
 * 业务流程：家属发布 -> 管理员审核 -> 志愿者接单 -> 提交服务记录 -> 管理员审核记录
 */
public class CarePlan implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long familyUserId;
    private Long elderlyId;
    private String planName;
    private String description;
    private String serviceType;
    private String serviceFrequency;
    private Date startDate;
    private Date endDate;
    private String status;  // ACTIVE-进行中, COMPLETED-已完成, CANCELLED-已取消

    // 审核相关字段
    private String auditStatus;  // PENDING-待审核, APPROVED-已通过, REJECTED-已拒绝
    private Long auditBy;
    private Date auditTime;
    private String auditRemark;

    // 认领相关字段
    private String claimStatus;  // UNCLAIMED-待认领, CLAIMED-已认领
    private Long assignedVolunteerId;
    private Date claimedTime;

    // 周期相关字段
    private String periodType;  // DAILY-每日, WEEKLY-每周, MONTHLY-每月
    private Integer servicesPerPeriod;  // 每周期服务次数
    private Integer totalPeriods;  // 总周期数
    private Integer currentPeriod;  // 当前周期

    // 统计字段
    private Integer totalServices;
    private Integer completedServices;
    private Integer approvedServices;  // 已审核通过的服务次数

    private Date createdAt;
    private Date updatedAt;
    private Long createdBy;

    // 关联对象
    private User volunteer;
    private String volunteerName;
    private String volunteerPhone;
    private String volunteerAvatar;
    private String familyName;
    private String familyPhone;
    private String elderlyName;
    private Integer elderlyAge;
    private String elderlyAddress;
    private String auditorName;

    // 周期列表
    private List<CarePlanPeriod> periods;
    // 服务记录列表
    private List<CarePlanServiceRecord> serviceRecords;

    public CarePlan() {
    }

    // ========== Getters and Setters ==========

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

    public Long getElderlyId() {
        return elderlyId;
    }

    public void setElderlyId(Long elderlyId) {
        this.elderlyId = elderlyId;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getServiceFrequency() {
        return serviceFrequency;
    }

    public void setServiceFrequency(String serviceFrequency) {
        this.serviceFrequency = serviceFrequency;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getClaimStatus() {
        return claimStatus;
    }

    public void setClaimStatus(String claimStatus) {
        this.claimStatus = claimStatus;
    }

    public Long getAssignedVolunteerId() {
        return assignedVolunteerId;
    }

    public void setAssignedVolunteerId(Long assignedVolunteerId) {
        this.assignedVolunteerId = assignedVolunteerId;
    }

    public Date getClaimedTime() {
        return claimedTime;
    }

    public void setClaimedTime(Date claimedTime) {
        this.claimedTime = claimedTime;
    }

    public String getPeriodType() {
        return periodType;
    }

    public void setPeriodType(String periodType) {
        this.periodType = periodType;
    }

    public Integer getServicesPerPeriod() {
        return servicesPerPeriod;
    }

    public void setServicesPerPeriod(Integer servicesPerPeriod) {
        this.servicesPerPeriod = servicesPerPeriod;
    }

    public Integer getTotalPeriods() {
        return totalPeriods;
    }

    public void setTotalPeriods(Integer totalPeriods) {
        this.totalPeriods = totalPeriods;
    }

    public Integer getCurrentPeriod() {
        return currentPeriod;
    }

    public void setCurrentPeriod(Integer currentPeriod) {
        this.currentPeriod = currentPeriod;
    }

    public Integer getTotalServices() {
        return totalServices;
    }

    public void setTotalServices(Integer totalServices) {
        this.totalServices = totalServices;
    }

    public Integer getCompletedServices() {
        return completedServices;
    }

    public void setCompletedServices(Integer completedServices) {
        this.completedServices = completedServices;
    }

    public Integer getApprovedServices() {
        return approvedServices;
    }

    public void setApprovedServices(Integer approvedServices) {
        this.approvedServices = approvedServices;
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

    public Long getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
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

    public String getVolunteerPhone() {
        return volunteerPhone;
    }

    public void setVolunteerPhone(String volunteerPhone) {
        this.volunteerPhone = volunteerPhone;
    }

    public String getVolunteerAvatar() {
        return volunteerAvatar;
    }

    public void setVolunteerAvatar(String volunteerAvatar) {
        this.volunteerAvatar = volunteerAvatar;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getFamilyPhone() {
        return familyPhone;
    }

    public void setFamilyPhone(String familyPhone) {
        this.familyPhone = familyPhone;
    }

    public String getElderlyName() {
        return elderlyName;
    }

    public void setElderlyName(String elderlyName) {
        this.elderlyName = elderlyName;
    }

    public Integer getElderlyAge() {
        return elderlyAge;
    }

    public void setElderlyAge(Integer elderlyAge) {
        this.elderlyAge = elderlyAge;
    }

    public String getElderlyAddress() {
        return elderlyAddress;
    }

    public void setElderlyAddress(String elderlyAddress) {
        this.elderlyAddress = elderlyAddress;
    }

    public String getAuditorName() {
        return auditorName;
    }

    public void setAuditorName(String auditorName) {
        this.auditorName = auditorName;
    }

    public List<CarePlanPeriod> getPeriods() {
        return periods;
    }

    public void setPeriods(List<CarePlanPeriod> periods) {
        this.periods = periods;
    }

    public List<CarePlanServiceRecord> getServiceRecords() {
        return serviceRecords;
    }

    public void setServiceRecords(List<CarePlanServiceRecord> serviceRecords) {
        this.serviceRecords = serviceRecords;
    }

    // ========== 计算方法 ==========

    /**
     * 计算总体进度百分比（基于已审核通过的服务）
     */
    public int getProgressPercentage() {
        if (totalServices == null || totalServices == 0) {
            return 0;
        }
        int approved = approvedServices != null ? approvedServices : 0;
        return (int) ((approved * 100.0) / totalServices);
    }

    /**
     * 计算已提交进度百分比（包含待审核的）
     */
    public int getSubmittedPercentage() {
        if (totalServices == null || totalServices == 0) {
            return 0;
        }
        int completed = completedServices != null ? completedServices : 0;
        return (int) ((completed * 100.0) / totalServices);
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
     * 获取认领状态显示文本
     */
    public String getClaimStatusText() {
        if (claimStatus == null) return "待认领";
        switch (claimStatus) {
            case "UNCLAIMED": return "待认领";
            case "CLAIMED": return "已认领";
            default: return claimStatus;
        }
    }

    /**
     * 获取状态显示文本
     */
    public String getStatusText() {
        if (status == null) return "未知";
        switch (status) {
            case "DRAFT": return "待审核";
            case "ACTIVE": return "进行中";
            case "COMPLETED": return "已完成";
            case "CANCELLED": return "已取消";
            default: return status;
        }
    }

    /**
     * 获取周期类型显示文本
     */
    public String getPeriodTypeText() {
        if (periodType == null) return "每周";
        switch (periodType) {
            case "DAILY": return "每日";
            case "WEEKLY": return "每周";
            case "MONTHLY": return "每月";
            default: return periodType;
        }
    }

    /**
     * 判断是否可以被认领
     */
    public boolean isClaimable() {
        return "APPROVED".equals(auditStatus) && "UNCLAIMED".equals(claimStatus) && "ACTIVE".equals(status);
    }

    @Override
    public String toString() {
        return "CarePlan{" +
                "id=" + id +
                ", planName='" + planName + '\'' +
                ", status='" + status + '\'' +
                ", auditStatus='" + auditStatus + '\'' +
                ", claimStatus='" + claimStatus + '\'' +
                '}';
    }
}
