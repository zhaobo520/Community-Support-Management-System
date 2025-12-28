package com.community.web.controller;

import com.community.domain.CarePlan;
import com.community.domain.CarePlanServiceRecord;
import com.community.domain.ElderlyInfo;
import com.community.domain.User;
import com.community.service.CarePlanService;
import com.community.service.CarePlanServiceRecordService;
import com.community.service.ElderlyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 家属端关爱计划控制器
 */
@Controller
@RequestMapping("/family/care-plan")
public class FamilyCarePlanController {

    private static final Logger log = LoggerFactory.getLogger(FamilyCarePlanController.class);

    @Resource
    private CarePlanService carePlanService;

    @Resource
    private CarePlanServiceRecordService recordService;

    @Resource
    private ElderlyService elderlyService;

    /**
     * 获取当前登录的家属用户
     */
    private User getCurrentUser(HttpSession session) {
        User user = (User) session.getAttribute("CURRENT_USER");
        if (user == null || !"FAMILY".equals(user.getRoleType())) {
            return null;
        }
        return user;
    }

    /**
     * 关爱计划列表页面
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String status,
                       Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        List<CarePlan> plans = carePlanService.findByFamilyUserId(currentUser.getId());
        model.addAttribute("plans", plans);
        model.addAttribute("currentStatus", status);

        // 统计数据
        model.addAttribute("totalCount", carePlanService.countByFamilyUserId(currentUser.getId()));
        model.addAttribute("activeCount", carePlanService.countActiveByFamilyUserId(currentUser.getId()));

        return "family/care_plan_list";
    }

    /**
     * 创建关爱计划页面
     */
    @GetMapping("/create")
    public String createPage(Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 获取家属关联的关爱对象列表
        List<ElderlyInfo> elderlyList = elderlyService.findByFamilyUserId(currentUser.getId());
        if (elderlyList == null || elderlyList.isEmpty()) {
            model.addAttribute("error", "您还没有关联的关爱对象信息，请先添加关爱对象信息后再发布关爱计划");
            return "family/care_plan_list";
        }

        model.addAttribute("elderlyList", elderlyList);
        model.addAttribute("plan", new CarePlan());

        return "family/care_plan_create";
    }

