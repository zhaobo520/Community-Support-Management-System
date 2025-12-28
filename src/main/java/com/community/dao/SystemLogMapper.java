package com.community.dao;

import com.community.domain.SystemLog;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 系统日志Mapper接口
 */
public interface SystemLogMapper {
    
    /**
     * 插入日志
     */
    int insert(SystemLog log);
    
    /**
     * 查询所有日志
     */
    List<SystemLog> findAll();
    
    /**
     * 按类型查询日志
     */
    List<SystemLog> findByType(@Param("logType") String logType);
    
    /**
     * 按操作人查询日志
     */
    List<SystemLog> findByOperator(@Param("operatorId") Long operatorId);
    
    /**
     * 按时间范围查询日志
     */
    List<SystemLog> findByDateRange(@Param("startDate") Date startDate, 
                                     @Param("endDate") Date endDate);
    
    /**
     * 分页查询日志
     */
    List<SystemLog> findByPage(@Param("offset") Integer offset, 
                                @Param("limit") Integer limit);
    
    /**
     * 统计日志数量
     */
    Long countAll();
    
    /**
     * 按类型统计数量
     */
    Long countByType(@Param("logType") String logType);
    
    /**
     * 删除指定日期之前的日志
     */
    int deleteByDateBefore(@Param("date") Date date);
    
    /**
     * 清空所有日志
     */
    int deleteAll();
}
