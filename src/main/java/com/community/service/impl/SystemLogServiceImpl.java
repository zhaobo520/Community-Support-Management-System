package com.community.service.impl;

import com.community.dao.SystemLogMapper;
import com.community.domain.SystemLog;
import com.community.service.SystemLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统日志服务实现
 */
@Service
public class SystemLogServiceImpl implements SystemLogService {
    
    private static final Logger log = LoggerFactory.getLogger(SystemLogServiceImpl.class);
    
    @Resource
    private SystemLogMapper systemLogMapper;
    
    @Override
    @Async
    public void logConfigChange(Long operatorId, String operatorName, String configKey,
                                 String oldValue, String newValue, String ipAddress) {
        SystemLog systemLog = new SystemLog();
        systemLog.setLogType("CONFIG_CHANGE");
        systemLog.setOperation("更新配置");
        systemLog.setOperatorId(operatorId);
        systemLog.setOperatorName(operatorName);
        systemLog.setContent(String.format("配置项[%s]由[%s]修改为[%s]", configKey, oldValue, newValue));
        systemLog.setIpAddress(ipAddress);
        
        try {
            systemLogMapper.insert(systemLog);
            log.info("记录配置变更日志: {}", configKey);
        } catch (Exception e) {
            log.error("记录配置变更日志失败", e);
        }
    }
    
    @Override
    @Async
    public void logLogin(Long userId, String username, String ipAddress, boolean success) {
        SystemLog systemLog = new SystemLog();
        systemLog.setLogType("LOGIN");
        systemLog.setOperation(success ? "登录成功" : "登录失败");
        systemLog.setOperatorId(userId);
        systemLog.setOperatorName(username);
        systemLog.setContent(success ? "用户登录成功" : "用户登录失败");
        systemLog.setIpAddress(ipAddress);
        
        try {
            systemLogMapper.insert(systemLog);
            log.info("记录登录日志: {} - {}", username, success ? "成功" : "失败");
        } catch (Exception e) {
            log.error("记录登录日志失败", e);
        }
    }
    
    @Override
    @Async
    public void logOperation(String operation, Long operatorId, String operatorName,
                             String content, String ipAddress) {
        SystemLog systemLog = new SystemLog();
        systemLog.setLogType("OPERATION");
        systemLog.setOperation(operation);
        systemLog.setOperatorId(operatorId);
        systemLog.setOperatorName(operatorName);
        systemLog.setContent(content);
        systemLog.setIpAddress(ipAddress);
        
        try {
            systemLogMapper.insert(systemLog);
            log.info("记录操作日志: {}", operation);
        } catch (Exception e) {
            log.error("记录操作日志失败", e);
        }
    }
    
    @Override
    public List<SystemLog> getAllLogs() {
        return systemLogMapper.findAll();
    }
    
    @Override
    public List<SystemLog> getLogsByType(String logType) {
        return systemLogMapper.findByType(logType);
    }
    
    @Override
    public List<SystemLog> getLogsByOperator(Long operatorId) {
        return systemLogMapper.findByOperator(operatorId);
    }
    
    @Override
    public List<SystemLog> getLogsByDateRange(Date startDate, Date endDate) {
        return systemLogMapper.findByDateRange(startDate, endDate);
    }
    
    @Override
    public List<SystemLog> getLogsByPage(Integer page, Integer pageSize) {
        int offset = (page - 1) * pageSize;
        return systemLogMapper.findByPage(offset, pageSize);
    }
    
    @Override
    public Map<String, Object> getLogStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalLogs", systemLogMapper.countAll());
        stats.put("configChangeLogs", systemLogMapper.countByType("CONFIG_CHANGE"));
        stats.put("loginLogs", systemLogMapper.countByType("LOGIN"));
        stats.put("operationLogs", systemLogMapper.countByType("OPERATION"));
        
        return stats;
    }
    
    @Override
    public int cleanOldLogs(Integer days) {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_YEAR, -days);
        Date cutoffDate = calendar.getTime();
        
        int deletedCount = systemLogMapper.deleteByDateBefore(cutoffDate);
        log.info("清理{}天前的日志，共删除{}条", days, deletedCount);
        
        return deletedCount;
    }
    
    @Override
    public int clearAllLogs() {
        int deletedCount = systemLogMapper.deleteAll();
        log.warn("清空所有日志，共删除{}条", deletedCount);
        
        return deletedCount;
    }
}
