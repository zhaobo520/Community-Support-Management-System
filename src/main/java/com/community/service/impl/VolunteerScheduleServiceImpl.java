package com.community.service.impl;

import com.community.dao.TaskMapper;
import com.community.dao.VolunteerScheduleMapper;
import com.community.domain.TaskInfo;
import com.community.domain.VolunteerSchedule;
import com.community.service.VolunteerScheduleService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 志愿者排班服务实现类
 */
@Service
public class VolunteerScheduleServiceImpl implements VolunteerScheduleService {

    @Resource
    private VolunteerScheduleMapper scheduleMapper;

    @Resource
    private TaskMapper taskMapper;

    @Override
    public List<VolunteerSchedule> getSchedule(Long volunteerId) {
        return scheduleMapper.findByVolunteerId(volunteerId);
    }

    @Override
    @Transactional
    public boolean updateSchedule(Long volunteerId, Map<String, String> scheduleData) {
        try {
            for (Map.Entry<String, String> entry : scheduleData.entrySet()) {
                String key = entry.getKey();
                String status = entry.getValue(); // "available", "busy", or "empty"
                
                // key format: day_slot (e.g., "1_MORNING")
                String[] parts = key.split("_");
                if (parts.length < 2) continue;
                
                int dayOfWeek = Integer.parseInt(parts[0]);
                String timeSlot = parts[1];
                
                VolunteerSchedule existing = scheduleMapper.findOne(volunteerId, dayOfWeek, timeSlot);
                
                if ("empty".equals(status)) {
                    // 删除志愿者自己创建的记录
                    if (existing != null && "VOLUNTEER".equals(existing.getAssignSource())) {
                        scheduleMapper.delete(volunteerId, dayOfWeek, timeSlot);
                    }
                } else if ("available".equals(status) || "busy".equals(status)) {
                    int isAvailable = "available".equals(status) ? 1 : 0;
                    
                    if (existing != null && "VOLUNTEER".equals(existing.getAssignSource())) {
                        // 更新志愿者自己创建的排班
                        existing.setIsAvailable(isAvailable);
                        scheduleMapper.update(existing);
                    } else if (existing == null) {
                        // 不存在时插入新的志愿者排班
                        VolunteerSchedule newSchedule = new VolunteerSchedule();
                        newSchedule.setVolunteerId(volunteerId);
                        newSchedule.setDayOfWeek(dayOfWeek);
                        newSchedule.setTimeSlot(timeSlot);
                        newSchedule.setIsAvailable(isAvailable);
                        newSchedule.setAssignSource("VOLUNTEER");
                        newSchedule.setConfirmStatus("CONFIRMED");
                        newSchedule.setRejectReason(null);
                        scheduleMapper.insert(newSchedule);
                    }
                    // 如果existing是管理员指派的，志愿者不能通过普通保存来修改
                }
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean assignScheduleByAdmin(Long volunteerId, Map<String, Boolean> scheduleData) {
        try {
            for (Map.Entry<String, Boolean> entry : scheduleData.entrySet()) {
                String key = entry.getKey();
                boolean isAvailable = entry.getValue();
                
                String[] parts = key.split("_");
                if (parts.length < 2) continue;
                
                int dayOfWeek = Integer.parseInt(parts[0]);
                String timeSlot = parts[1];
                
                VolunteerSchedule existing = scheduleMapper.findOne(volunteerId, dayOfWeek, timeSlot);
                
                if (existing != null && "ADMIN".equals(existing.getAssignSource())) {
                    // 更新管理员已指派的记录
                    if (isAvailable) {
                        existing.setIsAvailable(1);
                        existing.setConfirmStatus("PENDING");
                        existing.setRejectReason(null);
                        scheduleMapper.update(existing);
                    } else {
                        // 取消管理员指派
                        scheduleMapper.delete(volunteerId, dayOfWeek, timeSlot);
                    }
                } else if (existing == null && isAvailable) {
                    // 新增管理员指派
                    VolunteerSchedule newSchedule = new VolunteerSchedule();
                    newSchedule.setVolunteerId(volunteerId);
                    newSchedule.setDayOfWeek(dayOfWeek);
                    newSchedule.setTimeSlot(timeSlot);
                    newSchedule.setIsAvailable(1);
                    newSchedule.setAssignSource("ADMIN");
                    newSchedule.setConfirmStatus("PENDING");
                    newSchedule.setRejectReason(null);
                    scheduleMapper.insert(newSchedule);
                }
                // 对志愿者自己设置的排班不做修改
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean confirmAdminAssignment(Long volunteerId, Integer dayOfWeek, String timeSlot, 
                                         boolean agree, String reason) {
        try {
            VolunteerSchedule schedule = scheduleMapper.findOne(volunteerId, dayOfWeek, timeSlot);
            if (schedule == null || !"ADMIN".equals(schedule.getAssignSource())) {
                return false;
            }
            
            if (agree) {
                schedule.setConfirmStatus("CONFIRMED");
                schedule.setIsAvailable(1);
                schedule.setRejectReason(null);
            } else {
                schedule.setConfirmStatus("REJECTED");
                schedule.setIsAvailable(0);
                schedule.setRejectReason(reason);
            }
            
            scheduleMapper.update(schedule);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Map<String, List<String>> getAvailableVolunteersSummary() {
        Map<String, List<String>> summary = new java.util.HashMap<>();
        
        // 查询所有可用的排班
        List<VolunteerSchedule> schedules = scheduleMapper.findAllAvailableWithVolunteer();
        
        // 按时间段分组
        for (VolunteerSchedule schedule : schedules) {
            String key = schedule.getDayOfWeek() + "_" + schedule.getTimeSlot();
            
            if (!summary.containsKey(key)) {
                summary.put(key, new java.util.ArrayList<>());
            }
            
            summary.get(key).add(schedule.getVolunteerName());
        }
        
        return summary;
    }

    @Override
    public Map<String, String> detectScheduleConflicts(Long volunteerId, Map<String, Boolean> scheduleData) {
        Map<String, String> conflicts = new HashMap<>();

        for (Map.Entry<String, Boolean> entry : scheduleData.entrySet()) {
            if (!entry.getValue()) continue; // 只检测要设置为可用的时段

            String key = entry.getKey(); // 如 "1_MORNING"
            String[] parts = key.split("_");
            int dayOfWeek = Integer.parseInt(parts[0]);
            String timeSlot = parts[1];

            // 计算该dayOfWeek对应的具体日期（下一周的该天）
            // 假设排班是针对即将到来的一周
            Calendar cal = Calendar.getInstance();
            int currentDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
            // Calendar.DAY_OF_WEEK: Sunday=1, Monday=2... Saturday=7
            // Our dayOfWeek: Monday=1... Sunday=7
            
            // Convert our dayOfWeek to Calendar day
            int targetCalendarDay = (dayOfWeek % 7) + 1;
            
            int daysToAdd = (targetCalendarDay - currentDayOfWeek + 7) % 7;
            if (daysToAdd == 0) daysToAdd = 7; // Always look for next occurrence
            
            cal.add(Calendar.DATE, daysToAdd);
            Date targetDate = cal.getTime();

            // 查询该时段是否有任务
            List<TaskInfo> tasks = taskMapper.findTasksByVolunteerAndTime(
                    volunteerId, targetDate, timeSlot
            );

            if (!tasks.isEmpty()) {
                TaskInfo task = tasks.get(0);
                conflicts.put(key, task.getTaskTitle());
            }
        }

        return conflicts;
    }

    @Override
    public List<Map<String, Object>> getRecommendedVolunteers(Date date, String timeSlot) {
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        
        if (date == null || timeSlot == null) {
            return result;
        }

        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK) - 1;
        if (dayOfWeek == 0) dayOfWeek = 7;

        // 1. 查询排班符合的志愿者
        List<VolunteerSchedule> schedules = scheduleMapper.findAvailableByTime(dayOfWeek, timeSlot);
        
        // 2. 过滤掉已有任务的志愿者
        for (VolunteerSchedule vs : schedules) {
            List<TaskInfo> conflicts = taskMapper.findTasksByVolunteerAndTime(
                vs.getVolunteerId(), date, timeSlot
            );
            
            // 如果没有冲突任务，则推荐
            if (conflicts.isEmpty()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", vs.getVolunteerId());
                map.put("name", vs.getVolunteerName());
                map.put("reason", "排班合适");
                // 这里可以添加更多信息，如评分、技能匹配度等
                result.add(map);
            }
        }
        
        return result;
    }
}
