package com.community.web.controller;

import com.community.domain.User;
import com.community.domain.VolunteerSchedule;
import com.community.service.UserService;
import com.community.service.VolunteerScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * 管理员排班管理控制器
 */
@Controller
@RequestMapping("/admin/schedule")
public class AdminScheduleController {

    @Resource
    private VolunteerScheduleService scheduleService;

    @Resource
    private UserService userService;

    /**
     * 管理员排班管理页面
     */
    @GetMapping("/manage")
    public String manage(@RequestParam(required = false) Long volunteerId, 
                        Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        // 获取所有志愿者
        List<User> volunteers = userService.findByRoleType("VOLUNTEER");
        model.addAttribute("volunteers", volunteers);

        if (volunteerId == null && !volunteers.isEmpty()) {
            volunteerId = volunteers.get(0).getId();
        }

        if (volunteerId != null) {
            model.addAttribute("selectedVolunteerId", volunteerId);
            
            // 获取选中志愿者的排班
            List<VolunteerSchedule> schedules = scheduleService.getSchedule(volunteerId);
            
            // 构造两个Map：管理员指派的、志愿者自己标记的
            Map<String, String> adminScheduleMap = new HashMap<>();
            Map<String, String> volunteerStatusMap = new HashMap<>();
            List<VolunteerSchedule> pendingList = new ArrayList<>();
            List<VolunteerSchedule> rejectedList = new ArrayList<>();

            for (VolunteerSchedule schedule : schedules) {
                String key = schedule.getDayOfWeek() + "_" + schedule.getTimeSlot();

                if ("ADMIN".equals(schedule.getAssignSource())) {
                    if (schedule.getIsAvailable() >= 1) {
                        // isAvailable: 1=可服务, 2=备班
                        String adminStatus = schedule.getIsAvailable() == 2 ? "standby" : "available";
                        adminScheduleMap.put(key, adminStatus);
                    }

                    if ("PENDING".equals(schedule.getConfirmStatus())) {
                        pendingList.add(schedule);
                    } else if ("REJECTED".equals(schedule.getConfirmStatus())) {
                        rejectedList.add(schedule);
                    }
                } else if ("VOLUNTEER".equals(schedule.getAssignSource())) {
                    // 志愿者自己标记的状态：isAvailable 1=可服务, 2=备班, 0=忙碌
                    String vs;
                    if (schedule.getIsAvailable() == 1) vs = "available";
                    else if (schedule.getIsAvailable() == 2) vs = "standby";
                    else vs = "busy";
                    volunteerStatusMap.put(key, vs);
                }
            }
            
            model.addAttribute("scheduleMap", adminScheduleMap);
            model.addAttribute("volunteerStatusMap", volunteerStatusMap);
            model.addAttribute("pendingAssignments", pendingList);
            model.addAttribute("rejectedAssignments", rejectedList);
        }
        
        // 添加所有志愿者的汇总数据（用于右上角小表格）
        Map<String, Map<String, Object>> volunteerSummary = scheduleService.getAvailableVolunteersSummary();
        model.addAttribute("volunteerSummary", volunteerSummary);

        return "admin/volunteer_schedule_manage";
    }

    /**
     * 管理员更新排班
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> update(@RequestParam Long volunteerId,
                                     @RequestBody Map<String, String> scheduleData,
                                     HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        boolean success = scheduleService.assignScheduleByAdmin(volunteerId, scheduleData);
        result.put("success", success);
        result.put("hasConflicts", false);
        result.put("message", success ? "保存成功" : "保存失败");

        return result;
    }
}
