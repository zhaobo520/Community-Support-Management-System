package com.community.service;

import com.community.domain.VolunteerSchedule;

import java.util.List;
import java.util.Map;

/**
 * 志愿者排班服务接口
 */
public interface VolunteerScheduleService {

    /**
     * 获取志愿者的排班
     */
    List<VolunteerSchedule> getSchedule(Long volunteerId);

    /**
     * 更新志愿者排班
     * @param scheduleData Map<key, status>，status可以是"available"/"busy"/"empty"
     */
    boolean updateSchedule(Long volunteerId, Map<String, String> scheduleData);

    /**
     * 管理员指派排班
     * @param scheduleData Map<key, status>，status可以是 "available"/"standby"/false(取消)
     */
    boolean assignScheduleByAdmin(Long volunteerId, Map<String, String> scheduleData);

    /**
     * 志愿者确认或拒绝管理员指派的排班
     */
    boolean confirmAdminAssignment(Long volunteerId, Integer dayOfWeek, String timeSlot,
                                   boolean agree, String reason);

    /**
     * 获取所有可服务志愿者的汇总（用于dashboard展示）
     * @return Map<时间key, Map<字段, 值>>
     *   内层 Map 字段:
     *     "status": "available" | "standby" | "empty"
     *     "count": Integer 总人数
     *     "names": String 用 ", " 拼接的所有志愿者名
     *     "available": List<String> 可服务志愿者名单
     *     "standby": List<String> 备班志愿者名单
     */
    Map<String, Map<String, Object>> getAvailableVolunteersSummary();

    /**
     * 检测排班冲突
     * @param volunteerId 志愿者ID
     * @param scheduleData 排班数据 Map<dayOfWeek_timeSlot, status>
     * @return 冲突信息列表 Map<day_time, taskTitle>
     */
    Map<String, String> detectScheduleConflicts(Long volunteerId, Map<String, String> scheduleData);

    /**
     * 获取推荐的志愿者（智能推荐）
     * @param date 服务日期
     * @param timeSlot 服务时段
     * @return 推荐列表，包含志愿者信息
     */
    List<Map<String, Object>> getRecommendedVolunteers(java.util.Date date, String timeSlot);
}
