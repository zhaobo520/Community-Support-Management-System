package com.community.domain;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

public class User implements Serializable {
  private Long id;
  private String username;
  private String password;
  private String fullName;
  private String phone;
  private String email;
  private String avatar;
  private String roleType;
  private Integer status;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
  private List<Role> roles;
  private List<Permission> permissions;

  public User() {
  }

  public User(Long id, String username, String password, String fullName, String phone,
              String email, String roleType, Integer status,
              LocalDateTime createdAt, LocalDateTime updatedAt) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.fullName = fullName;
    this.phone = phone;
    this.email = email;
    this.roleType = roleType;
    this.status = status;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getFullName() {
    return fullName;
  }

  public void setFullName(String fullName) {
    this.fullName = fullName;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getAvatar() {
    return avatar;
  }

  public void setAvatar(String avatar) {
    this.avatar = avatar;
  }

  public String getRoleType() {
    return roleType;
  }

  public void setRoleType(String roleType) {
    this.roleType = roleType;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
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

  public List<Role> getRoles() {
    return roles;
  }

  public void setRoles(List<Role> roles) {
    this.roles = roles;
  }

  public List<Permission> getPermissions() {
    return permissions;
  }

  public void setPermissions(List<Permission> permissions) {
    this.permissions = permissions;
  }

  @Override
  public String toString() {
    return "User{" +
        "id=" + id +
        ", username='" + username + '\'' +
        ", fullName='" + fullName + '\'' +
        ", roleType='" + roleType + '\'' +
        ", status=" + status +
        '}';
  }
}
