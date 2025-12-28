package com.community.web.controller;

import com.community.domain.User;
import com.community.domain.VolunteerSchedule;
import com.community.service.VolunteerScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 志愿者排班控制器
 */
@Controller
@RequestMapping("/volunteer/schedule")
public class VolunteerScheduleController {

    @Resource
    private VolunteerScheduleService scheduleService;

    /**
     * 排班管理页面
     */
    @GetMapping("/manage")
    public String manage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        List<VolunteerSchedule> schedules = scheduleService.getSchedule(currentUser.getId());
        
        // 将列表转换为Map，值为状态: available/busy/null
        Map<String, String> scheduleMap = new HashMap<>();
        java.util.List<VolunteerSchedule> pendingAssignments = new java.util.ArrayList<>();
        java.util.List<VolunteerSchedule> rejectedAssignments = new java.util.ArrayList<>();
        
        for (VolunteerSchedule s : schedules) {
            String key = s.getDayOfWeek() + "_" + s.getTimeSlot();
            
            // 显示在网格中的时段：
            // 1. 志愿者自己设定的时段（可服务或忙碌）
            // 2. 管理员指派且已确认的时段（总是显示为可服务）
            if ("VOLUNTEER".equals(s.getAssignSource())) {
                scheduleMap.put(key, s.getIsAvailable() == 1 ? "available" : "busy");
            } else if ("ADMIN".equals(s.getAssignSource()) && "CONFIRMED".equals(s.getConfirmStatus()) && s.getIsAvailable() == 1) {
                scheduleMap.put(key, "available");
            }
            
            // 管理员指派待确认的
            if ("ADMIN".equals(s.getAssignSource()) && "PENDING".equals(s.getConfirmStatus())) {
                pendingAssignments.add(s);
            }
            
            // 已拒绝的
            if ("ADMIN".equals(s.getAssignSource()) && "REJECTED".equals(s.getConfirmStatus())) {
                rejectedAssignments.add(s);
            }
        }

        model.addAttribute("scheduleMap", scheduleMap);
        model.addAttribute("pendingAssignments", pendingAssignments);
        model.addAttribute("rejectedAssignments", rejectedAssignments);
        model.addAttribute("currentUser", currentUser);
        
        return "volunteer/schedule";
    }

    /**
     * 更新排班（AJAX）
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> update(@RequestBody Map<String, String> scheduleData, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        boolean success = scheduleService.updateSchedule(currentUser.getId(), scheduleData);
        result.put("success", success);
        result.put("message", success ? "排班更新成功" : "更新失败");
        
        return result;
    }

    /**
     * 确认或拒绝管理员指派的排班
     */
    @PostMapping("/confirm")
    @ResponseBody
    public Map<String, Object> confirm(@RequestParam Integer dayOfWeek,
                                      @RequestParam String timeSlot,
                                      @RequestParam Boolean agree,
                                      @RequestParam(required = false) String reason,
                                      HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        // 拒绝时必须填写理由
        if (!agree && (reason == null || reason.trim().isEmpty())) {
            result.put("success", false);
            result.put("message", "拒绝时必须填写理由");
            return result;
        }

        boolean success = scheduleService.confirmAdminAssignment(
            currentUser.getId(), dayOfWeek, timeSlot, agree, reason);
        
        result.put("success", success);
        result.put("message", success ? "操作成功" : "操作失败");
        
        return result;
    }
}
