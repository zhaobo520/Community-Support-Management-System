package com.community.domain;

import java.util.Date;

/**
 * Volunteer Skill Entity
 */
public class VolunteerSkill {
    
    private Long id;
    private Long userId;              // Volunteer ID
    private Long skillId;             // Skill ID
    private String proficiencyLevel;  // Proficiency level
    private Integer yearsExperience;  // Years of experience
    private String certification;     // Certification
    private Date createdAt;
    
    // Associated objects
    private Skill skill;              // Skill object
    private String userName;          // User name (for display)
    
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
    
    public Long getSkillId() {
        return skillId;
    }
    
    public void setSkillId(Long skillId) {
        this.skillId = skillId;
    }
    
    public String getProficiencyLevel() {
        return proficiencyLevel;
    }
    
    public void setProficiencyLevel(String proficiencyLevel) {
        this.proficiencyLevel = proficiencyLevel;
    }
    
    public Integer getYearsExperience() {
        return yearsExperience;
    }
    
    public void setYearsExperience(Integer yearsExperience) {
        this.yearsExperience = yearsExperience;
    }
    
    public String getCertification() {
        return certification;
    }
    
    public void setCertification(String certification) {
        this.certification = certification;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    public Skill getSkill() {
        return skill;
    }
    
    public void setSkill(Skill skill) {
        this.skill = skill;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
}
