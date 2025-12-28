package com.community.domain;

import java.util.Date;

/**
 * Badge Entity
 */
public class Badge {
    
    private Long id;
    private String badgeCode;
    private String badgeName;
    private String badgeIcon;
    private String description;
    private String unlockCondition;
    private String conditionType;
    private Integer conditionValue;
    private Integer level;
    private Date createdAt;
    
    // Whether earned (used in associated queries)
    private Boolean earned;
    private Date earnedAt;
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getBadgeCode() {
        return badgeCode;
    }
    
    public void setBadgeCode(String badgeCode) {
        this.badgeCode = badgeCode;
    }
    
    public String getBadgeName() {
        return badgeName;
    }
    
    public void setBadgeName(String badgeName) {
        this.badgeName = badgeName;
    }
    
    public String getBadgeIcon() {
        return badgeIcon;
    }
    
    public void setBadgeIcon(String badgeIcon) {
        this.badgeIcon = badgeIcon;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getUnlockCondition() {
        return unlockCondition;
    }
    
    public void setUnlockCondition(String unlockCondition) {
        this.unlockCondition = unlockCondition;
    }
    
    public String getConditionType() {
        return conditionType;
    }
    
    public void setConditionType(String conditionType) {
        this.conditionType = conditionType;
    }
    
    public Integer getConditionValue() {
        return conditionValue;
    }
    
    public void setConditionValue(Integer conditionValue) {
        this.conditionValue = conditionValue;
    }
    
    public Integer getLevel() {
        return level;
    }
    
    public void setLevel(Integer level) {
        this.level = level;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Boolean getEarned() {
        return earned;
    }
    
    public void setEarned(Boolean earned) {
        this.earned = earned;
    }
    
    public Date getEarnedAt() {
        return earnedAt;
    }
    
    public void setEarnedAt(Date earnedAt) {
        this.earnedAt = earnedAt;
    }
    
    @Override
    public String toString() {
        return "Badge{" +
                "id=" + id +
                ", badgeCode='" + badgeCode + '\'' +
                ", badgeName='" + badgeName + '\'' +
                ", badgeIcon='" + badgeIcon + '\'' +
                ", description='" + description + '\'' +
                ", unlockCondition='" + unlockCondition + '\'' +
                ", conditionType='" + conditionType + '\'' +
                ", conditionValue=" + conditionValue +
                ", level=" + level +
                ", createdAt=" + createdAt +
                ", earned=" + earned +
                ", earnedAt=" + earnedAt +
                '}';
    }
}
