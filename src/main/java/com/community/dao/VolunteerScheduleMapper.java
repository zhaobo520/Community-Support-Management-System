package com.community.dao;

import com.community.domain.VolunteerSchedule;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 志愿者排班数据访问接口
 */
public interface VolunteerScheduleMapper {

    /**
     * 查询志愿者排班
     */
    List<VolunteerSchedule> findByVolunteerId(Long volunteerId);

    /**
     * 插入排班
     */
    int insert(VolunteerSchedule schedule);

    /**
     * 更新排班
     */
    int update(VolunteerSchedule schedule);

    /**
     * 删除排班（或者设置为不可用）
     */
    int delete(@Param("volunteerId") Long volunteerId, 
               @Param("dayOfWeek") Integer dayOfWeek, 
               @Param("timeSlot") String timeSlot);
               
    /**
     * 查找特定排班
     */
    VolunteerSchedule findOne(@Param("volunteerId") Long volunteerId, 
                              @Param("dayOfWeek") Integer dayOfWeek, 
                              @Param("timeSlot") String timeSlot);
    
    /**
     * 查询所有可用的排班（关联志愿者信息）
     */
    List<VolunteerSchedule> findAllAvailableWithVolunteer();

    /**
     * 根据时间和星期几查询可用志愿者
     * @param dayOfWeek 星期几 (1-7)
     * @param timeSlot 时间段
     */
    List<VolunteerSchedule> findAvailableByTime(@Param("dayOfWeek") Integer dayOfWeek, 
                                              @Param("timeSlot") String timeSlot);
}
