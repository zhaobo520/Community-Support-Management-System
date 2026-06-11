package com.community.domain;

import java.io.Serializable;
import java.util.Date;

/**
 * 系统文件实体 - 存储上传的文件到数据库
 */
public class SysFile implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String originalName;
    private String contentType;
    private Long fileSize;
    private byte[] fileData;
    private Long uploadBy;
    private Date createdAt;

    public SysFile() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOriginalName() { return originalName; }
    public void setOriginalName(String originalName) { this.originalName = originalName; }

    public String getContentType() { return contentType; }
    public void setContentType(String contentType) { this.contentType = contentType; }

    public Long getFileSize() { return fileSize; }
    public void setFileSize(Long fileSize) { this.fileSize = fileSize; }

    public byte[] getFileData() { return fileData; }
    public void setFileData(byte[] fileData) { this.fileData = fileData; }

    public Long getUploadBy() { return uploadBy; }
    public void setUploadBy(Long uploadBy) { this.uploadBy = uploadBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
