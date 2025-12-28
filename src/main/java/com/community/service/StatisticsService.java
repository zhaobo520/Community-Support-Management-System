package com.community.service;

import com.community.dto.DateRangeDTO;
import com.community.dto.StatisticsDTO;

/**
 * 统计服务接口
 */
public interface StatisticsService {

    /**
     * 获取综合统计数据
     */
    StatisticsDTO getOverallStatistics();

    /**
     * 获取综合统计数据（支持时间范围）
     */
    StatisticsDTO getOverallStatistics(DateRangeDTO dateRange);

    /**
     * 获取需求统计数据
     */
    StatisticsDTO getDemandStatistics();

    /**
     * 获取任务统计数据
     */
    StatisticsDTO getTaskStatistics();

    /**
     * 获取志愿者统计数据
     */
    StatisticsDTO getVolunteerStatistics();

    /**
     * 获取关爱对象统计数据
     */
    StatisticsDTO getElderlyStatistics();
}
