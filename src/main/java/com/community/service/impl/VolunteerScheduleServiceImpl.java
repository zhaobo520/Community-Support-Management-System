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

                boolean isVolunteerOwned = existing != null && "VOLUNTEER".equals(existing.getAssignSource());
                boolean isRejectedAdmin = existing != null
                        && "ADMIN".equals(existing.getAssignSource())
                        && "REJECTED".equals(existing.getConfirmStatus());
                boolean isConfirmedAdmin = existing != null
                        && "ADMIN".equals(existing.getAssignSource())
                        && "CONFIRMED".equals(existing.getConfirmStatus());

                if ("empty".equals(status)) {
                    // 志愿者可清掉：自己的、已拒绝的管理员指派、已同意的管理员指派
                    if (isVolunteerOwned || isRejectedAdmin || isConfirmedAdmin) {
                        scheduleMapper.delete(volunteerId, dayOfWeek, timeSlot);
                    }
                } else if ("available".equals(status) || "busy".equals(status) || "standby".equals(status)) {
                    // isAvailable: 1=可服务, 2=备班, 0=忙碌
                    int isAvailable = "available".equals(status) ? 1 : ("standby".equals(status) ? 2 : 0);

                    if (isVolunteerOwned) {
                        // 更新志愿者自己创建的排班
                        existing.setIsAvailable(isAvailable);
                        existing.setConfirmStatus("CONFIRMED");
                        existing.setRejectReason(null);
                        scheduleMapper.update(existing);
                    } else if (isRejectedAdmin || isConfirmedAdmin) {
                        // 志愿者覆盖管理员指派（已拒绝/已同意的） → 转为志愿者自己的设置
                        existing.setIsAvailable(isAvailable);
                        existing.setAssignSource("VOLUNTEER");
                        existing.setConfirmStatus("CONFIRMED");
                        existing.setRejectReason(null);
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
                    // 仍为 ADMIN/PENDING 的行：志愿者要走 confirm 流程才能改
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
    public boolean assignScheduleByAdmin(Long volunteerId, Map<String, String> scheduleData) {
        try {
            for (Map.Entry<String, String> entry : scheduleData.entrySet()) {
                String key = entry.getKey();
                String status = entry.getValue(); // "available", "standby", or "false"/null

                String[] parts = key.split("_");
                if (parts.length < 2) continue;

                int dayOfWeek = Integer.parseInt(parts[0]);
                String timeSlot = parts[1];

                VolunteerSchedule existing = scheduleMapper.findOne(volunteerId, dayOfWeek, timeSlot);

                boolean isAssign = "available".equals(status) || "standby".equals(status);
                // isAvailable: 1=可服务, 2=备班
                int isAvailableVal = "standby".equals(status) ? 2 : 1;

                if (existing != null && "ADMIN".equals(existing.getAssignSource())) {
                    if (isAssign) {
                        // 仅在「值有变化」或「之前被志愿者拒过」时才重置为 PENDING，
                        // 否则保持原状态（避免把已 CONFIRMED 的全部重置为待确认）
                        boolean valueChanged = existing.getIsAvailable() == null
                                || existing.getIsAvailable() != isAvailableVal;
                        boolean wasRejected = "REJECTED".equals(existing.getConfirmStatus());

                        if (valueChanged || wasRejected) {
                            existing.setIsAvailable(isAvailableVal);
                            existing.setConfirmStatus("PENDING");
                            existing.setRejectReason(null);
                            scheduleMapper.update(existing);
                        }
                        // else: 值未变 且 已 CONFIRMED → 跳过
                    } else {
                        // 取消管理员指派；保留 REJECTED 记录，便于管理员查看历史
                        if (!"REJECTED".equals(existing.getConfirmStatus())) {
                            scheduleMapper.delete(volunteerId, dayOfWeek, timeSlot);
                        }
                    }
                } else if (existing == null && isAssign) {
                    // 新增管理员指派，PENDING 等志愿者确认
                    VolunteerSchedule newSchedule = new VolunteerSchedule();
                    newSchedule.setVolunteerId(volunteerId);
                    newSchedule.setDayOfWeek(dayOfWeek);
                    newSchedule.setTimeSlot(timeSlot);
                    newSchedule.setIsAvailable(isAvailableVal);
                    newSchedule.setAssignSource("ADMIN");
                    newSchedule.setConfirmStatus("PENDING");
                    newSchedule.setRejectReason(null);
                    scheduleMapper.insert(newSchedule);
                } else if (existing != null && "VOLUNTEER".equals(existing.getAssignSource()) && isAssign) {
                    // 管理员指派覆盖志愿者已标记的格子 → 转为 ADMIN/PENDING 等志愿者再次确认
                    existing.setIsAvailable(isAvailableVal);
                    existing.setAssignSource("ADMIN");
                    existing.setConfirmStatus("PENDING");
                    existing.setRejectReason(null);
                    scheduleMapper.update(existing);
                }
                // existing 是 VOLUNTEER 且 !isAssign：保留志愿者自己的记录，不动
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
                // isAvailable 保持原值不变（1=可服务, 2=备班）
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
    public Map<String, Map<String, Object>> getAvailableVolunteersSummary() {
        Map<String, Map<String, Object>> summary = new HashMap<>();

        // 查询所有可用的排班（仅 CONFIRMED）
        List<VolunteerSchedule> schedules = scheduleMapper.findAllAvailableWithVolunteer();

        // 按时间段分组并区分 available / standby
        for (VolunteerSchedule schedule : schedules) {
            String key = schedule.getDayOfWeek() + "_" + schedule.getTimeSlot();
            // isAvailable: 1=可服务, 2=备班
            String bucket = schedule.getIsAvailable() != null && schedule.getIsAvailable() == 2
                    ? "standby" : "available";

            Map<String, Object> entry = summary.get(key);
            if (entry == null) {
                entry = new HashMap<>();
                entry.put("available", new java.util.ArrayList<String>());
                entry.put("standby", new java.util.ArrayList<String>());
                summary.put(key, entry);
            }
            @SuppressWarnings("unchecked")
            List<String> list = (List<String>) entry.get(bucket);
            list.add(schedule.getVolunteerName());
        }

        // 计算总数、状态和拼接名字
        for (Map.Entry<String, Map<String, Object>> e : summary.entrySet()) {
            Map<String, Object> entry = e.getValue();
            @SuppressWarnings("unchecked")
            List<String> available = (List<String>) entry.get("available");
            @SuppressWarnings("unchecked")
            List<String> standby = (List<String>) entry.get("standby");

            String status;
            if (available != null && !available.isEmpty()) {
                status = "available";
            } else if (standby != null && !standby.isEmpty()) {
                status = "standby";
            } else {
                status = "empty";
            }
            entry.put("status", status);
            entry.put("count", (available == null ? 0 : available.size())
                    + (standby == null ? 0 : standby.size()));

            // 拼接名字：可服务在前，备班在后，备班加 (备班) 标记
            java.util.List<String> labeled = new java.util.ArrayList<>();
            if (available != null) labeled.addAll(available);
            if (standby != null) {
                for (String name : standby) labeled.add(name + "(备班)");
            }
            entry.put("names", String.join(", ", labeled));
        }

        return summary;
    }

    @Override
    public Map<String, String> detectScheduleConflicts(Long volunteerId, Map<String, String> scheduleData) {
        Map<String, String> conflicts = new HashMap<>();

        for (Map.Entry<String, String> entry : scheduleData.entrySet()) {
            String status = entry.getValue();
            // 只检测要设置为可用/备班的时段，false/null 跳过
            if (!"available".equals(status) && !"standby".equals(status)) continue;

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
