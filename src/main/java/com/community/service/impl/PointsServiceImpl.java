package com.community.service.impl;

import com.community.dao.PointsMapper;
import com.community.domain.Badge;
import com.community.domain.PointsRecord;
import com.community.service.BadgeService;
import com.community.service.NotificationService;
import com.community.service.PointsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 积分服务实现类
 */
@Service
public class PointsServiceImpl implements PointsService {

    private static final Logger log = LoggerFactory.getLogger(PointsServiceImpl.class);

    @Resource
    private PointsMapper pointsMapper;

    @Resource
    private BadgeService badgeService;

    @Resource
    private NotificationService notificationService;

    // 积分规则常量
    private static final int POINTS_TASK_COMPLETE = 10;      // 完成任务
    private static final int POINTS_TASK_APPROVE = 5;        // 任务审核通过
    private static final int POINTS_HIGH_RATING = 15;        // 高分评价（5分）
    private static final int POINTS_FIRST_TASK = 50;         // 首次任务

    @Override
    @Transactional
    public boolean addPoints(Long userId, Integer points, String sourceType, Long sourceId, String reason) {
        try {
            // 获取当前总积分
            Integer currentTotal = pointsMapper.getUserTotalPoints(userId);
            if (currentTotal == null) {
                currentTotal = 0;
            }

            // 计算新的总积分
            Integer newTotal = currentTotal + points;
            if (newTotal < 0) {
                newTotal = 0; // 积分不能为负数
            }

            // 创建积分记录
            PointsRecord record = new PointsRecord();
            record.setUserId(userId);
            record.setPoints(points);
            record.setTotalPoints(newTotal);
            record.setSourceType(sourceType);
            record.setSourceId(sourceId);
            record.setReason(reason);

            // 插入积分记录
            int inserted = pointsMapper.insert(record);

            // 更新志愿者总积分
            if (inserted > 0) {
                pointsMapper.updateVolunteerTotalPoints(userId, newTotal);
                log.info("用户 {} 积分变更：{} -> {}，原因：{}", userId, currentTotal, newTotal, reason);
                
                // 检查并自动解锁勋章（异步处理，失败不影响主流程）
                if (badgeService != null) {
                    try {
                        List<Badge> newBadges = badgeService.checkAndUnlockBadges(userId);
                        if (newBadges != null && !newBadges.isEmpty()) {
                            log.info("用户 {} 解锁了 {} 个新勋章", userId, newBadges.size());
                            // 发送通知告知用户获得了新勋章
                            for (Badge badge : newBadges) {
                                try {
                                    String title = "🏆 恭喜获得新勋章";
                                    String content = "恭喜您获得了[" + badge.getBadgeName() + "]勋章：" + badge.getDescription();
                                    notificationService.sendNotification(userId, title, content, 
                                        "BADGE", "BADGE", badge.getId());
                                } catch (Exception ne) {
                                    log.warn("发送勋章通知失败: {}", ne.getMessage());
                                }
                            }
                        }
                    } catch (Exception be) {
                        log.warn("检查勋章解锁失败", be);
                        // 勋章检查失败不影响积分添加
                    }
                }
                
                return true;
            }

            return false;
        } catch (Exception e) {
            log.error("添加积分失败", e);
            throw new RuntimeException("添加积分失败：" + e.getMessage());
        }
    }

    @Override
    @Transactional
    public boolean addPointsForTaskComplete(Long taskId, Long volunteerId) {
        try {
            // 检查是否是第一个任务
            Integer completedCount = pointsMapper.countUserCompletedTasks(volunteerId);
            if (completedCount == null) {
                completedCount = 0;
            }

            int points = POINTS_TASK_COMPLETE;
            String reason = "完成任务";

            // 如果是第一个任务，额外奖励
            if (completedCount == 0) {
                points += POINTS_FIRST_TASK;
                reason = "完成首个任务（首次任务奖励+" + POINTS_FIRST_TASK + "分）";
            }

            return addPoints(volunteerId, points, "TASK_COMPLETE", taskId, reason);
        } catch (Exception e) {
            log.error("任务完成加分失败", e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean addPointsForTaskApprove(Long taskId, Long volunteerId, Integer rating) {
        try {
            int points = POINTS_TASK_APPROVE;
            String reason = "任务审核通过";

            // 如果是5分好评，额外奖励
            if (rating != null && rating == 5) {
                points += POINTS_HIGH_RATING;
                reason = "任务审核通过（5分好评额外奖励+" + POINTS_HIGH_RATING + "分）";
            }

            return addPoints(volunteerId, points, "TASK_APPROVE", taskId, reason);
        } catch (Exception e) {
            log.error("任务审核加分失败", e);
            return false;
        }
    }

    @Override
    public List<PointsRecord> getUserPointsRecords(Long userId) {
        return pointsMapper.findByUserId(userId);
    }

    @Override
    public Integer getUserTotalPoints(Long userId) {
        Integer total = pointsMapper.getUserTotalPoints(userId);
        return total != null ? total : 0;
    }

    @Override
    public List<Map<String, Object>> getRankingList(int limit) {
        return getRankingList(limit, "TOTAL");
    }

    @Override
    public List<Map<String, Object>> getRankingList(int limit, String type) {
        if (limit <= 0) {
            limit = 10;
        }
        if (limit > 100) {
            limit = 100;
        }

        if ("MONTH".equals(type)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-01 00:00:00");
            String startDate = sdf.format(new Date());
            return pointsMapper.getRankingListByDate(limit, startDate);
        } else if ("YEAR".equals(type)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-01-01 00:00:00");
            String startDate = sdf.format(new Date());
            return pointsMapper.getRankingListByDate(limit, startDate);
        }

        return pointsMapper.getRankingList(limit);
    }

    @Override
    public Integer getUserRanking(Long userId) {
        Integer ranking = pointsMapper.getUserRanking(userId);
        return ranking != null ? ranking : 0;
    }
}
