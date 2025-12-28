package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * Notification Entity
 */
public class Notification implements Serializable {
  private static final long serialVersionUID = 1L;

  private Long id;
  private Long userId;           // User ID
  private String title;          // Title
  private String content;        // Content
  private String type;           // Type
  private String relatedType;    // Related type
  private Long relatedId;        // Related ID
  private Integer isRead;        // Is read
  private Date readTime;         // Read time
  private Date createdTime;      // Created time

  public Notification() {
  }

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

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getRelatedType() {
    return relatedType;
  }

  public void setRelatedType(String relatedType) {
    this.relatedType = relatedType;
  }

  public Long getRelatedId() {
    return relatedId;
  }

  public void setRelatedId(Long relatedId) {
    this.relatedId = relatedId;
  }

  public Integer getIsRead() {
    return isRead;
  }

  public void setIsRead(Integer isRead) {
    this.isRead = isRead;
  }

  public Date getReadTime() {
    return readTime;
  }

  public void setReadTime(Date readTime) {
    this.readTime = readTime;
  }

  public Date getCreatedTime() {
    return createdTime;
  }

  public void setCreatedTime(Date createdTime) {
    this.createdTime = createdTime;
  }

  @Override
  public String toString() {
    return "Notification{" +
        "id=" + id +
        ", userId=" + userId +
        ", title='" + title + '\'' +
        ", content='" + content + '\'' +
        ", type='" + type + '\'' +
        ", relatedType='" + relatedType + '\'' +
        ", relatedId=" + relatedId +
        ", isRead=" + isRead +
        ", readTime=" + readTime +
        ", createdTime=" + createdTime +
        '}';
  }
}
