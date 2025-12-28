package com.community.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 关爱计划周期实体类
 */
public class CarePlanPeriod implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long carePlanId;
    private Integer periodNumber;  // 周期编号
    private Date periodStartDate;
    private Date periodEndDate;
    private Integer requiredServices;  // 本周期需要完成的服务次数
    private Integer completedServices;  // 本周期已提交的服务次数
    private Integer approvedServices;  // 本周期已审核通过的服务次数
    private String status;  // PENDING-进行中, COMPLETED-已完成, OVERDUE-已逾期
    private Date createdAt;
    private Date updatedAt;

    // 关联对象
    private List<CarePlanServiceRecord> serviceRecords;

    public CarePlanPeriod() {
    }

    // ========== Getters and Setters ==========

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCarePlanId() {
        return carePlanId;
    }

    public void setCarePlanId(Long carePlanId) {
        this.carePlanId = carePlanId;
    }

    public Integer getPeriodNumber() {
        return periodNumber;
    }

    public void setPeriodNumber(Integer periodNumber) {
        this.periodNumber = periodNumber;
    }

    public Date getPeriodStartDate() {
        return periodStartDate;
    }

    public void setPeriodStartDate(Date periodStartDate) {
        this.periodStartDate = periodStartDate;
    }

    public Date getPeriodEndDate() {
        return periodEndDate;
    }

    public void setPeriodEndDate(Date periodEndDate) {
        this.periodEndDate = periodEndDate;
    }

    public Integer getRequiredServices() {
        return requiredServices;
    }

    public void setRequiredServices(Integer requiredServices) {
        this.requiredServices = requiredServices;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public List<CarePlanServiceRecord> getServiceRecords() {
        return serviceRecords;
    }

    public void setServiceRecords(List<CarePlanServiceRecord> serviceRecords) {
        this.serviceRecords = serviceRecords;
    }

    // ========== 辅助方法 ==========

    /**
     * 获取周期完成进度百分比
     */
    public int getProgressPercentage() {
        if (requiredServices == null || requiredServices == 0) {
            return 0;
        }
        int approved = approvedServices != null ? approvedServices : 0;
        return (int) ((approved * 100.0) / requiredServices);
    }

    /**
     * 获取状态显示文本
     */
    public String getStatusText() {
        if (status == null) return "进行中";
        switch (status) {
            case "PENDING": return "进行中";
            case "COMPLETED": return "已完成";
            case "OVERDUE": return "已逾期";
            default: return status;
        }
    }

    /**
     * 判断周期是否已完成
     */
    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }

    /**
     * 判断周期是否已逾期
     */
    public boolean isOverdue() {
        if ("OVERDUE".equals(status)) {
            return true;
        }
        // 如果结束日期已过且未完成，也算逾期
        if (periodEndDate != null && new Date().after(periodEndDate)) {
            int approved = approvedServices != null ? approvedServices : 0;
            int required = requiredServices != null ? requiredServices : 0;
            return approved < required;
        }
        return false;
    }

    @Override
    public String toString() {
        return "CarePlanPeriod{" +
                "id=" + id +
                ", carePlanId=" + carePlanId +
                ", periodNumber=" + periodNumber +
                ", status='" + status + '\'' +
                '}';
    }
}
