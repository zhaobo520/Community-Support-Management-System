package com.community.web.controller;

import com.community.domain.SystemLog;
import com.community.domain.User;
import com.community.service.SystemLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统日志控制器
 */
@Controller
@RequestMapping("/admin/logs")
public class SystemLogController {
    
    private static final Logger log = LoggerFactory.getLogger(SystemLogController.class);
    
    @Resource
    private SystemLogService systemLogService;
    
    /**
     * 系统日志页面
     */
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }
        
        // 获取统计信息
        Map<String, Object> statistics = systemLogService.getLogStatistics();
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentUser", currentUser);
        
        return "admin/system_logs";
    }
    
    /**
     * 获取日志列表（AJAX）
     */
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> getLogsList(@RequestParam(defaultValue = "1") Integer page,
                                            @RequestParam(defaultValue = "20") Integer pageSize,
                                            @RequestParam(required = false) String logType,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            List<SystemLog> logs;
            if (logType != null && !logType.isEmpty()) {
                logs = systemLogService.getLogsByType(logType);
            } else {
                logs = systemLogService.getLogsByPage(page, pageSize);
            }
            
            result.put("success", true);
            result.put("data", logs);
            result.put("page", page);
            result.put("pageSize", pageSize);
        } catch (Exception e) {
            log.error("获取日志列表失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 按类型查询日志（AJAX）
     */
    @GetMapping("/filter")
    @ResponseBody
    public Map<String, Object> filterLogs(@RequestParam String logType,
                                           HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            List<SystemLog> logs = systemLogService.getLogsByType(logType);
            result.put("success", true);
            result.put("data", logs);
        } catch (Exception e) {
            log.error("筛选日志失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 按时间范围查询日志（AJAX）
     */
    @GetMapping("/date-range")
    @ResponseBody
    public Map<String, Object> getLogsByDateRange(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            List<SystemLog> logs = systemLogService.getLogsByDateRange(startDate, endDate);
            result.put("success", true);
            result.put("data", logs);
        } catch (Exception e) {
            log.error("按时间范围查询日志失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 清理旧日志（AJAX）
     */
    @PostMapping("/clean")
    @ResponseBody
    public Map<String, Object> cleanOldLogs(@RequestParam Integer days,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            int deletedCount = systemLogService.cleanOldLogs(days);
            result.put("success", true);
            result.put("message", "清理成功，共删除" + deletedCount + "条日志");
            result.put("deletedCount", deletedCount);
        } catch (Exception e) {
            log.error("清理日志失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 清空所有日志（AJAX）
     */
    @PostMapping("/clear-all")
    @ResponseBody
    public Map<String, Object> clearAllLogs(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            int deletedCount = systemLogService.clearAllLogs();
            result.put("success", true);
            result.put("message", "清空成功，共删除" + deletedCount + "条日志");
            result.put("deletedCount", deletedCount);
        } catch (Exception e) {
            log.error("清空日志失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
}
