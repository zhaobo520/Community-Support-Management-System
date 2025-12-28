package com.community.service;

import com.community.domain.SystemLog;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 系统日志服务接口
 */
public interface SystemLogService {
    
    /**
     * 记录配置变更日志
     */
    void logConfigChange(Long operatorId, String operatorName, String configKey, 
                         String oldValue, String newValue, String ipAddress);
    
    /**
     * 记录登录日志
     */
    void logLogin(Long userId, String username, String ipAddress, boolean success);
    
    /**
     * 记录操作日志
     */
    void logOperation(String operation, Long operatorId, String operatorName, 
                      String content, String ipAddress);
    
    /**
     * 获取所有日志
     */
    List<SystemLog> getAllLogs();
    
    /**
     * 按类型获取日志
     */
    List<SystemLog> getLogsByType(String logType);
    
    /**
     * 按操作人获取日志
     */
    List<SystemLog> getLogsByOperator(Long operatorId);
    
    /**
     * 按时间范围获取日志
     */
    List<SystemLog> getLogsByDateRange(Date startDate, Date endDate);
    
    /**
     * 分页获取日志
     */
    List<SystemLog> getLogsByPage(Integer page, Integer pageSize);
    
    /**
     * 获取日志统计信息
     */
    Map<String, Object> getLogStatistics();
    
    /**
     * 清理旧日志
     */
    int cleanOldLogs(Integer days);
    
    /**
     * 清空所有日志
     */
    int clearAllLogs();
}
