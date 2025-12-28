package com.community.service.impl;

import com.community.dao.BadgeMapper;
import com.community.dao.PointsMapper;
import com.community.dao.TaskMapper;
import com.community.domain.Badge;
import com.community.service.BadgeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 勋章服务实现类
 */
@Service
public class BadgeServiceImpl implements BadgeService {

    private static final Logger log = LoggerFactory.getLogger(BadgeServiceImpl.class);

    @Resource
    private BadgeMapper badgeMapper;

    @Resource
    private PointsMapper pointsMapper;

    @Resource
    private TaskMapper taskMapper;

    @Override
    public List<Badge> findAll() {
        return badgeMapper.findAll();
    }

    @Override
    public List<Badge> getUserBadges(Long userId) {
        return badgeMapper.findUserBadges(userId);
    }

    @Override
    public List<Badge> getUserUnlockedBadges(Long userId) {
        return badgeMapper.findUserUnlockedBadges(userId);
    }

    @Override
    @Transactional
    public boolean grantBadge(Long userId, Long badgeId) {
        try {
            // 检查是否已经拥有
            if (badgeMapper.hasUserBadge(userId, badgeId)) {
                log.info("用户 {} 已拥有勋章 {}", userId, badgeId);
                return false;
            }

            int result = badgeMapper.grantBadge(userId, badgeId);
            if (result > 0) {
                Badge badge = badgeMapper.findById(badgeId);
                log.info("用户 {} 获得勋章：{}", userId, badge != null ? badge.getBadgeName() : badgeId);
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("授予勋章失败", e);
            return false;
        }
    }

    @Override
    @Transactional
    public List<Badge> checkAndUnlockBadges(Long userId) {
        List<Badge> newBadges = new ArrayList<>();

        try {
            // 获取用户当前积分和任务数
            Integer totalPoints = pointsMapper.getUserTotalPoints(userId);
            if (totalPoints == null) {
                totalPoints = 0;
            }

            Integer completedTasks = pointsMapper.countUserCompletedTasks(userId);
            if (completedTasks == null) {
                completedTasks = 0;
            }

            // 获取所有勋章
            List<Badge> allBadges = badgeMapper.findAll();

            for (Badge badge : allBadges) {
                // 检查是否已拥有
                if (badgeMapper.hasUserBadge(userId, badge.getId())) {
                    continue;
                }

                // 检查是否满足解锁条件
                boolean shouldUnlock = false;
                String conditionType = badge.getConditionType();
                Integer conditionValue = badge.getConditionValue();

                if (conditionType == null || conditionValue == null) {
                    continue;
                }

                switch (conditionType) {
                    case "TASK_COUNT":
                        // 完成任务数量
                        if (completedTasks >= conditionValue) {
                            shouldUnlock = true;
                        }
                        break;

                    case "POINTS_TOTAL":
                        // 累计积分
                        if (totalPoints >= conditionValue) {
                            shouldUnlock = true;
                        }
                        break;

                    case "CONTINUOUS_DAYS":
                        // 连续登录天数（暂时跳过，需要登录记录表）
                        break;

                    case "HIGH_RATING_COUNT":
                        // 高分评价次数（需要从task_info统计）
                        // 统计用户获得4分及以上评价的任务数量
                        int highRatingCount = badgeMapper.countHighRatingTasks(userId);
                        if (highRatingCount >= conditionValue) {
                            shouldUnlock = true;
                        }
                        break;

                    default:
                        break;
                }

                // 解锁勋章
                if (shouldUnlock) {
                    if (grantBadge(userId, badge.getId())) {
                        newBadges.add(badge);
                        log.info("用户 {} 自动解锁勋章：{}", userId, badge.getBadgeName());
                    }
                }
            }

        } catch (Exception e) {
            log.error("检查勋章解锁失败", e);
        }

        return newBadges;
    }

    @Override
    public int countUserBadges(Long userId) {
        return badgeMapper.countUserBadges(userId);
    }
}
