package com.community.service;

import com.community.domain.Badge;

import java.util.List;

/**
 * 勋章服务接口
 */
public interface BadgeService {

    /**
     * 查询所有勋章
     */
    List<Badge> findAll();

    /**
     * 查询用户已获得的勋章
     */
    List<Badge> getUserBadges(Long userId);

    /**
     * 查询用户未获得的勋章
     */
    List<Badge> getUserUnlockedBadges(Long userId);

    /**
     * 授予用户勋章
     */
    boolean grantBadge(Long userId, Long badgeId);

    /**
     * 检查并自动解锁勋章
     * 
     * @param userId 用户ID
     * @return 新解锁的勋章列表
     */
    List<Badge> checkAndUnlockBadges(Long userId);

    /**
     * 统计用户勋章数量
     */
    int countUserBadges(Long userId);
}
