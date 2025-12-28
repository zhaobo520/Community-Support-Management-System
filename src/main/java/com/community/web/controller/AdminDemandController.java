package com.community.web.controller;

import com.community.domain.Demand;
import com.community.domain.User;
import com.community.service.DemandService;
import com.community.service.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员需求管理控制器
 */
@Controller
@RequestMapping("/admin/demand")
public class AdminDemandController {

    private static final Logger log = LoggerFactory.getLogger(AdminDemandController.class);

    @Resource
    private DemandService demandService;

    @Resource
    private NotificationService notificationService;

    /**
     * 需求管理列表页面
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        List<Demand> demandList;
        if (status != null && !status.isEmpty()) {
            demandList = demandService.findByFamilyUserId(null); // 需要根据status过滤
            demandList.removeIf(d -> !status.equals(d.getStatus()));
        } else {
            demandList = demandService.findAll();
        }

        Map<String, Object> statistics = demandService.getAdminStatistics();

        model.addAttribute("demandList", demandList);
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("filterStatus", status);
        
        return "demand/admin_list";
    }

    /**
     * 待审核需求列表
     */
    @GetMapping("/pending")
    public String pendingList(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        List<Demand> demandList = demandService.findPendingDemands();
        Map<String, Object> statistics = demandService.getAdminStatistics();

        model.addAttribute("demandList", demandList);
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentUser", currentUser);
        
        return "demand/admin_pending";
    }

    /**
     * 需求详情页面
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        Demand demand = demandService.findById(id);
        if (demand == null) {
            return "redirect:/admin/demand/list";
        }

        model.addAttribute("demand", demand);
        model.addAttribute("currentUser", currentUser);
        
        return "demand/admin_detail";
    }

    /**
     * 审核通过
     */
    @PostMapping("/approve/{id}")
    @ResponseBody
    public Map<String, Object> approve(@PathVariable Long id, 
                                       @RequestParam(required = false) String reviewComment,
                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            Demand demand = demandService.findById(id);
            boolean success = demandService.approve(id, currentUser.getId(), reviewComment);
            
            // 发送通知给家属
            if (success && demand != null && notificationService != null) {
                try {
                    String notifContent = "您的需求《" + demand.getTitle() + "》已审核通过！";
                    if (reviewComment != null && !reviewComment.trim().isEmpty()) {
                        notifContent += " 审核意见：" + reviewComment;
                    }
                    notificationService.sendNotification(
                        demand.getFamilyUserId(),
                        "需求审核通过",
                        notifContent,
                        "DEMAND_REVIEW",
                        "DEMAND",
                        id
                    );
                } catch (Exception ne) {
                    log.warn("Failed to send notification", ne);
                    // 通知发送失败不影响主流程
                }
            }
            
            result.put("success", success);
            result.put("message", success ? "审核通过" : "审核失败");
            return result;
        } catch (Exception e) {
            log.error("Failed to approve demand", e);
            result.put("success", false);
            result.put("message", "系统错误");
            return result;
        }
    }

    /**
     * 审核拒绝
     */
    @PostMapping("/reject/{id}")
    @ResponseBody
    public Map<String, Object> reject(@PathVariable Long id, 
                                      @RequestParam(required = false) String reviewComment,
                                      HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            Demand demand = demandService.findById(id);
            boolean success = demandService.reject(id, currentUser.getId(), reviewComment);
            
            // 发送通知给家属
            if (success && demand != null && notificationService != null) {
                try {
                    String notifContent = "您的需求《" + demand.getTitle() + "》审核未通过。";
                    if (reviewComment != null && !reviewComment.trim().isEmpty()) {
                        notifContent += " 原因：" + reviewComment;
                    }
                    notificationService.sendNotification(
                        demand.getFamilyUserId(),
                        "需求审核未通过",
                        notifContent,
                        "DEMAND_REVIEW",
                        "DEMAND",
                        id
                    );
                } catch (Exception ne) {
                    log.warn("Failed to send notification", ne);
                    // 通知发送失败不影响主流程
                }
            }
            
            result.put("success", success);
            result.put("message", success ? "已拒绝" : "操作失败");
            return result;
        } catch (Exception e) {
            log.error("Failed to reject demand", e);
            result.put("success", false);
            result.put("message", "系统错误");
            return result;
        }
    }

    /**
     * 转换为任务（跳转到任务创建页面）
     */
    @GetMapping("/convert-to-task/{id}")
    public String convertToTask(@PathVariable Long id, 
                                RedirectAttributes redirectAttributes, 
                                HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        try {
            Demand demand = demandService.findById(id);
            if (demand == null) {
                redirectAttributes.addFlashAttribute("error", "需求不存在");
                return "redirect:/admin/demand/list";
            }

            if (!"APPROVED".equals(demand.getStatus())) {
                redirectAttributes.addFlashAttribute("error", "只有已通过的需求才能转换为任务");
                return "redirect:/admin/demand/detail/" + id;
            }

            // 跳转到创建任务页面，并携带需求信息
            return "redirect:/admin/task/create?demandId=" + id;
        } catch (Exception e) {
            log.error("Failed to convert demand to task", e);
            redirectAttributes.addFlashAttribute("error", "系统错误");
            return "redirect:/admin/demand/detail/" + id;
        }
    }
}
