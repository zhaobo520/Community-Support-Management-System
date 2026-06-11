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
 * 家属查看志愿者排班控制器
 */
@Controller
@RequestMapping("/family/schedule")
public class FamilyScheduleController {

    @Resource
    private VolunteerScheduleService scheduleService;

    @Resource
    private UserService userService;

    /**
     * 家属查看志愿者排班页面（只读）
     */
    @GetMapping("/view")
    public String view(@RequestParam(required = false) Long volunteerId, 
                      Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
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
            
            // 只显示已确认的有效时段（志愿者自己设置 或 管理员指派已同意）
            Map<String, String> scheduleMap = new HashMap<>();
            for (VolunteerSchedule schedule : schedules) {
                boolean isConfirmed = "VOLUNTEER".equals(schedule.getAssignSource())
                        || ("ADMIN".equals(schedule.getAssignSource())
                            && "CONFIRMED".equals(schedule.getConfirmStatus()));

                if (isConfirmed && schedule.getIsAvailable() >= 1) {
                    String key = schedule.getDayOfWeek() + "_" + schedule.getTimeSlot();
                    // isAvailable: 1=可服务, 2=备班, 0=忙碌
                    if (schedule.getIsAvailable() == 2) {
                        scheduleMap.put(key, "standby");
                    } else if (schedule.getIsAvailable() == 0) {
                        scheduleMap.put(key, "busy");
                    } else {
                        scheduleMap.put(key, "available");
                    }
                }
            }
            
            model.addAttribute("scheduleMap", scheduleMap);
        }
        
        // 添加所有志愿者的汇总数据（用于右上角小表格）
        Map<String, Map<String, Object>> volunteerSummary = scheduleService.getAvailableVolunteersSummary();
        model.addAttribute("volunteerSummary", volunteerSummary);

        return "family/volunteer_schedule_view";
    }
}
