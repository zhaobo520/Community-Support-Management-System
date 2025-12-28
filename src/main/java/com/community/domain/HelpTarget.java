package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Entity
 */
public class HelpTarget implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String archiveNo;
    private String name;
    private String gender;
    private Integer age;
    private String specialCondition;
    private String familyAddress;
    private String contactPhone;
    private String region;
    private Integer status;
    private Date createdAt;
    private Date updatedAt;

    public HelpTarget() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getArchiveNo() {
        return archiveNo;
    }

    public void setArchiveNo(String archiveNo) {
        this.archiveNo = archiveNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getSpecialCondition() {
        return specialCondition;
    }

    public void setSpecialCondition(String specialCondition) {
        this.specialCondition = specialCondition;
    }

    public String getFamilyAddress() {
        return familyAddress;
    }

    public void setFamilyAddress(String familyAddress) {
        this.familyAddress = familyAddress;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
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

    @Override
    public String toString() {
        return "HelpTarget{" +
                "id=" + id +
                ", archiveNo='" + archiveNo + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", region='" + region + '\'' +
                '}';
    }
}
