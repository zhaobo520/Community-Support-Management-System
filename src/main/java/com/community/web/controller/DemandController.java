package com.community.web.controller;

import com.community.domain.Demand;
import com.community.domain.ElderlyInfo;
import com.community.domain.User;
import com.community.service.DemandService;
import com.community.service.ElderlyService;
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
 * 需求控制器 - 家属发布和查看需求
 */
@Controller
@RequestMapping("/demand")
public class DemandController {

    private static final Logger log = LoggerFactory.getLogger(DemandController.class);

    @Resource
    private DemandService demandService;

    @Resource
    private ElderlyService elderlyService;

    /**
     * 家属需求列表页面
     */
    @GetMapping("/family/list")
    public String familyList(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        List<Demand> demandList = demandService.findByFamilyUserId(currentUser.getId());
        Map<String, Object> statistics = demandService.getStatistics(currentUser.getId());

        model.addAttribute("demandList", demandList);
        model.addAttribute("statistics", statistics);
        model.addAttribute("currentUser", currentUser);
        
        return "demand/family_list";
    }

    /**
     * 发布需求页面
     */
    @GetMapping("/family/create")
    public String createPage(@RequestParam(required = false) Long elderlyId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        // 获取家属已审核通过的关爱人员列表
        List<ElderlyInfo> elderlyList = elderlyService.findApprovedByFamilyUserId(currentUser.getId());
        model.addAttribute("elderlyList", elderlyList);
        model.addAttribute("currentUser", currentUser);

        // 如果指定了关爱人员ID，预选该人员
        if (elderlyId != null) {
            model.addAttribute("selectedElderlyId", elderlyId);
        }

        // 如果没有已审核通过的关爱人员，提示用户先添加
        if (elderlyList == null || elderlyList.isEmpty()) {
            model.addAttribute("noElderly", true);
        }

        return "demand/family_create";
    }

    /**
     * 提交需求
     */
    @PostMapping("/family/create")
    public String create(Demand demand, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        try {
            demand.setFamilyUserId(currentUser.getId());
            demand.setStatus("PENDING");
            
            boolean success = demandService.create(demand);
            if (success) {
                redirectAttributes.addFlashAttribute("msg", "需求发布成功！等待管理员审核");
                return "redirect:/demand/family/list";
            } else {
                redirectAttributes.addFlashAttribute("error", "需求发布失败，请重试");
                return "redirect:/demand/family/create";
            }
        } catch (Exception e) {
            log.error("Failed to create demand", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试");
            return "redirect:/demand/family/create";
        }
    }

    /**
     * 需求详情页面
     */
    @GetMapping("/family/detail/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        Demand demand = demandService.findById(id);
        if (demand == null) {
            return "redirect:/demand/family/list";
        }

        // 检查需求是否属于当前家属
        if (!demand.getFamilyUserId().equals(currentUser.getId())) {
            return "redirect:/demand/family/list";
        }

        model.addAttribute("demand", demand);
        model.addAttribute("currentUser", currentUser);
        
        return "demand/family_detail";
    }

    /**
     * 编辑需求页面
     */
    @GetMapping("/family/edit/{id}")
    public String editPage(@PathVariable Long id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        Demand demand = demandService.findById(id);
        if (demand == null || !demand.getFamilyUserId().equals(currentUser.getId())) {
            return "redirect:/demand/family/list";
        }

        // 只有待审核的需求才能编辑
        if (!"PENDING".equals(demand.getStatus())) {
            return "redirect:/demand/family/detail/" + id;
        }

        model.addAttribute("demand", demand);
        model.addAttribute("currentUser", currentUser);
        
        return "demand/family_edit";
    }

    /**
     * 更新需求
     */
    @PostMapping("/family/update")
    public String update(Demand demand, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        try {
            Demand existing = demandService.findById(demand.getId());
            if (existing == null || !existing.getFamilyUserId().equals(currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "无权限操作此需求");
                return "redirect:/demand/family/list";
            }

            // 编辑后需要重新审核
            demand.setStatus("PENDING");
            demand.setReviewerId(null);
            demand.setReviewTime(null);
            demand.setReviewComment(null);

            boolean success = demandService.update(demand);
            if (success) {
                redirectAttributes.addFlashAttribute("msg", "需求更新成功，等待重新审核");
            } else {
                redirectAttributes.addFlashAttribute("error", "需求更新失败");
            }
            return "redirect:/demand/family/detail/" + demand.getId();
        } catch (Exception e) {
            log.error("Failed to update demand", e);
            redirectAttributes.addFlashAttribute("error", "系统错误，请稍后重试");
            return "redirect:/demand/family/edit/" + demand.getId();
        }
    }

    /**
     * 删除需求
     */
    @PostMapping("/family/delete/{id}")
    @ResponseBody
    public Map<String, Object> delete(@PathVariable Long id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null || !"FAMILY".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "未登录或无权限");
            return result;
        }

        try {
            Demand demand = demandService.findById(id);
            if (demand == null || !demand.getFamilyUserId().equals(currentUser.getId())) {
                result.put("success", false);
                result.put("message", "无权限删除此需求");
                return result;
            }

            // 只有待审核和已拒绝的需求才能删除
            if (!"PENDING".equals(demand.getStatus()) && !"REJECTED".equals(demand.getStatus())) {
                result.put("success", false);
                result.put("message", "当前状态的需求不能删除");
                return result;
            }

            boolean success = demandService.delete(id);
            result.put("success", success);
            result.put("message", success ? "删除成功" : "删除失败");
            return result;
        } catch (Exception e) {
            log.error("Failed to delete demand", e);
            result.put("success", false);
            result.put("message", "系统错误");
            return result;
        }
    }
}
