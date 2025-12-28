package com.community.web.controller;

import com.community.domain.Appeal;
import com.community.domain.User;
import com.community.service.AppealService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Admin Appeal Management Controller
 */
@Controller
@RequestMapping("/admin/appeal")
public class AdminAppealController {

    private static final Logger log = LoggerFactory.getLogger(AdminAppealController.class);

    @Resource
    private AppealService appealService;

    /**
     * Appeal list page
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status,
                       @RequestParam(required = false) String userRole,
                       @RequestParam(required = false) String username,
                       Model model,
                       HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        // Get all appeals
        List<Appeal> appeals = appealService.findAll();

        // Filter by status if specified
        if (status != null && !status.isEmpty()) {
            appeals = appeals.stream()
                    .filter(a -> status.equals(a.getStatus()))
                    .collect(Collectors.toList());
        }

        // Filter by user role if specified
        if (userRole != null && !userRole.isEmpty()) {
            appeals = appeals.stream()
                    .filter(a -> userRole.equals(a.getUserRole()))
                    .collect(Collectors.toList());
        }

        // Filter by username if specified
        if (username != null && !username.isEmpty()) {
            appeals = appeals.stream()
                    .filter(a -> a.getUsername() != null && a.getUsername().contains(username))
                    .collect(Collectors.toList());
        }

        // Count by status
        int pendingCount = (int) appeals.stream().filter(a -> "PENDING".equals(a.getStatus())).count();
        int processingCount = (int) appeals.stream().filter(a -> "PROCESSING".equals(a.getStatus())).count();
        int resolvedCount = (int) appeals.stream().filter(a -> "RESOLVED".equals(a.getStatus())).count();
        int rejectedCount = (int) appeals.stream().filter(a -> "REJECTED".equals(a.getStatus())).count();

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("appeals", appeals);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("processingCount", processingCount);
        model.addAttribute("resolvedCount", resolvedCount);
        model.addAttribute("rejectedCount", rejectedCount);

        return "admin/appeal_list";
    }

    /**
     * Appeal detail page
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id,
                        Model model,
                        HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        Appeal appeal = appealService.findById(id);
        if (appeal == null) {
            return "error/404";
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("appeal", appeal);

        return "admin/appeal_detail";
    }

    /**
     * Review appeal (update status and response)
     */
    @PostMapping("/review")
    public String review(@RequestParam Long id,
                        @RequestParam String status,
                        @RequestParam String response,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/admin/login";
        }

        try {
            Appeal appeal = appealService.findById(id);
            if (appeal == null) {
                redirectAttributes.addFlashAttribute("error", "申诉不存在");
                return "redirect:/admin/appeal/list";
            }

            appeal.setStatus(status);
            appeal.setResponse(response);
            appeal.setRespondedBy(currentUser.getId());
            appeal.setRespondedAt(new Date());

            boolean success = appealService.review(appeal);
            if (success) {
                redirectAttributes.addFlashAttribute("msg", "申诉已处理");
                log.info("Appeal {} reviewed by user {}", id, currentUser.getId());
            } else {
                redirectAttributes.addFlashAttribute("error", "处理失败，请稍后重试");
            }
        } catch (Exception e) {
            log.error("Review appeal failed", e);
            redirectAttributes.addFlashAttribute("error", "处理失败：" + e.getMessage());
        }

        return "redirect:/admin/appeal/detail/" + id;
    }
}
