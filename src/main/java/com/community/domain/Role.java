package com.community.domain;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Role implements Serializable {
  private Long id;
  private String roleCode;
  private String roleName;
  private String description;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Role() {
  }

  public Role(Long id, String roleCode, String roleName, String description,
              LocalDateTime createdAt, LocalDateTime updatedAt) {
    this.id = id;
    this.roleCode = roleCode;
    this.roleName = roleName;
    this.description = description;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getRoleCode() {
    return roleCode;
  }

  public void setRoleCode(String roleCode) {
    this.roleCode = roleCode;
  }

  public String getRoleName() {
    return roleName;
  }

  public void setRoleName(String roleName) {
    this.roleName = roleName;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

  @Override
  public String toString() {
    return "Role{" +
        "id=" + id +
        ", roleCode='" + roleCode + '\'' +
        ", roleName='" + roleName + '\'' +
        ", description='" + description + '\'' +
        ", createdAt=" + createdAt +
        ", updatedAt=" + updatedAt +
        '}';
  }
}
