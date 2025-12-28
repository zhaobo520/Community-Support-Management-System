package com.community.service;

import com.community.domain.SystemConfig;

import java.util.List;
import java.util.Map;

/**
 * 系统配置服务接口
 */
public interface SystemConfigService {
    
    /**
     * 获取所有配置（按分类分组）
     */
    Map<String, List<SystemConfig>> getAllConfigsGrouped();
    
    /**
     * 根据键获取配置值
     */
    String getConfigValue(String configKey);
    
    /**
     * 根据键获取配置值（带默认值）
     */
    String getConfigValue(String configKey, String defaultValue);
    
    /**
     * 获取整数配置值
     */
    Integer getIntValue(String configKey, Integer defaultValue);
    
    /**
     * 获取布尔配置值
     */
    Boolean getBooleanValue(String configKey, Boolean defaultValue);
    
    /**
     * 更新配置
     */
    boolean updateConfig(String configKey, String configValue, String updatedBy);
    
    /**
     * 批量更新配置
     */
    boolean batchUpdateConfigs(List<SystemConfig> configs, String updatedBy);
    
    /**
     * 新增配置
     */
    boolean addConfig(SystemConfig config);
    
    /**
     * 删除配置
     */
    boolean deleteConfig(Long id);
    
    /**
     * 刷新配置缓存
     */
    void refreshCache();
}
