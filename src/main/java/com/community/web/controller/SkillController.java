package com.community.web.controller;

import com.community.domain.Skill;
import com.community.domain.User;
import com.community.domain.VolunteerSkill;
import com.community.service.SkillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 技能管理控制器
 */
@Controller
@RequestMapping("/skill")
public class SkillController {
    
    private static final Logger log = LoggerFactory.getLogger(SkillController.class);
    
    @Resource
    private SkillService skillService;
    
    /**
     * 志愿者技能配置页面
     */
    @GetMapping("/config")
    public String skillConfig(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }
        
        // 获取所有技能（按分类）
        Map<String, List<Skill>> skillsMap = skillService.getSkillsGroupedByCategory();
        
        // 获取志愿者已选择的技能
        List<VolunteerSkill> mySkills = skillService.getVolunteerSkills(currentUser.getId());
        
        model.addAttribute("skillsMap", skillsMap);
        model.addAttribute("mySkills", mySkills);
        model.addAttribute("currentUser", currentUser);
        
        return "skill/config";
    }
    
    /**
     * 获取所有技能（AJAX）
     */
    @GetMapping("/all")
    @ResponseBody
    public Map<String, Object> getAllSkills(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }
        
        try {
            Map<String, List<Skill>> skillsMap = skillService.getSkillsGroupedByCategory();
            result.put("success", true);
            result.put("data", skillsMap);
        } catch (Exception e) {
            log.error("获取技能列表失败", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }
        
        return result;
    }
    
    /**
     * 获取我的技能（AJAX）
     */
    @GetMapping("/my")
    @ResponseBody
    public Map<String, Object> getMySkills(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }
        
        try {
            List<VolunteerSkill> mySkills = skillService.getVolunteerSkills(currentUser.getId());
            result.put("success", true);
            result.put("data", mySkills);
        } catch (Exception e) {
            log.error("获取我的技能失败", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }
        
        return result;
    }
    
    /**
     * 更新技能（AJAX）
     */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateSkills(@RequestParam("skillIds") List<Long> skillIds,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }
        
        try {
            boolean success = skillService.updateVolunteerSkills(currentUser.getId(), skillIds);
            if (success) {
                result.put("success", true);
                result.put("message", "技能更新成功");
            } else {
                result.put("success", false);
                result.put("message", "技能更新失败");
            }
        } catch (Exception e) {
            log.error("更新技能失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }
        
        return result;
    }
}
