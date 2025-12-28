package com.community.web.controller;

import com.community.domain.Feedback;
import com.community.domain.User;
import com.community.service.FeedbackService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Admin Feedback Management Controller
 */
@Controller
@RequestMapping("/admin/feedback")
public class AdminFeedbackController {

    private static final Logger log = LoggerFactory.getLogger(AdminFeedbackController.class);

    @Resource
    private FeedbackService feedbackService;

    /**
     * Admin feedback list page
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status,
                       @RequestParam(required = false) String type,
                       Model model,
                       HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        // Get all feedbacks
        List<Feedback> feedbacks = feedbackService.findAll();

        // Filter by status if specified
        if (status != null && !status.isEmpty()) {
            feedbacks = feedbacks.stream()
                    .filter(f -> status.equals(f.getStatus()))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Filter by type if specified
        if (type != null && !type.isEmpty()) {
            feedbacks = feedbacks.stream()
                    .filter(f -> type.equals(f.getFeedbackType()))
                    .collect(java.util.stream.Collectors.toList());
        }

        // Count statistics
        int totalCount = feedbackService.countAll();
        int pendingCount = feedbackService.countByStatus("PENDING");
        int processingCount = feedbackService.countByStatus("PROCESSING");
        int resolvedCount = feedbackService.countByStatus("RESOLVED");

        model.addAttribute("feedbacks", feedbacks);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("processingCount", processingCount);
        model.addAttribute("resolvedCount", resolvedCount);
        model.addAttribute("currentStatus", status);
        model.addAttribute("currentType", type);
        model.addAttribute("currentUser", currentUser);

        return "admin/feedback_list";
    }

    /**
     * Admin feedback detail page
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        Feedback feedback = feedbackService.findById(id);
        if (feedback == null) {
            return "redirect:/admin/feedback/list";
        }

        model.addAttribute("feedback", feedback);
        model.addAttribute("currentUser", currentUser);

        return "admin/feedback_detail";
    }

    /**
     * Admin respond to feedback
     */
    @PostMapping("/respond/{id}")
    public String respond(@PathVariable Long id,
                          @RequestParam String response,
                          @RequestParam String status,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        try {
            Feedback feedback = new Feedback();
            feedback.setId(id);
            feedback.setResponse(response);
            feedback.setStatus(status);
            feedback.setRespondedBy(currentUser.getId());
            feedback.setRespondedAt(new Date());

            boolean success = feedbackService.update(feedback);
            if (success) {
                redirectAttributes.addFlashAttribute("msg", "回复成功！");
            } else {
                redirectAttributes.addFlashAttribute("error", "回复失败，请重试");
            }
        } catch (Exception e) {
            log.error("Respond to feedback failed", e);
            redirectAttributes.addFlashAttribute("error", "回复失败：" + e.getMessage());
        }

        return "redirect:/admin/feedback/detail/" + id;
    }

    /**
     * Update feedback status (AJAX)
     */
    @PostMapping("/updateStatus")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam Long id,
                                             @RequestParam String status,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "权限不足");
            return result;
        }

        try {
            Feedback feedback = new Feedback();
            feedback.setId(id);
            feedback.setStatus(status);

            boolean success = feedbackService.update(feedback);
            result.put("success", success);
            result.put("message", success ? "状态更新成功" : "状态更新失败");
        } catch (Exception e) {
            log.error("Update feedback status failed", e);
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
        }

        return result;
    }
}
