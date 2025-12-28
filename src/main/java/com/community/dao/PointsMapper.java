package com.community.dao;

import com.community.domain.PointsRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 积分数据访问接口
 */
public interface PointsMapper {

    /**
     * 插入积分记录
     */
    int insert(PointsRecord record);

    /**
     * 查询用户积分记录列表
     */
    List<PointsRecord> findByUserId(Long userId);

    /**
     * 查询所有积分记录（带用户信息）
     */
    List<PointsRecord> findAllWithUser();

    /**
     * 获取用户当前总积分
     */
    Integer getUserTotalPoints(Long userId);

    /**
     * 更新志愿者总积分
     */
    int updateVolunteerTotalPoints(@Param("userId") Long userId, @Param("totalPoints") Integer totalPoints);

    /**
     * 获取积分排行榜
     */
    List<Map<String, Object>> getRankingList(@Param("limit") int limit);

    /**
     * 获取指定日期之后的积分排行榜（用于月榜、年榜）
     */
    List<Map<String, Object>> getRankingListByDate(@Param("limit") int limit, @Param("startDate") String startDate);

    /**
     * 获取用户积分排名
     */
    Integer getUserRanking(Long userId);

    /**
     * 统计用户完成的任务数
     */
    Integer countUserCompletedTasks(Long userId);
}
