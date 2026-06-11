package com.community.web.controller;

import com.community.domain.CarePlan;
import com.community.domain.CarePlanServiceRecord;
import com.community.domain.ElderlyInfo;
import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.service.CarePlanService;
import com.community.service.CarePlanServiceRecordService;
import com.community.service.ElderlyService;
import com.community.service.NotificationService;
import com.community.service.UserService;
import com.community.service.VolunteerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
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
 * 管理员关爱计划管理控制器
 */
@Controller
@RequestMapping("/admin/care-plan")
public class AdminCarePlanController {

    private static final Logger log = LoggerFactory.getLogger(AdminCarePlanController.class);

    @Resource
    private CarePlanService carePlanService;

    @Resource
    private CarePlanServiceRecordService recordService;

    @Resource
    private UserService userService;

    @Resource
    private ElderlyService elderlyService;

    @Resource
    private VolunteerService volunteerService;

    @Resource(name = "notificationService")
    private NotificationService notificationService;

    /**
     * 获取当前管理员用户
     */
    private User getCurrentAdmin(HttpSession session) {
        User user = (User) session.getAttribute("CURRENT_USER");
        if (user == null || !"STAFF".equals(user.getRoleType())) {
            return null;
        }
        return user;
    }

    /**
     * 关爱计划列表页面
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status,
                       @RequestParam(required = false) String auditStatus,
                       Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlan> planList;
        if (auditStatus != null && !auditStatus.isEmpty()) {
            planList = carePlanService.findByAuditStatus(auditStatus);
        } else if (status != null && !status.isEmpty()) {
            planList = carePlanService.findByStatus(status);
        } else {
            planList = carePlanService.findAll();
        }

        Map<String, Object> statistics = carePlanService.getStatistics();

        model.addAttribute("planList", planList != null ? planList : new java.util.ArrayList<>());
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("filterStatus", status);
        model.addAttribute("filterAuditStatus", auditStatus);

        return "admin/care_plan_list";
    }

    /**
     * 待审核计划列表
     */
    @GetMapping("/pending")
    public String pendingList(Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlan> planList = carePlanService.findPendingAudit();
        model.addAttribute("planList", planList != null ? planList : new java.util.ArrayList<>());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("pageTitle", "待审核关爱计划");

        return "admin/care_plan_pending";
    }

    /**
     * 创建关爱计划页面
     */
    @GetMapping("/create")
    public String createPage(Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 获取所有家属用户
        List<User> familyUsers = userService.findByRoleType("FAMILY");
        // 获取所有已审核通过的关爱对象
        List<ElderlyInfo> elderlyList = elderlyService.findApproved();
        // 获取所有已审核通过的志愿者
        List<VolunteerProfile> volunteers = volunteerService.findAll("APPROVED", null);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("familyUsers", familyUsers != null ? familyUsers : new java.util.ArrayList<>());
        model.addAttribute("elderlyList", elderlyList != null ? elderlyList : new java.util.ArrayList<>());
        model.addAttribute("volunteers", volunteers != null ? volunteers : new java.util.ArrayList<>());

        return "admin/care_plan_create";
    }

