package com.community.dao;

import com.community.domain.Badge;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 勋章数据访问接口
 */
public interface BadgeMapper {

    /**
     * 查询所有勋章
     */
    List<Badge> findAll();

    /**
     * 根据ID查询勋章
     */
    Badge findById(Long id);

    /**
     * 根据代码查询勋章
     */
    Badge findByCode(String badgeCode);

    /**
     * 查询用户已获得的勋章
     */
    List<Badge> findUserBadges(Long userId);

    /**
     * 查询用户未获得的勋章
     */
    List<Badge> findUserUnlockedBadges(Long userId);

    /**
     * 检查用户是否已获得勋章
     */
    boolean hasUserBadge(@Param("userId") Long userId, @Param("badgeId") Long badgeId);

    /**
     * 授予用户勋章
     */
    int grantBadge(@Param("userId") Long userId, @Param("badgeId") Long badgeId);

    /**
     * 统计用户勋章数量
     */
    int countUserBadges(Long userId);
    
    /**
     * 统计用户高分评价任务数量（4分及以上）
     */
    int countHighRatingTasks(Long userId);
}
