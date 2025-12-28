package com.community.dao;

import com.community.domain.SystemConfig;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 系统配置Mapper接口
 */
public interface SystemConfigMapper {
    
    /**
     * 查询所有配置
     */
    List<SystemConfig> findAll();
    
    /**
     * 按分类查询配置
     */
    List<SystemConfig> findByCategory(@Param("category") String category);
    
    /**
     * 根据配置键查询
     */
    SystemConfig findByKey(@Param("configKey") String configKey);
    
    /**
     * 查询公开配置
     */
    List<SystemConfig> findPublicConfigs();
    
    /**
     * 插入配置
     */
    int insert(SystemConfig config);
    
    /**
     * 更新配置
     */
    int update(SystemConfig config);
    
    /**
     * 根据ID删除
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 批量更新配置值
     */
    int batchUpdateValue(@Param("configs") List<SystemConfig> configs);
}
