package com.community.service;

import com.community.domain.PointsRecord;

import java.util.List;
import java.util.Map;

/**
 * 积分服务接口
 */
public interface PointsService {

    /**
     * 添加积分
     *
     * @param userId 用户ID
     * @param points 积分数
     * @param sourceType 来源类型
     * @param sourceId 来源ID
     * @param reason 原因说明
     * @return 是否成功
     */
    boolean addPoints(Long userId, Integer points, String sourceType, Long sourceId, String reason);

    /**
     * 任务完成自动加分
     *
     * @param taskId 任务ID
     * @param volunteerId 志愿者ID
     * @return 是否成功
     */
    boolean addPointsForTaskComplete(Long taskId, Long volunteerId);

    /**
     * 任务审核通过额外加分
     *
     * @param taskId 任务ID
     * @param volunteerId 志愿者ID
     * @param rating 评分
     * @return 是否成功
     */
    boolean addPointsForTaskApprove(Long taskId, Long volunteerId, Integer rating);

    /**
     * 查询用户积分记录
     *
     * @param userId 用户ID
     * @return 积分记录列表
     */
    List<PointsRecord> getUserPointsRecords(Long userId);

    /**
     * 获取用户当前总积分
     *
     * @param userId 用户ID
     * @return 总积分
     */
    Integer getUserTotalPoints(Long userId);

    /**
     * 获取积分排行榜
     *
     * @param limit 返回条数
     * @param type  排行类型：TOTAL-总榜，MONTH-月榜，YEAR-年榜
     * @return 排行榜列表
     */
    List<Map<String, Object>> getRankingList(int limit, String type);

    /**
     * 获取积分排行榜（兼容旧接口，默认总榜）
     *
     * @param limit 返回条数
     * @return 排行榜列表
     */
    List<Map<String, Object>> getRankingList(int limit);

    /**
     * 获取用户排名
     *
     * @param userId 用户ID
     * @return 排名（从1开始）
     */
    Integer getUserRanking(Long userId);
}
