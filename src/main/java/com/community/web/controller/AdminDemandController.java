package com.community.web.controller;

import com.community.domain.Demand;
import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.service.DemandService;
import com.community.service.NotificationService;
import com.community.service.VolunteerService;
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

    @Resource
    private VolunteerService volunteerService;

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
            demandList = demandService.findByStatus(status);
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
     * 管理员编辑需求页面
     */
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        Demand demand = demandService.findById(id);
        if (demand == null) {
            return "redirect:/admin/demand/list";
        }

        // 获取已审核通过的志愿者列表，供意向选择
        List<VolunteerProfile> volunteerList = volunteerService.findAll("APPROVED", null);
        model.addAttribute("volunteerList", volunteerList);

        model.addAttribute("demand", demand);
        model.addAttribute("currentUser", currentUser);
        return "demand/admin_edit";
    }

    /**
     * 管理员更新需求
     */
    @PostMapping("/update")
    public String update(Demand demand, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        try {
            Demand existing = demandService.findById(demand.getId());
            if (existing == null) {
                redirectAttributes.addFlashAttribute("error", "需求不存在");
                return "redirect:/admin/demand/list";
            }

            demand.setFamilyUserId(existing.getFamilyUserId());
            if (demand.getTargetId() == null) {
                demand.setTargetId(existing.getTargetId());
            }
            if (demand.getStatus() == null || demand.getStatus().trim().isEmpty()) {
                demand.setStatus(existing.getStatus());
            }
            if (demand.getTaskId() == null) {
                demand.setTaskId(existing.getTaskId());
            }
            if (demand.getReviewerId() == null) {
                demand.setReviewerId(existing.getReviewerId());
            }
            if (demand.getReviewTime() == null) {
                demand.setReviewTime(existing.getReviewTime());
            }
            if (demand.getReviewComment() == null) {
                demand.setReviewComment(existing.getReviewComment());
            }
            if (demand.getAttachmentUrl() == null) {
                demand.setAttachmentUrl(existing.getAttachmentUrl());
            }

            boolean success = demandService.update(demand);
            if (success) {
                redirectAttributes.addFlashAttribute("msg", "需求修改成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "需求修改失败");
            }
            return "redirect:/admin/demand/detail/" + demand.getId();
        } catch (Exception e) {
            log.error("Failed to update demand by admin", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试");
            return "redirect:/admin/demand/edit/" + demand.getId();
        }
    }

    /**
     * 管理员删除需求
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            Demand demand = demandService.findById(id);
            if (demand == null) {
                result.put("success", false);
                result.put("message", "需求不存在");
                return result;
            }

            if (demand.getTaskId() != null || "MATCHED".equals(demand.getStatus())) {
                result.put("success", false);
                result.put("message", "该需求已关联任务，不能直接删除");
                return result;
            }

            boolean success = demandService.delete(id);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
            return result;
        } catch (Exception e) {
            log.error("Failed to delete demand by admin", e);
            result.put("success", false);
            result.put("message", "系统错误");
            return result;
        }
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

            return "redirect:/admin/task/create?demandId=" + id;
        } catch (Exception e) {
            log.error("Failed to convert demand to task", e);
            redirectAttributes.addFlashAttribute("error", "系统错误");
            return "redirect:/admin/demand/detail/" + id;
        }
    }
}