    /**
     * 提交创建关爱计划
     */
    @PostMapping("/create")
    public String create(@RequestParam Long elderlyId,
                         @RequestParam String planName,
                         @RequestParam(required = false) String description,
                         @RequestParam(required = false) String serviceType,
                         @RequestParam(required = false) String serviceFrequency,
                         @RequestParam(required = false) String startDate,
                         @RequestParam(required = false) String endDate,
                         @RequestParam(required = false, defaultValue = "WEEKLY") String periodType,
                         @RequestParam(required = false, defaultValue = "1") Integer servicesPerPeriod,
                         @RequestParam(required = false, defaultValue = "1") Integer totalPeriods,
                         HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        try {
            CarePlan plan = new CarePlan();
            plan.setFamilyUserId(currentUser.getId());
            plan.setElderlyId(elderlyId);
            plan.setPlanName(planName);
            plan.setDescription(description);
            plan.setServiceType(serviceType);
            plan.setServiceFrequency(serviceFrequency);
            plan.setPeriodType(periodType);
            plan.setServicesPerPeriod(servicesPerPeriod);
            plan.setTotalPeriods(totalPeriods);
            plan.setCreatedBy(currentUser.getId());

            // 解析日期
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (startDate != null && !startDate.isEmpty()) {
                plan.setStartDate(sdf.parse(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                plan.setEndDate(sdf.parse(endDate));
            }

            boolean success = carePlanService.create(plan);
            if (success) {
                redirectAttributes.addFlashAttribute("message", "关爱计划发布成功，请等待管理员审核");
            } else {
                redirectAttributes.addFlashAttribute("error", "关爱计划发布失败，请重试");
            }
        } catch (ParseException e) {
            log.error("日期解析失败", e);
            redirectAttributes.addFlashAttribute("error", "日期格式错误");
        } catch (Exception e) {
            log.error("创建关爱计划失败", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请重试");
        }

        return "redirect:/family/care-plan/list";
    }

    /**
     * 关爱计划详情页面
     */
    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/family/care-plan/list";
        }

        // 验证权限
        if (!carePlanService.belongsToFamily(id, currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        model.addAttribute("plan", plan);

        // 获取服务记录
        List<CarePlanServiceRecord> records = recordService.findByPlanId(id);
        model.addAttribute("records", records);

        // 按周期分组服务记录
        if (plan.getTotalPeriods() != null && plan.getTotalPeriods() > 0) {
            for (int i = 1; i <= plan.getTotalPeriods(); i++) {
                List<CarePlanServiceRecord> periodRecords = recordService.findByPlanIdAndPeriod(id, i);
                model.addAttribute("period" + i + "Records", periodRecords);
            }
        }

        return "family/care_plan_detail";
    }

    /**
     * 编辑关爱计划页面（只有待审核状态可以编辑）
     */
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/family/care-plan/list";
        }

        // 验证权限
        if (!carePlanService.belongsToFamily(id, currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        // 只有待审核状态可以编辑
        if (!"PENDING".equals(plan.getAuditStatus())) {
            model.addAttribute("error", "只有待审核的计划可以编辑");
            return "redirect:/family/care-plan/detail/" + id;
        }

        // 获取家属关联的关爱对象列表
        List<ElderlyInfo> elderlyList = elderlyService.findByFamilyUserId(currentUser.getId());
        model.addAttribute("elderlyList", elderlyList);
        model.addAttribute("plan", plan);

        return "family/care_plan_edit";
    }

    /**
     * 提交编辑关爱计划
     */
    @PostMapping("/edit/{id}")
    public String edit(@PathVariable Long id,
                       @RequestParam Long elderlyId,
                       @RequestParam String planName,
                       @RequestParam(required = false) String description,
                       @RequestParam(required = false) String serviceType,
                       @RequestParam(required = false) String serviceFrequency,
                       @RequestParam(required = false) String startDate,
                       @RequestParam(required = false) String endDate,
                       @RequestParam(required = false, defaultValue = "WEEKLY") String periodType,
                       @RequestParam(required = false, defaultValue = "1") Integer servicesPerPeriod,
                       @RequestParam(required = false, defaultValue = "1") Integer totalPeriods,
                       HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 验证权限
        if (!carePlanService.belongsToFamily(id, currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        CarePlan existingPlan = carePlanService.findById(id);
        if (existingPlan == null || !"PENDING".equals(existingPlan.getAuditStatus())) {
            redirectAttributes.addFlashAttribute("error", "只有待审核的计划可以编辑");
            return "redirect:/family/care-plan/detail/" + id;
        }

        try {
            CarePlan plan = new CarePlan();
            plan.setId(id);
            plan.setElderlyId(elderlyId);
            plan.setPlanName(planName);
            plan.setDescription(description);
            plan.setServiceType(serviceType);
            plan.setServiceFrequency(serviceFrequency);
            plan.setPeriodType(periodType);
            plan.setServicesPerPeriod(servicesPerPeriod);
            plan.setTotalPeriods(totalPeriods);

            // 解析日期
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (startDate != null && !startDate.isEmpty()) {
                plan.setStartDate(sdf.parse(startDate));
            }
            if (endDate != null && !endDate.isEmpty()) {
                plan.setEndDate(sdf.parse(endDate));
            }

            boolean success = carePlanService.update(plan);
            if (success) {
                redirectAttributes.addFlashAttribute("message", "关爱计划更新成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "关爱计划更新失败");
            }
        } catch (ParseException e) {
            log.error("日期解析失败", e);
            redirectAttributes.addFlashAttribute("error", "日期格式错误");
        } catch (Exception e) {
            log.error("更新关爱计划失败", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请重试");
        }

        return "redirect:/family/care-plan/detail/" + id;
    }

    /**
     * 取消关爱计划（只有待审核或未认领状态可以取消）
     */
    @PostMapping("/cancel/{id}")
    public String cancel(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 验证权限
        if (!carePlanService.belongsToFamily(id, currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/family/care-plan/list";
        }

        // 只有待审核或已审核但未认领的计划可以取消
        if ("PENDING".equals(plan.getAuditStatus()) ||
            ("APPROVED".equals(plan.getAuditStatus()) && "UNCLAIMED".equals(plan.getClaimStatus()))) {
            boolean success = carePlanService.updateStatus(id, "CANCELLED");
            if (success) {
                redirectAttributes.addFlashAttribute("message", "关爱计划已取消");
            } else {
                redirectAttributes.addFlashAttribute("error", "取消失败，请重试");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "当前状态不允许取消");
        }

        return "redirect:/family/care-plan/list";
    }

    /**
     * 删除关爱计划（只有待审核状态可以删除）
     */
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 验证权限
        if (!carePlanService.belongsToFamily(id, currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        CarePlan plan = carePlanService.findById(id);
        if (plan == null) {
            return "redirect:/family/care-plan/list";
        }

        // 只有待审核状态可以删除
        if (!"PENDING".equals(plan.getAuditStatus())) {
            redirectAttributes.addFlashAttribute("error", "只有待审核的计划可以删除");
            return "redirect:/family/care-plan/list";
        }

        boolean success = carePlanService.delete(id);
        if (success) {
            redirectAttributes.addFlashAttribute("message", "关爱计划已删除");
        } else {
            redirectAttributes.addFlashAttribute("error", "删除失败，请重试");
        }

        return "redirect:/family/care-plan/list";
    }

    /**
     * 查看服务记录详情
     */
    @GetMapping("/record/{recordId}")
    public String recordDetail(@PathVariable Long recordId, Model model, HttpSession session) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        CarePlanServiceRecord record = recordService.findById(recordId);
        if (record == null) {
            return "redirect:/family/care-plan/list";
        }

        // 验证权限：检查记录所属计划是否属于当前家属
        if (!carePlanService.belongsToFamily(record.getPlanId(), currentUser.getId())) {
            return "redirect:/family/care-plan/list";
        }

        model.addAttribute("record", record);

        // 获取计划信息
        CarePlan plan = carePlanService.findById(record.getPlanId());
        model.addAttribute("plan", plan);

        return "family/service_record_detail";
    }
}