    /**
     * 创建关爱计划提交
     */
    @PostMapping("/create")
    public String create(CarePlan plan,
                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
                         @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        try {
            plan.setStartDate(startDate);
            plan.setEndDate(endDate);
            plan.setStatus("ACTIVE");
            plan.setAuditStatus("APPROVED");  // 管理员创建的直接审核通过
            plan.setAuditBy(currentUser.getId());
            plan.setAuditTime(new Date());
            plan.setCreatedBy(currentUser.getId());
            if (plan.getCompletedServices() == null) {
                plan.setCompletedServices(0);
            }

            // 如果指定了志愿者，设置认领状态
            if (plan.getAssignedVolunteerId() != null) {
                plan.setClaimStatus("CLAIMED");
                plan.setClaimedTime(new Date());
            }

            boolean success = carePlanService.create(plan);
            if (success) {
                sendPlanNotifications(plan, "创建");
                redirectAttributes.addFlashAttribute("success", "关爱计划创建成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "创建失败，请重试");
            }
        } catch (Exception e) {
            log.error("Create care plan failed", e);
            redirectAttributes.addFlashAttribute("error", "创建失败：" + e.getMessage());
        }

        return "redirect:/admin/care-plan/list";
    }

    /**
     * 关爱计划详情页面
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/admin/care-plan/list";
        }

        // 获取关联的关爱对象信息
        ElderlyInfo elderlyInfo = null;
        if (plan.getElderlyId() != null) {
            elderlyInfo = elderlyService.findById(plan.getElderlyId());
        }

        // 获取家属信息
        User familyUser = null;
        if (plan.getFamilyUserId() != null) {
            familyUser = userService.findById(plan.getFamilyUserId());
        }

        // 获取志愿者信息
        User volunteer = null;
        if (plan.getAssignedVolunteerId() != null) {
            volunteer = userService.findById(plan.getAssignedVolunteerId());
        }

        // 获取服务记录
        List<CarePlanServiceRecord> records = recordService.findByPlanId(id);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("plan", plan);
        model.addAttribute("elderlyInfo", elderlyInfo);
        model.addAttribute("familyUser", familyUser);
        model.addAttribute("volunteer", volunteer);
        model.addAttribute("records", records != null ? records : new java.util.ArrayList<>());

        return "admin/care_plan_detail";
    }

    /**
     * 编辑关爱计划页面
     */
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/admin/care-plan/list";
        }

        // 获取所有家属用户
        List<User> familyUsers = userService.findByRoleType("FAMILY");
        // 获取所有已审核通过的关爱对象
        List<ElderlyInfo> elderlyList = elderlyService.findApproved();
        // 获取所有已审核通过的志愿者
        List<VolunteerProfile> volunteers = volunteerService.findAll("APPROVED", null);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("plan", plan);
        model.addAttribute("familyUsers", familyUsers != null ? familyUsers : new java.util.ArrayList<>());
        model.addAttribute("elderlyList", elderlyList != null ? elderlyList : new java.util.ArrayList<>());
        model.addAttribute("volunteers", volunteers != null ? volunteers : new java.util.ArrayList<>());

