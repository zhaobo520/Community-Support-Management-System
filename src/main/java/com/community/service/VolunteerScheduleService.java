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
     */
    boolean assignScheduleByAdmin(Long volunteerId, Map<String, Boolean> scheduleData);

    /**
     * 志愿者确认或拒绝管理员指派的排班
     */
    boolean confirmAdminAssignment(Long volunteerId, Integer dayOfWeek, String timeSlot, 
                                   boolean agree, String reason);

    /**
     * 获取所有可服务志愿者的汇总（用于dashboard展示）
     * @return Map<时间key, List<志愿者名称>>
     */
    Map<String, List<String>> getAvailableVolunteersSummary();

    /**
     * 检测排班冲突
     * @param volunteerId 志愿者ID
     * @param scheduleData 排班数据 Map<dayOfWeek_timeSlot, boolean>
     * @return 冲突信息列表 Map<day_time, taskTitle>
     */
    Map<String, String> detectScheduleConflicts(Long volunteerId, Map<String, Boolean> scheduleData);

    /**
     * 获取推荐的志愿者（智能推荐）
     * @param date 服务日期
     * @param timeSlot 服务时段
     * @return 推荐列表，包含志愿者信息
     */
    List<Map<String, Object>> getRecommendedVolunteers(java.util.Date date, String timeSlot);
}
