package com.community.web.controller;

import com.community.domain.CarePlan;
import com.community.domain.CarePlanServiceRecord;
import com.community.domain.ElderlyInfo;
import com.community.domain.User;
import com.community.service.CarePlanService;
import com.community.service.CarePlanServiceRecordService;
import com.community.service.ElderlyService;
import com.community.service.NotificationService;
import com.community.service.SysFileService;
import com.community.service.UserService;
import com.community.dao.CarePlanServiceRecordMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 志愿者关爱计划控制器
 */
@Controller
@RequestMapping("/volunteer/care-plan")
public class VolunteerCarePlanController {

    private static final Logger log = LoggerFactory.getLogger(VolunteerCarePlanController.class);

    @Resource
    private SysFileService sysFileService;

    @Resource
    private CarePlanService carePlanService;

    @Resource
    private CarePlanServiceRecordService recordService;

    @Resource
    private CarePlanServiceRecordMapper recordMapper;

    @Resource
    private UserService userService;

    @Resource
    private ElderlyService elderlyService;

    @Resource(name = "notificationService")
    private NotificationService notificationService;

    /**
     * 获取当前志愿者用户
     */
    private User getCurrentVolunteer(HttpSession session) {
        User user = (User) session.getAttribute("CURRENT_USER");
        if (user == null || !"VOLUNTEER".equals(user.getRoleType())) {
            return null;
        }
        return user;
    }

    /**
     * 接单大厅 - 查看可认领的计划
     */
    @GetMapping("/hall")
    public String claimHall(Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlan> claimablePlans = carePlanService.findClaimable();
        int claimableCount = carePlanService.countClaimable();

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("planList", claimablePlans != null ? claimablePlans : new ArrayList<>());
        model.addAttribute("claimableCount", claimableCount);

        return "volunteer/care_plan_hall";
    }

