package com.community.dto;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * 统计数据传输对象
 */
public class StatisticsDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    // 需求统计
    private Long totalDemands;
    private Long pendingDemands;
    private Long approvedDemands;
    private Long rejectedDemands;
    private Long matchedDemands;
    private Long closedDemands;

    // 任务统计
    private Long totalTasks;
    private Long pendingTasks;
    private Long claimedTasks;
    private Long inProgressTasks;
    private Long completedTasks;
    private Long approvedTasks;
    private Long cancelledTasks;

    // 志愿者统计
    private Long totalVolunteers;
    private Long activeVolunteers;
    private Long pendingVolunteers;
    private Long approvedVolunteers;
    private Long rejectedVolunteers;

    // 关爱对象统计
    private Long totalElderly;
    private Long activeElderly;
    private Long inactiveElderly;

    // 用户统计
    private Long totalUsers;
    private Long familyUsers;
    private Long staffUsers;
    private Long volunteerUsers;

    // 服务统计
    private Long totalServices;
    private Double averageRating;
    private Long totalServiceHours;

    // 按类型统计（JSON格式）
    private Map<String, Long> demandsByType;
    private Map<String, Long> tasksByType;
    private Map<String, Long> elderlyByCareLevel;

    public StatisticsDTO() {
        this.demandsByType = new HashMap<>();
        this.tasksByType = new HashMap<>();
        this.elderlyByCareLevel = new HashMap<>();
    }

    // Getters and Setters

    public Long getTotalDemands() {
        return totalDemands;
    }

    public void setTotalDemands(Long totalDemands) {
        this.totalDemands = totalDemands;
    }

    public Long getPendingDemands() {
        return pendingDemands;
    }

    public void setPendingDemands(Long pendingDemands) {
        this.pendingDemands = pendingDemands;
    }

    public Long getApprovedDemands() {
        return approvedDemands;
    }

    public void setApprovedDemands(Long approvedDemands) {
        this.approvedDemands = approvedDemands;
    }

    public Long getRejectedDemands() {
        return rejectedDemands;
    }

    public void setRejectedDemands(Long rejectedDemands) {
        this.rejectedDemands = rejectedDemands;
    }

    public Long getMatchedDemands() {
        return matchedDemands;
    }

    public void setMatchedDemands(Long matchedDemands) {
        this.matchedDemands = matchedDemands;
    }

    public Long getClosedDemands() {
        return closedDemands;
    }

    public void setClosedDemands(Long closedDemands) {
        this.closedDemands = closedDemands;
    }

    public Long getTotalTasks() {
        return totalTasks;
    }

    public void setTotalTasks(Long totalTasks) {
        this.totalTasks = totalTasks;
    }

    public Long getPendingTasks() {
        return pendingTasks;
    }

    public void setPendingTasks(Long pendingTasks) {
        this.pendingTasks = pendingTasks;
    }

    public Long getClaimedTasks() {
        return claimedTasks;
    }

    public void setClaimedTasks(Long claimedTasks) {
        this.claimedTasks = claimedTasks;
    }

    public Long getInProgressTasks() {
        return inProgressTasks;
    }

    public void setInProgressTasks(Long inProgressTasks) {
        this.inProgressTasks = inProgressTasks;
    }

    public Long getCompletedTasks() {
        return completedTasks;
    }

    public void setCompletedTasks(Long completedTasks) {
        this.completedTasks = completedTasks;
    }

    public Long getApprovedTasks() {
        return approvedTasks;
    }

    public void setApprovedTasks(Long approvedTasks) {
        this.approvedTasks = approvedTasks;
    }

    public Long getCancelledTasks() {
        return cancelledTasks;
    }

    public void setCancelledTasks(Long cancelledTasks) {
        this.cancelledTasks = cancelledTasks;
    }

    public Long getTotalVolunteers() {
        return totalVolunteers;
    }

    public void setTotalVolunteers(Long totalVolunteers) {
        this.totalVolunteers = totalVolunteers;
    }

    public Long getActiveVolunteers() {
        return activeVolunteers;
    }

    public void setActiveVolunteers(Long activeVolunteers) {
        this.activeVolunteers = activeVolunteers;
    }

    public Long getPendingVolunteers() {
        return pendingVolunteers;
    }

    public void setPendingVolunteers(Long pendingVolunteers) {
        this.pendingVolunteers = pendingVolunteers;
    }

    public Long getApprovedVolunteers() {
        return approvedVolunteers;
    }

    public void setApprovedVolunteers(Long approvedVolunteers) {
        this.approvedVolunteers = approvedVolunteers;
    }

    public Long getRejectedVolunteers() {
        return rejectedVolunteers;
    }

    public void setRejectedVolunteers(Long rejectedVolunteers) {
        this.rejectedVolunteers = rejectedVolunteers;
    }

    public Long getTotalElderly() {
        return totalElderly;
    }

    public void setTotalElderly(Long totalElderly) {
        this.totalElderly = totalElderly;
    }

    public Long getActiveElderly() {
        return activeElderly;
    }

    public void setActiveElderly(Long activeElderly) {
        this.activeElderly = activeElderly;
    }

    public Long getInactiveElderly() {
        return inactiveElderly;
    }

    public void setInactiveElderly(Long inactiveElderly) {
        this.inactiveElderly = inactiveElderly;
    }

    public Long getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(Long totalUsers) {
        this.totalUsers = totalUsers;
    }

    public Long getFamilyUsers() {
        return familyUsers;
    }

    public void setFamilyUsers(Long familyUsers) {
        this.familyUsers = familyUsers;
    }

    public Long getStaffUsers() {
        return staffUsers;
    }

    public void setStaffUsers(Long staffUsers) {
        this.staffUsers = staffUsers;
    }

    public Long getVolunteerUsers() {
        return volunteerUsers;
    }

    public void setVolunteerUsers(Long volunteerUsers) {
        this.volunteerUsers = volunteerUsers;
    }

    public Long getTotalServices() {
        return totalServices;
    }

    public void setTotalServices(Long totalServices) {
        this.totalServices = totalServices;
    }

    public Double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(Double averageRating) {
        this.averageRating = averageRating;
    }

    public Long getTotalServiceHours() {
        return totalServiceHours;
    }

    public void setTotalServiceHours(Long totalServiceHours) {
        this.totalServiceHours = totalServiceHours;
    }

    public Map<String, Long> getDemandsByType() {
        return demandsByType;
    }

    public void setDemandsByType(Map<String, Long> demandsByType) {
        this.demandsByType = demandsByType;
    }

    public Map<String, Long> getTasksByType() {
        return tasksByType;
    }

    public void setTasksByType(Map<String, Long> tasksByType) {
        this.tasksByType = tasksByType;
    }

    public Map<String, Long> getElderlyByCareLevel() {
        return elderlyByCareLevel;
    }

    public void setElderlyByCareLevel(Map<String, Long> elderlyByCareLevel) {
        this.elderlyByCareLevel = elderlyByCareLevel;
    }

    @Override
    public String toString() {
        return "StatisticsDTO{" +
                "totalDemands=" + totalDemands +
                ", pendingDemands=" + pendingDemands +
                ", approvedDemands=" + approvedDemands +
                ", totalTasks=" + totalTasks +
                ", totalVolunteers=" + totalVolunteers +
                ", totalElderly=" + totalElderly +
                '}';
    }
}