        return "admin/care_plan_edit";
    }

    /**
     * 编辑关爱计划提交
     */
    @PostMapping("/edit")
    public String edit(CarePlan plan,
                       @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
                       @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        try {
            plan.setStartDate(startDate);
            plan.setEndDate(endDate);

            boolean success = carePlanService.update(plan);
            if (success) {
                redirectAttributes.addFlashAttribute("success", "关爱计划更新成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "更新失败，请重试");
            }
        } catch (Exception e) {
            log.error("Update care plan failed", e);
            redirectAttributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
        }

        return "redirect:/admin/care-plan/detail/" + plan.getId();
    }

    /**
     * 审核关爱计划页面
     */
    @GetMapping("/audit/{id}")
    public String auditPage(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/admin/care-plan/list";
        }

        // 获取关联信息
        ElderlyInfo elderlyInfo = null;
        if (plan.getElderlyId() != null) {
            elderlyInfo = elderlyService.findById(plan.getElderlyId());
        }

        User familyUser = null;
        if (plan.getFamilyUserId() != null) {
            familyUser = userService.findById(plan.getFamilyUserId());
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("plan", plan);
        model.addAttribute("elderlyInfo", elderlyInfo);
        model.addAttribute("familyUser", familyUser);

        return "admin/care_plan_audit";
    }

    /**
     * 审核关爱计划提交
     */
    @PostMapping("/audit/{id}")
    public String audit(@PathVariable Long id,
                        @RequestParam String auditStatus,
                        @RequestParam(required = false) String auditRemark,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        try {
            boolean success = carePlanService.audit(id, auditStatus, currentUser.getId(), auditRemark);
            if (success) {
                // 发送通知给家属
                CarePlan plan = carePlanService.findById(id);
                if (plan != null && plan.getFamilyUserId() != null && notificationService != null) {
                    String statusText = "APPROVED".equals(auditStatus) ? "审核通过" : "审核拒绝";
                    String message = "您的关爱计划《" + plan.getPlanName() + "》" + statusText;
                    if (auditRemark != null && !auditRemark.isEmpty()) {
                        message += "，备注：" + auditRemark;
                    }
                    try {
                        notificationService.sendNotification(
                                plan.getFamilyUserId(),
                                "关爱计划审核结果",
                                message,
                                "CARE_PLAN",
                                "CARE_PLAN",
                                id
                        );
                    } catch (Exception ne) {
                        log.warn("Failed to send notification", ne);
                    }
                }
                redirectAttributes.addFlashAttribute("success", "审核完成");
            } else {
                redirectAttributes.addFlashAttribute("error", "审核失败，请重试");
            }
        } catch (Exception e) {
            log.error("Audit care plan failed", e);
            redirectAttributes.addFlashAttribute("error", "审核失败：" + e.getMessage());
        }

        return "redirect:/admin/care-plan/pending";
    }

    /**
     * 快速审核通过（AJAX）
     */
    @PostMapping("/approve/{id}")
    @ResponseBody
    public Map<String, Object> approve(@PathVariable Long id,
                                       @RequestParam(required = false) String remark,
                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = carePlanService.approve(id, currentUser.getId(), remark);
            result.put("success", success);
            result.put("message", success ? "审核通过" : "审核失败");
        } catch (Exception e) {
            log.error("Approve care plan failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 快速审核拒绝（AJAX）
     */
    @PostMapping("/reject/{id}")
    @ResponseBody
    public Map<String, Object> reject(@PathVariable Long id,
                                      @RequestParam(required = false) String remark,
                                      HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = carePlanService.reject(id, currentUser.getId(), remark);
            result.put("success", success);
            result.put("message", success ? "已拒绝" : "操作失败");
        } catch (Exception e) {
            log.error("Reject care plan failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 更新计划状态
     */
    @PostMapping("/status/{id}")
    @ResponseBody
    public Map<String, Object> updateStatus(@PathVariable Long id,
                                            @RequestParam String status,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = carePlanService.updateStatus(id, status);
            result.put("success", success);
            result.put("message", success ? "状态更新成功" : "更新失败");

            // 发送通知
            if (success && notificationService != null) {
                CarePlan plan = carePlanService.findById(id);
                if (plan != null && plan.getFamilyUserId() != null) {
                    String statusText = "ACTIVE".equals(status) ? "进行中" :
                            "COMPLETED".equals(status) ? "已完成" : "已取消";
                    try {
                        notificationService.sendNotification(
                                plan.getFamilyUserId(),
                                "关爱计划状态更新",
                                "您的关爱计划《" + plan.getPlanName() + "》状态已更新为：" + statusText,
                                "CARE_PLAN",
                                "CARE_PLAN",
                                id
                        );
                    } catch (Exception ne) {
                        log.warn("Failed to send notification", ne);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Update status failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 删除关爱计划
     */
    @PostMapping("/delete/{id}")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = carePlanService.delete(id);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            log.error("Delete care plan failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    // ==================== 服务记录审核 ====================

    /**
     * 待审核服务记录列表
     */
    @GetMapping("/record/delete/{id}")
    public String deleteRecord(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        CarePlanServiceRecord record = recordService.findById(id);
        if (record != null) {
            recordService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "服务记录已成功删除");
            return "redirect:/admin/care-plan/" + record.getPlanId();
        }
        return "redirect:/admin/care-plan/list";
    }

    @GetMapping("/records/pending")
    public String pendingRecords(Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlanServiceRecord> records = recordService.findPendingAudit();
        model.addAttribute("records", records != null ? records : new java.util.ArrayList<>());
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("pendingCount", recordService.countPendingAudit());

        return "admin/service_record_pending";
    }

    /**
     * 服务记录详情
     */
    @GetMapping("/record/{id}")
    public String recordDetail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlanServiceRecord record = recordService.findById(id);
        if (record == null) {
            return "redirect:/admin/care-plan/records/pending";
        }

        // 获取计划信息
        CarePlan plan = carePlanService.findById(record.getPlanId());

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("record", record);
        model.addAttribute("plan", plan);

        return "admin/service_record_detail";
    }

    /**
     * 审核服务记录
     */
    @PostMapping("/record/audit/{id}")
    public String auditRecord(@PathVariable Long id,
                              @RequestParam String auditStatus,
                              @RequestParam(required = false) String auditRemark,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentAdmin(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        try {
            boolean success = recordService.audit(id, auditStatus, currentUser.getId(), auditRemark);
            if (success) {
                // 发送通知给志愿者
                CarePlanServiceRecord record = recordService.findById(id);
                if (record != null && record.getVolunteerId() != null && notificationService != null) {
                    String statusText = "APPROVED".equals(auditStatus) ? "审核通过" : "审核拒绝";
                    try {
                        notificationService.sendNotification(
                                record.getVolunteerId(),
                                "服务记录审核结果",
                                "您提交的服务记录" + statusText,
                                "SERVICE_RECORD",
                                "SERVICE_RECORD",
                                id
                        );
                    } catch (Exception ne) {
                        log.warn("Failed to send notification", ne);
                    }
                }
                redirectAttributes.addFlashAttribute("success", "审核完成");
            } else {
                redirectAttributes.addFlashAttribute("error", "审核失败，请重试");
            }
        } catch (Exception e) {
            log.error("Audit service record failed", e);
            redirectAttributes.addFlashAttribute("error", "审核失败：" + e.getMessage());
        }

        return "redirect:/admin/care-plan/records/pending";
    }

    /**
     * 快速审核服务记录通过（AJAX）
     */
    @PostMapping("/record/approve/{id}")
    @ResponseBody
    public Map<String, Object> approveRecord(@PathVariable Long id,
                                             @RequestParam(required = false) String remark,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = recordService.approve(id, currentUser.getId(), remark);
            result.put("success", success);
            result.put("message", success ? "审核通过" : "审核失败");
        } catch (Exception e) {
            log.error("Approve service record failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 快速审核服务记录拒绝（AJAX）
     */
    @PostMapping("/record/reject/{id}")
    @ResponseBody
    public Map<String, Object> rejectRecord(@PathVariable Long id,
                                            @RequestParam(required = false) String remark,
                                            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentAdmin(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = recordService.reject(id, currentUser.getId(), remark);
            result.put("success", success);
            result.put("message", success ? "已拒绝" : "操作失败");
        } catch (Exception e) {
            log.error("Reject service record failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 根据家属ID获取关爱对象列表（AJAX）
     */
    @GetMapping("/elderly-by-family/{familyUserId}")
    @ResponseBody
    public List<ElderlyInfo> getElderlyByFamily(@PathVariable Long familyUserId) {
        try {
            return elderlyService.findByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Get elderly by family failed", e);
            return new java.util.ArrayList<>();
        }
    }

    /**
     * 发送计划相关通知
     */
    private void sendPlanNotifications(CarePlan plan, String action) {
        if (notificationService == null) return;

        try {
            // 通知家属
            if (plan.getFamilyUserId() != null) {
                notificationService.sendNotification(
                        plan.getFamilyUserId(),
                        "关爱计划" + action,
                        "管理员为您" + action + "了关爱计划：" + plan.getPlanName(),
                        "CARE_PLAN",
                        "CARE_PLAN",
                        plan.getId()
                );
            }

            // 通知志愿者
            if (plan.getAssignedVolunteerId() != null) {
                notificationService.sendNotification(
                        plan.getAssignedVolunteerId(),
                        "关爱计划分配",
                        "您被分配了关爱计划：" + plan.getPlanName(),
                        "CARE_PLAN",
                        "CARE_PLAN",
                        plan.getId()
                );
            }
        } catch (Exception e) {
            log.warn("Failed to send notifications", e);
        }
    }
}
