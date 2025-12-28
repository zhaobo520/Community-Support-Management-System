package com.community.domain;

import java.util.Date;

/**
 * System Log Entity
 */
public class SystemLog {
    
    private Long id;
    private String logType;         // CONFIG_CHANGE, LOGIN, OPERATION
    private String operation;       // Operation type
    private Long operatorId;        // Operator ID
    private String operatorName;    // Operator name
    private String content;         // Log content
    private String ipAddress;       // IP address
    private Date createdAt;         // Created time
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getLogType() {
        return logType;
    }
    
    public void setLogType(String logType) {
        this.logType = logType;
    }
    
    public String getOperation() {
        return operation;
    }
    
    public void setOperation(String operation) {
        this.operation = operation;
    }
    
    public Long getOperatorId() {
        return operatorId;
    }
    
    public void setOperatorId(Long operatorId) {
        this.operatorId = operatorId;
    }
    
    public String getOperatorName() {
        return operatorName;
    }
    
    public void setOperatorName(String operatorName) {
        this.operatorName = operatorName;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public Date getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "SystemLog{" +
                "id=" + id +
                ", logType='" + logType + '\'' +
                ", operation='" + operation + '\'' +
                ", operatorId=" + operatorId +
                ", operatorName='" + operatorName + '\'' +
                ", content='" + content + '\'' +
                ", ipAddress='" + ipAddress + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