    /**
     * 认领计划
     */
    @PostMapping("/claim/{id}")
    @ResponseBody
    public Map<String, Object> claimPlan(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentVolunteer(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            // 检查计划是否可以被认领
            if (!carePlanService.canBeClaimed(id)) {
                result.put("success", false);
                result.put("message", "该计划不可认领");
                return result;
            }

            boolean success = carePlanService.claim(id, currentUser.getId());
            result.put("success", success);

            if (success) {
                result.put("message", "认领成功");

                // 发送通知给家属
                CarePlan plan = carePlanService.findById(id);
                if (plan != null && plan.getFamilyUserId() != null && notificationService != null) {
                    try {
                        notificationService.sendNotification(
                                plan.getFamilyUserId(),
                                "关爱计划已被认领",
                                "您的关爱计划《" + plan.getPlanName() + "》已被志愿者" + currentUser.getFullName() + "认领",
                                "CARE_PLAN",
                                "CARE_PLAN",
                                id
                        );
                    } catch (Exception ne) {
                        log.warn("Failed to send notification", ne);
                    }
                }
            } else {
                result.put("message", "认领失败，请重试");
            }
        } catch (Exception e) {
            log.error("Claim plan failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 我的关爱计划列表
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status, Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlan> planList = carePlanService.findByVolunteerId(currentUser.getId());

        // 根据状态过滤
        if (status != null && !status.isEmpty() && planList != null) {
            planList.removeIf(p -> !status.equals(p.getStatus()));
        }

        // 统计
        int totalPlans = carePlanService.countByVolunteerId(currentUser.getId());
        int activePlans = carePlanService.countActiveByVolunteerId(currentUser.getId());
        int claimableCount = carePlanService.countClaimable();

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("planList", planList != null ? planList : new ArrayList<>());
        model.addAttribute("totalPlans", totalPlans);
        model.addAttribute("activePlans", activePlans);
        model.addAttribute("claimableCount", claimableCount);
        model.addAttribute("filterStatus", status);

        return "volunteer/care_plan_list";
    }

    /**
     * 关爱计划详情
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null || !currentUser.getId().equals(plan.getAssignedVolunteerId())) {
            return "redirect:/volunteer/care-plan/list";
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

        // 获取服务记录
        List<CarePlanServiceRecord> records = recordService.findByPlanId(id);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("plan", plan);
        model.addAttribute("elderlyInfo", elderlyInfo);
        model.addAttribute("familyUser", familyUser);
        model.addAttribute("records", records != null ? records : new ArrayList<>());

        return "volunteer/care_plan_detail";
    }

    /**
     * 提交服务记录页面
     */
    @GetMapping("/submit-record/{planId}")
    public String submitRecordPage(@PathVariable Long planId, Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(planId);
        if (plan == null || !currentUser.getId().equals(plan.getAssignedVolunteerId())) {
            return "redirect:/volunteer/care-plan/list";
        }

        if (!"ACTIVE".equals(plan.getStatus())) {
            model.addAttribute("error", "只有进行中的计划才能提交服务记录");
            return "redirect:/volunteer/care-plan/detail/" + planId;
        }

        // 获取关爱对象信息
        ElderlyInfo elderlyInfo = null;
        if (plan.getElderlyId() != null) {
            elderlyInfo = elderlyService.findById(plan.getElderlyId());
        }

        // 获取下一个服务编号
        int currentPeriod = plan.getCurrentPeriod() != null ? plan.getCurrentPeriod() : 1;
        int nextServiceNumber = recordMapper.getNextServiceNumber(planId, currentPeriod);

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("plan", plan);
        model.addAttribute("elderlyInfo", elderlyInfo);
        model.addAttribute("currentPeriod", currentPeriod);
        model.addAttribute("nextServiceNumber", nextServiceNumber);
        model.addAttribute("today", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));

        return "volunteer/submit_service_record";
    }

    /**
     * 提交服务记录
     */
    @PostMapping("/submit-record/{planId}")
    public String submitRecord(@PathVariable Long planId,
                               @RequestParam String serviceDate,
                               @RequestParam(required = false) String serviceTimeStart,
                               @RequestParam(required = false) String serviceTimeEnd,
                               @RequestParam String serviceContent,
                               @RequestParam(required = false) String elderlyCondition,
                               @RequestParam(required = false) String remarks,
                               @RequestParam(required = false) MultipartFile[] photos,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(planId);
        if (plan == null || !currentUser.getId().equals(plan.getAssignedVolunteerId())) {
            return "redirect:/volunteer/care-plan/list";
        }

        try {
            // 验证照片是否上传
            boolean hasPhotos = false;
            if (photos != null && photos.length > 0) {
                for (MultipartFile photo : photos) {
                    if (!photo.isEmpty()) {
                        hasPhotos = true;
                        break;
                    }
                }
            }
            if (!hasPhotos) {
                redirectAttributes.addFlashAttribute("error", "请至少上传一张服务照片作为审核依据");
                return "redirect:/volunteer/care-plan/submit-record/" + planId;
            }

            CarePlanServiceRecord record = new CarePlanServiceRecord();
            record.setPlanId(planId);
            record.setVolunteerId(currentUser.getId());
            record.setPeriodNumber(plan.getCurrentPeriod() != null ? plan.getCurrentPeriod() : 1);
            record.setServiceNumber(recordMapper.getNextServiceNumber(planId, record.getPeriodNumber()));
            record.setServiceContent(serviceContent);
            record.setElderlyCondition(elderlyCondition);
            record.setRemarks(remarks);

            // 解析日期
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            record.setServiceDate(sdf.parse(serviceDate));

            // 解析时间
            if (serviceTimeStart != null && !serviceTimeStart.isEmpty()) {
                record.setServiceTimeStart(Time.valueOf(serviceTimeStart + ":00"));
            }
            if (serviceTimeEnd != null && !serviceTimeEnd.isEmpty()) {
                record.setServiceTimeEnd(Time.valueOf(serviceTimeEnd + ":00"));
            }

            // 处理照片上传
            if (photos != null && photos.length > 0) {
                List<String> photoUrls = new ArrayList<>();
                for (MultipartFile photo : photos) {
                    if (!photo.isEmpty()) {
                        String photoUrl = savePhoto(photo, planId);
                        if (photoUrl != null) {
                            photoUrls.add(photoUrl);
                        }
                    }
                }
                if (!photoUrls.isEmpty()) {
                    record.setServicePhotos(String.join(",", photoUrls));
                }
            }

            boolean success = recordService.create(record);
            if (success) {
                redirectAttributes.addFlashAttribute("message", "服务记录提交成功，请等待管理员审核");

                // 发送通知给家属
                if (plan.getFamilyUserId() != null && notificationService != null) {
                    try {
                        notificationService.sendNotification(
                                plan.getFamilyUserId(),
                                "新服务记录",
                                "志愿者为您的关爱计划《" + plan.getPlanName() + "》提交了新的服务记录",
                                "SERVICE_RECORD",
                                "SERVICE_RECORD",
                                record.getId()
                        );
                    } catch (Exception ne) {
                        log.warn("Failed to send notification", ne);
                    }
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "提交失败，请重试");
            }
        } catch (ParseException e) {
            log.error("Date parse error", e);
            redirectAttributes.addFlashAttribute("error", "日期格式错误");
        } catch (Exception e) {
            log.error("Submit service record failed", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请重试");
        }

        return "redirect:/volunteer/care-plan/detail/" + planId;
    }

    /**
     * 保存照片到数据库，返回访问URL
     */
    private String savePhoto(MultipartFile photo, Long planId) {
        try {
            Long fileId = sysFileService.upload(photo, null);
            if (fileId != null) {
                // 提取扩展名方便前端识别类型
                String ext = "";
                String originalName = photo.getOriginalFilename();
                if (originalName != null && originalName.contains(".")) {
                    ext = originalName.substring(originalName.lastIndexOf("."));
                }
                log.info("Photo saved to database: fileId={}, planId={}", fileId, planId);
                return "/file/view/" + fileId + ext;
            }
            return null;
        } catch (Exception e) {
            log.error("Save photo failed", e);
            return null;
        }
    }

    /**
     * 查看服务记录详情
     */
    @GetMapping("/record/{recordId}")
    public String recordDetail(@PathVariable Long recordId, Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlanServiceRecord record = recordService.findById(recordId);
        if (record == null || !recordService.belongsToVolunteer(recordId, currentUser.getId())) {
            return "redirect:/volunteer/care-plan/list";
        }

        CarePlan plan = carePlanService.findById(record.getPlanId());

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("record", record);
        model.addAttribute("plan", plan);

        return "volunteer/service_record_detail";
    }

    /**
     * 删除服务记录（只能删除待审核的）
     */
    @PostMapping("/record/delete/{recordId}")
    @ResponseBody
    public Map<String, Object> deleteRecord(@PathVariable Long recordId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentVolunteer(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            CarePlanServiceRecord record = recordService.findById(recordId);
            if (record == null || !currentUser.getId().equals(record.getVolunteerId())) {
                result.put("success", false);
                result.put("message", "无权操作此记录");
                return result;
            }

            if (!"PENDING".equals(record.getAuditStatus())) {
                result.put("success", false);
                result.put("message", "只能删除待审核的记录");
                return result;
            }

            boolean success = recordService.delete(recordId);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
        } catch (Exception e) {
            log.error("Delete record failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }

    /**
     * 我的服务记录列表
     */
    @GetMapping("/records")
    public String myRecords(@RequestParam(required = false) String auditStatus,
                            Model model, HttpSession session) {
        User currentUser = getCurrentVolunteer(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlanServiceRecord> records = recordService.findByVolunteerId(currentUser.getId());

        // 根据审核状态过滤
        if (auditStatus != null && !auditStatus.isEmpty() && records != null) {
            records.removeIf(r -> !auditStatus.equals(r.getAuditStatus()));
        }

        model.addAttribute("currentUser", currentUser);
        model.addAttribute("records", records != null ? records : new ArrayList<>());
        model.addAttribute("filterAuditStatus", auditStatus);
        model.addAttribute("totalRecords", recordService.countByVolunteerId(currentUser.getId()));

        return "volunteer/my_service_records";
    }

    /**
     * 取消认领（只有没有服务记录时可以取消）
     */
    @PostMapping("/unclaim/{id}")
    @ResponseBody
    public Map<String, Object> unclaimPlan(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = getCurrentVolunteer(session);

        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            boolean success = carePlanService.unclaim(id, currentUser.getId());
            result.put("success", success);
            result.put("message", success ? "取消认领成功" : "取消认领失败，可能已有服务记录");
        } catch (Exception e) {
            log.error("Unclaim plan failed", e);
            result.put("success", false);
            result.put("message", "系统错误");
        }

        return result;
    }
}
