package com.community.domain;

import java.util.Date;

/**
 * 积分记录实体类
 */
public class PointsRecord {

    /**
     * 积分记录ID
     */
    private Long id;

    /**
     * 用户ID
     */
    private Long userId;

    /**
     * 积分数（正数为奖励，负数为扣减）
     */
    private Integer points;

    /**
     * 操作后总积分
     */
    private Integer totalPoints;

    /**
     * 积分来源类型
     */
    private String sourceType;

    /**
     * 来源ID
     */
    private Long sourceId;

    /**
     * 积分原因说明
     */
    private String reason;

    /**
     * 创建时间
     */
    private Date createdAt;

    /**
     * 用户名（关联查询）
     */
    private String username;

    /**
     * 用户全名（关联查询）
     */
    private String fullName;

    // Getters and Setters

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

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public Long getSourceId() {
        return sourceId;
    }

    public void setSourceId(Long sourceId) {
        this.sourceId = sourceId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
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

    @Override
    public String toString() {
        return "PointsRecord{" +
                "id=" + id +
                ", userId=" + userId +
                ", points=" + points +
                ", totalPoints=" + totalPoints +
                ", sourceType='" + sourceType + '\'' +
                ", sourceId=" + sourceId +
                ", reason='" + reason + '\'' +
                ", createdAt=" + createdAt +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                '}';
    }
}
