package com.community.domain;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Permission implements Serializable {
  private Long id;
  private String permCode;
  private String permName;
  private String url;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Permission() {
  }

  public Permission(Long id, String permCode, String permName, String url,
                    LocalDateTime createdAt, LocalDateTime updatedAt) {
    this.id = id;
    this.permCode = permCode;
    this.permName = permName;
    this.url = url;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getPermCode() {
    return permCode;
  }

  public void setPermCode(String permCode) {
    this.permCode = permCode;
  }

  public String getPermName() {
    return permName;
  }

  public void setPermName(String permName) {
    this.permName = permName;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
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
    return "Permission{" +
        "id=" + id +
        ", permCode='" + permCode + '\'' +
        ", permName='" + permName + '\'' +
        ", url='" + url + '\'' +
        ", createdAt=" + createdAt +
        ", updatedAt=" + updatedAt +
        '}';
  }
}
