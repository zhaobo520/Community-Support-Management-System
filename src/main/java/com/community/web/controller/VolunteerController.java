package com.community.web.controller;

import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.domain.VolunteerSkill;
import com.community.service.SkillService;
import com.community.service.VolunteerService;
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
 * 志愿者管理控制器
 */
@Controller
@RequestMapping("/admin/volunteer")
public class VolunteerController {

  private static final Logger log = LoggerFactory.getLogger(VolunteerController.class);

  @Resource
  private VolunteerService volunteerService;

  @Resource
  private SkillService skillService;

  /**
   * 志愿者列表页
   */
  @GetMapping("/list")
  public String list(@RequestParam(required = false) String status,
                     @RequestParam(required = false) String keyword,
                     Model model,
                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    List<VolunteerProfile> list = volunteerService.findAll(status, keyword);

    // 为每个志愿者加载技能标签
    if (skillService != null && list != null) {
      for (VolunteerProfile volunteer : list) {
        try {
          List<VolunteerSkill> skills = skillService.getVolunteerSkills(volunteer.getUserId());
          volunteer.setSkillList(skills);
        } catch (Exception e) {
          log.warn("加载志愿者技能失败: userId=" + volunteer.getUserId(), e);
        }
      }
    }

    // 统计各状态志愿者数
    int pendingCount = volunteerService.countByStatus("PENDING");
    int approvedCount = volunteerService.countByStatus("APPROVED");
    int rejectedCount = volunteerService.countByStatus("REJECTED");
    int suspendedCount = volunteerService.countByStatus("SUSPENDED");

    model.addAttribute("list", list);
    model.addAttribute("pendingCount", pendingCount);
    model.addAttribute("approvedCount", approvedCount);
    model.addAttribute("rejectedCount", rejectedCount);
    model.addAttribute("suspendedCount", suspendedCount);
    model.addAttribute("status", status);
    model.addAttribute("keyword", keyword);
    model.addAttribute("currentUser", currentUser);

    return "volunteer/list";
  }

  /**
   * 志愿者详情页
   */
  @GetMapping("/detail/{id}")
  public String detail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    VolunteerProfile volunteer = volunteerService.findById(id);
    if (volunteer == null) {
      return "redirect:/admin/volunteer/list";
    }

    // 加载技能标签
    if (skillService != null) {
      try {
        List<VolunteerSkill> skills = skillService.getVolunteerSkills(volunteer.getUserId());
        volunteer.setSkillList(skills);
      } catch (Exception e) {
        log.warn("加载志愿者技能失败: userId=" + volunteer.getUserId(), e);
      }
    }

    model.addAttribute("volunteer", volunteer);
    model.addAttribute("currentUser", currentUser);
    return "volunteer/detail";
  }

  /**
   * 审核通过（AJAX）
   */
  @PostMapping("/approve/{id}")
  @ResponseBody
  public Map<String, Object> approve(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = volunteerService.approve(id, "APPROVED", currentUser.getId());
    result.put("success", success);
    result.put("message", success ? "审核通过" : "审核失败");

    return result;
  }

  /**
   * 审核拒绝（AJAX）
   */
  @PostMapping("/reject/{id}")
  @ResponseBody
  public Map<String, Object> reject(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = volunteerService.approve(id, "REJECTED", currentUser.getId());
    result.put("success", success);
    result.put("message", success ? "已拒绝" : "操作失败");

    return result;
  }

  /**
   * 暂停服务（AJAX）
   */
  @PostMapping("/suspend/{id}")
  @ResponseBody
  public Map<String, Object> suspend(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = volunteerService.approve(id, "SUSPENDED", currentUser.getId());
    result.put("success", success);
    result.put("message", success ? "已暂停服务" : "操作失败");

    return result;
  }
}
