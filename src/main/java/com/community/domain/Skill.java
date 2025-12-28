package com.community.domain;

import java.util.Date;

/**
 * Skill Entity
 */
public class Skill {
    
    private Long id;
    private String skillName;      // Skill name
    private String skillCode;      // Skill code
    private String category;       // Category
    private String description;    // Description
    private String icon;           // Icon
    private Integer sortOrder;     // Sort order
    private Integer isActive;      // Is active
    private Date createdAt;
    private Date updatedAt;
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getSkillName() {
        return skillName;
    }
    
    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }
    
    public String getSkillCode() {
        return skillCode;
    }
    
    public void setSkillCode(String skillCode) {
        this.skillCode = skillCode;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getIcon() {
        return icon;
    }
    
    public void setIcon(String icon) {
        this.icon = icon;
    }
    
    public Integer getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
    
    public Integer getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Integer isActive) {
        this.isActive = isActive;
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
}
