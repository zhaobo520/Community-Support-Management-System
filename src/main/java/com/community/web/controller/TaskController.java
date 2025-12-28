package com.community.web.controller;

import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.service.TaskService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

/**
 * 任务公共控制器
 * 处理不需要特定角色权限的任务相关请求
 */
@Controller
@RequestMapping("/task")
public class TaskController {

    @Resource
    private TaskService taskService;

    /**
     * 查看任务详情
     * 任何登录用户都可以查看任务详情
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id,
                        Model model,
                        HttpSession session) {
        
        // 获取当前用户
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null) {
            return "redirect:/user/login";
        }
        
        // 查询任务详情
        TaskInfo taskInfo = taskService.findById(id);
        if (taskInfo == null) {
            model.addAttribute("errorMsg", "任务不存在或已被删除");
            return "error/404";
        }
        
        // 检查任务是否可以被查看
        // 已取消或已关闭的任务不显示给志愿者
        if ("VOLUNTEER".equals(currentUser.getRoleType())) {
            if ("CANCELLED".equals(taskInfo.getStatus()) || 
                "CLOSED".equals(taskInfo.getStatus())) {
                model.addAttribute("errorMsg", "该任务已不可查看");
                return "error/task_not_available";
            }
        }
        
        // 传递数据到页面
        model.addAttribute("taskInfo", taskInfo);
        model.addAttribute("currentUser", currentUser);
        
        // 根据用户角色返回不同的视图
        // 但这里为了统一，使用同一个详情页面
        return "task/detail";
    }
}
