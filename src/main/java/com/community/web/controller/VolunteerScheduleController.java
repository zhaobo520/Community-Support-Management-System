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

        // 志愿者自己标记的格子（可服务/忙碌/备班）
        Map<String, String> scheduleMap = new HashMap<>();
        // 管理员指派的格子（PENDING 或 CONFIRMED），前端会锁住不让志愿者直接点
        Map<String, String> adminScheduleMap = new HashMap<>();
        // 管理员指派的状态：'pending' 或 'confirmed'，决定锁的视觉表现
        Map<String, String> adminLockStatus = new HashMap<>();
        java.util.List<VolunteerSchedule> pendingAssignments = new java.util.ArrayList<>();
        java.util.List<VolunteerSchedule> rejectedAssignments = new java.util.ArrayList<>();

        for (VolunteerSchedule s : schedules) {
            String key = s.getDayOfWeek() + "_" + s.getTimeSlot();

            if ("VOLUNTEER".equals(s.getAssignSource())) {
                // isAvailable: 1=可服务, 2=备班, 0=忙碌
                String status;
                if (s.getIsAvailable() == 1) status = "available";
                else if (s.getIsAvailable() == 2) status = "standby";
                else status = "busy";
                scheduleMap.put(key, status);
            } else if ("ADMIN".equals(s.getAssignSource())) {
                // 管理员指派：PENDING 与 CONFIRMED 都显示在主网格，但用 adminScheduleMap 独立标识
                if ("PENDING".equals(s.getConfirmStatus()) || "CONFIRMED".equals(s.getConfirmStatus())) {
                    String adminStatus = s.getIsAvailable() == 2 ? "standby" : "available";
                    adminScheduleMap.put(key, adminStatus);
                    adminLockStatus.put(key, "PENDING".equals(s.getConfirmStatus()) ? "pending" : "confirmed");
                }
                if ("PENDING".equals(s.getConfirmStatus())) {
                    pendingAssignments.add(s);
                } else if ("REJECTED".equals(s.getConfirmStatus())) {
                    rejectedAssignments.add(s);
                }
            }
        }

        model.addAttribute("scheduleMap", scheduleMap);
        model.addAttribute("adminScheduleMap", adminScheduleMap);
        model.addAttribute("adminLockStatus", adminLockStatus);
        model.addAttribute("pendingAssignments", pendingAssignments);
        model.addAttribute("rejectedAssignments", rejectedAssignments);
        model.addAttribute("currentUser", currentUser);

        // 添加所有志愿者的汇总数据（用于右上角悬浮小表格）
        Map<String, Map<String, Object>> volunteerSummary = scheduleService.getAvailableVolunteersSummary();
        model.addAttribute("volunteerSummary", volunteerSummary);
        
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
