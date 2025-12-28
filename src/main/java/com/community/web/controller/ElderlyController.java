package com.community.web.controller;

import com.community.domain.ElderlyInfo;
import com.community.domain.User;
import com.community.service.ElderlyService;
import com.community.service.UserService;
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
 * 关爱对象管理控制器
 */
@Controller
@RequestMapping("/admin/elderly")
public class ElderlyController {

  @Resource
  private ElderlyService elderlyService;

  @Resource
  private UserService userService;

  /**
   * 关爱对象列表页
   */
  @GetMapping("/list")
  public String list(@RequestParam(required = false) String keyword,
                     @RequestParam(required = false) String careLevel,
                     @RequestParam(required = false) Integer livingAlone,
                     Model model,
                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    List<ElderlyInfo> list = elderlyService.findAll(keyword, careLevel, livingAlone);
    int total = elderlyService.count(keyword, careLevel, livingAlone);

    model.addAttribute("list", list);
    model.addAttribute("total", total);
    model.addAttribute("keyword", keyword);
    model.addAttribute("careLevel", careLevel);
    model.addAttribute("livingAlone", livingAlone);
    model.addAttribute("currentUser", currentUser);

    return "elderly/list";
  }

  /**
   * 添加关爱对象页面
   */
  @GetMapping("/add")
  public String addPage(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    model.addAttribute("currentUser", currentUser);
    return "elderly/add";
  }

  /**
   * 提交新增关爱对象
   */
  @PostMapping("/add")
  public String doAdd(ElderlyInfo elderlyInfo, HttpSession session, Model model) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    elderlyInfo.setCreatedBy(currentUser.getId());
    elderlyInfo.setStatus(1);
    // 管理员直接添加的关爱人员，审核状态直接设为已通过
    elderlyInfo.setAuditStatus("APPROVED");

    boolean success = elderlyService.add(elderlyInfo);
    if (success) {
      return "redirect:/admin/elderly/list";
    } else {
      model.addAttribute("error", "添加失败，请检查身份证号是否重复");
      model.addAttribute("elderlyInfo", elderlyInfo);
      return "elderly/add";
    }
  }

  /**
   * 编辑关爱对象页面
   */
  @GetMapping("/edit/{id}")
  public String editPage(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    ElderlyInfo elderlyInfo = elderlyService.findById(id);
    if (elderlyInfo == null) {
      return "redirect:/admin/elderly/list";
    }

    model.addAttribute("elderlyInfo", elderlyInfo);
    model.addAttribute("currentUser", currentUser);
    return "elderly/edit";
  }

  /**
   * 提交编辑关爱对象
   */
  @PostMapping("/edit")
  public String doEdit(ElderlyInfo elderlyInfo, HttpSession session, Model model) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    boolean success = elderlyService.update(elderlyInfo);
    if (success) {
      return "redirect:/admin/elderly/list";
    } else {
      model.addAttribute("error", "更新失败，请检查身份证号是否重复");
      model.addAttribute("elderlyInfo", elderlyInfo);
      return "elderly/edit";
    }
  }

  /**
   * 查看关爱对象详情
   */
  @GetMapping("/detail/{id}")
  public String detail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null) {
      return "redirect:/user/login";
    }

    ElderlyInfo elderlyInfo = elderlyService.findById(id);
    if (elderlyInfo == null) {
      return "redirect:/admin/elderly/list";
    }

    model.addAttribute("elderlyInfo", elderlyInfo);
    model.addAttribute("currentUser", currentUser);
    return "elderly/detail";
  }

  /**
   * 删除关爱对象（AJAX）
   */
  @PostMapping("/delete/{id}")
  @ResponseBody
  public Map<String, Object> delete(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = elderlyService.delete(id);
    result.put("success", success);
    result.put("message", success ? "删除成功" : "删除失败");

    return result;
  }

  /**
   * 待审核关爱人员列表页面
   */
  @GetMapping("/audit/list")
  public String auditList(Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    List<ElderlyInfo> pendingList = elderlyService.findPendingAudit();
    int pendingCount = elderlyService.countPendingAudit();

    // 获取家属用户信息
    for (ElderlyInfo elderly : pendingList) {
      if (elderly.getFamilyUserId() != null) {
        User familyUser = userService.findById(elderly.getFamilyUserId());
        if (familyUser != null) {
          elderly.setFamilyContact(elderly.getFamilyContact() + " (" + familyUser.getFullName() + ")");
        }
      }
    }

    model.addAttribute("pendingList", pendingList);
    model.addAttribute("pendingCount", pendingCount);
    model.addAttribute("currentUser", currentUser);

    return "elderly/audit_list";
  }

  /**
   * 审核关爱人员详情页面
   */
  @GetMapping("/audit/detail/{id}")
  public String auditDetail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    ElderlyInfo elderlyInfo = elderlyService.findById(id);
    if (elderlyInfo == null) {
      return "redirect:/admin/elderly/audit/list";
    }

    // 获取提交人信息
    User familyUser = null;
    if (elderlyInfo.getFamilyUserId() != null) {
      familyUser = userService.findById(elderlyInfo.getFamilyUserId());
    }

    model.addAttribute("elderlyInfo", elderlyInfo);
    model.addAttribute("familyUser", familyUser);
    model.addAttribute("currentUser", currentUser);

    return "elderly/audit_detail";
  }

  /**
   * 审核通过
   */
  @PostMapping("/audit/approve/{id}")
  public String auditApprove(@PathVariable Long id,
                             @RequestParam(required = false) String auditRemark,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    boolean success = elderlyService.audit(id, "APPROVED", currentUser.getId(), auditRemark);
    if (success) {
      redirectAttributes.addFlashAttribute("success", "审核通过成功");
    } else {
      redirectAttributes.addFlashAttribute("error", "审核失败");
    }

    return "redirect:/admin/elderly/audit/list";
  }

  /**
   * 审核拒绝
   */
  @PostMapping("/audit/reject/{id}")
  public String auditReject(@PathVariable Long id,
                            @RequestParam String auditRemark,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    boolean success = elderlyService.audit(id, "REJECTED", currentUser.getId(), auditRemark);
    if (success) {
      redirectAttributes.addFlashAttribute("success", "已拒绝该申请");
    } else {
      redirectAttributes.addFlashAttribute("error", "操作失败");
    }

    return "redirect:/admin/elderly/audit/list";
  }

  /**
   * AJAX审核接口
   */
  @PostMapping("/audit/do")
  @ResponseBody
  public Map<String, Object> doAudit(@RequestParam Long id,
                                     @RequestParam String action,
                                     @RequestParam(required = false) String remark,
                                     HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    String auditStatus = "approve".equals(action) ? "APPROVED" : "REJECTED";
    boolean success = elderlyService.audit(id, auditStatus, currentUser.getId(), remark);

    result.put("success", success);
    result.put("message", success ? ("approve".equals(action) ? "审核通过" : "已拒绝") : "操作失败");

    return result;
  }
}
