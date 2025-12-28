package com.community.web.controller;

import com.community.domain.SystemConfig;
import com.community.domain.User;
import com.community.service.SystemConfigService;
import com.community.service.SystemLogService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统配置控制器
 */
@Controller
@RequestMapping("/admin/config")
public class SystemConfigController {
    
    private static final Logger log = LoggerFactory.getLogger(SystemConfigController.class);
    
    @Resource
    private SystemConfigService systemConfigService;
    
    @Resource
    private SystemLogService systemLogService;
    
    /**
     * 系统配置页面
     */
    @GetMapping("/index")
    public String index(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }
        
        // 获取所有配置（按分类分组）
        Map<String, List<SystemConfig>> configsMap = systemConfigService.getAllConfigsGrouped();
        
        model.addAttribute("configsMap", configsMap);
        model.addAttribute("currentUser", currentUser);
        
        return "admin/system_config";
    }
    
    /**
     * 更新配置（AJAX）
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateConfig(@RequestParam String configKey,
                                             @RequestParam String configValue,
                                             HttpSession session,
                                             HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            // 获取旧值用于日志记录
            String oldValue = systemConfigService.getConfigValue(configKey);
            
            boolean success = systemConfigService.updateConfig(
                configKey, 
                configValue, 
                currentUser.getUsername()
            );
            
            if (success) {
                // 记录配置变更日志
                String ipAddress = getClientIP(request);
                systemLogService.logConfigChange(
                    currentUser.getId(),
                    currentUser.getFullName(),
                    configKey,
                    oldValue,
                    configValue,
                    ipAddress
                );
                
                result.put("success", true);
                result.put("message", "配置更新成功");
            } else {
                result.put("success", false);
                result.put("message", "配置更新失败");
            }
        } catch (Exception e) {
            log.error("更新配置失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 批量更新配置（AJAX）
     */
    @PostMapping("/batch-update")
    @ResponseBody
    public Map<String, Object> batchUpdate(@RequestBody List<SystemConfig> configs,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            boolean success = systemConfigService.batchUpdateConfigs(
                configs, 
                currentUser.getUsername()
            );
            
            if (success) {
                result.put("success", true);
                result.put("message", "批量更新成功");
            } else {
                result.put("success", false);
                result.put("message", "批量更新失败");
            }
        } catch (Exception e) {
            log.error("批量更新配置失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 刷新缓存（AJAX）
     */
    @PostMapping("/refresh-cache")
    @ResponseBody
    public Map<String, Object> refreshCache(HttpSession session,
                                             HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            systemConfigService.refreshCache();
            
            // 记录操作日志
            String ipAddress = getClientIP(request);
            systemLogService.logOperation(
                "刷新配置缓存",
                currentUser.getId(),
                currentUser.getFullName(),
                "管理员刷新了系统配置缓存",
                ipAddress
            );
            
            result.put("success", true);
            result.put("message", "缓存刷新成功");
        } catch (Exception e) {
            log.error("刷新缓存失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * 获取客户端IP地址
     */
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
