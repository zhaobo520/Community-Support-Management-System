package com.community.service.impl;

import com.community.dao.SystemConfigMapper;
import com.community.domain.SystemConfig;
import com.community.service.SystemConfigService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * 系统配置服务实现
 */
@Service
public class SystemConfigServiceImpl implements SystemConfigService {
    
    private static final Logger log = LoggerFactory.getLogger(SystemConfigServiceImpl.class);
    
    @Resource
    private SystemConfigMapper systemConfigMapper;
    
    // 配置缓存
    private final Map<String, String> configCache = new ConcurrentHashMap<>();
    
    @Override
    public Map<String, List<SystemConfig>> getAllConfigsGrouped() {
        List<SystemConfig> allConfigs = systemConfigMapper.findAll();
        return allConfigs.stream()
                .collect(Collectors.groupingBy(SystemConfig::getCategory));
    }
    
    @Override
    public String getConfigValue(String configKey) {
        return getConfigValue(configKey, null);
    }
    
    @Override
    public String getConfigValue(String configKey, String defaultValue) {
        // 先从缓存获取
        if (configCache.containsKey(configKey)) {
            return configCache.get(configKey);
        }
        
        // 从数据库获取
        SystemConfig config = systemConfigMapper.findByKey(configKey);
        if (config != null && config.getConfigValue() != null) {
            configCache.put(configKey, config.getConfigValue());
            return config.getConfigValue();
        }
        
        return defaultValue;
    }
    
    @Override
    public Integer getIntValue(String configKey, Integer defaultValue) {
        String value = getConfigValue(configKey);
        if (value == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            log.warn("配置值无法转换为整数: {} = {}", configKey, value);
            return defaultValue;
        }
    }
    
    @Override
    public Boolean getBooleanValue(String configKey, Boolean defaultValue) {
        String value = getConfigValue(configKey);
        if (value == null) {
            return defaultValue;
        }
        return "true".equalsIgnoreCase(value) || "1".equals(value);
    }
    
    @Override
    public boolean updateConfig(String configKey, String configValue, String updatedBy) {
        SystemConfig config = systemConfigMapper.findByKey(configKey);
        if (config == null) {
            return false;
        }
        
        config.setConfigValue(configValue);
        config.setUpdatedBy(updatedBy);
        
        int rows = systemConfigMapper.update(config);
        if (rows > 0) {
            // 更新缓存
            configCache.put(configKey, configValue);
            log.info("配置已更新: {} = {} (操作人: {})", configKey, configValue, updatedBy);
            return true;
        }
        return false;
    }
    
    @Override
    public boolean batchUpdateConfigs(List<SystemConfig> configs, String updatedBy) {
        if (configs == null || configs.isEmpty()) {
            return false;
        }
        
        for (SystemConfig config : configs) {
            config.setUpdatedBy(updatedBy);
            updateConfig(config.getConfigKey(), config.getConfigValue(), updatedBy);
        }
        
        log.info("批量更新配置成功，共{}条 (操作人: {})", configs.size(), updatedBy);
        return true;
    }
    
    @Override
    public boolean addConfig(SystemConfig config) {
        try {
            int rows = systemConfigMapper.insert(config);
            if (rows > 0) {
                log.info("新增配置: {}", config.getConfigKey());
                return true;
            }
        } catch (Exception e) {
            log.error("新增配置失败", e);
        }
        return false;
    }
    
    @Override
    public boolean deleteConfig(Long id) {
        try {
            int rows = systemConfigMapper.deleteById(id);
            if (rows > 0) {
                // 清除缓存
                refreshCache();
                log.info("删除配置: ID={}", id);
                return true;
            }
        } catch (Exception e) {
            log.error("删除配置失败", e);
        }
        return false;
    }
    
    @Override
    public void refreshCache() {
        configCache.clear();
        log.info("配置缓存已刷新");
    }
}
