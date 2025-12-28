package com.community.web.controller;

import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.service.TaskService;
import com.community.service.VolunteerService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 志愿者任务控制器
 */
@Controller
@RequestMapping("/volunteer/task")
public class VolunteerTaskController {

  @Resource
  private TaskService taskService;

  @Resource
  private VolunteerService volunteerService;

  /**
   * 检查志愿者状态
   */
  private String checkVolunteerStatus(User currentUser, Model model) {
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null) {
      model.addAttribute("errorMsg", "您还未注册成为志愿者，请先完善志愿者信息");
      return "error/volunteer_not_registered";
    }

    if ("REJECTED".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者申请已被拒绝，暂时无法接单");
      return "error/volunteer_rejected";
    }

    if ("SUSPENDED".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者服务已被暂停，暂时无法接单");
      return "error/volunteer_suspended";
    }

    if ("PENDING".equals(profile.getVolunteerStatus())) {
      model.addAttribute("errorMsg", "您的志愿者申请正在审核中，请耐心等待");
      return "error/volunteer_pending";
    }

    return null; // 状态正常
  }

  /**
   * 任务大厅
   */
  @GetMapping("/hall")
  public String hall(@RequestParam(required = false) String taskType,
                     Model model,
                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    // 检查志愿者状态
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) {
      return statusCheck;
    }

    List<TaskInfo> list = taskService.findPendingTasks(taskType);

    model.addAttribute("list", list);
    model.addAttribute("taskType", taskType);
    model.addAttribute("currentUser", currentUser);

    return "task/volunteer_hall";
  }

  /**
   * 我的任务
   */
  @GetMapping("/my")
  public String myTasks(@RequestParam(required = false) String status,
                        Model model,
                        HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    // 检查志愿者状态
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) {
      return statusCheck;
    }

    List<TaskInfo> list = taskService.findMyTasks(currentUser.getId(), status);
    int totalCount = taskService.countVolunteerTasks(currentUser.getId());

    model.addAttribute("list", list);
    model.addAttribute("totalCount", totalCount);
    model.addAttribute("status", status);
    model.addAttribute("currentUser", currentUser);

    return "task/volunteer_my";
  }

  /**
   * 认领任务（AJAX）
   */
  @PostMapping("/claim/{id}")
  @ResponseBody
  public Map<String, Object> claim(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 检查志愿者状态
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null || !"APPROVED".equals(profile.getVolunteerStatus())) {
      result.put("success", false);
      String msg = profile == null ? "您还未注册成为志愿者" :
          "REJECTED".equals(profile.getVolunteerStatus()) ? "您的志愿者申请已被拒绝，无法接单" :
          "SUSPENDED".equals(profile.getVolunteerStatus()) ? "您的志愿者服务已被暂停，无法接单" :
          "您的志愿者申请正在审核中，请耐心等待";
      result.put("message", msg);
      return result;
    }

    boolean success = taskService.claimTask(id, currentUser.getId(), currentUser.getFullName());
    result.put("success", success);
    result.put("message", success ? "认领成功" : "认领失败，任务可能已被他人认领");

    return result;
  }

  /**
   * 开始执行任务（AJAX）
   */
  @PostMapping("/start/{id}")
  @ResponseBody
  public Map<String, Object> start(@PathVariable Long id, 
                                   @RequestParam(required = false) Double lat,
                                   @RequestParam(required = false) Double lng,
                                   HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 检查志愿者状态
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null || !"APPROVED".equals(profile.getVolunteerStatus())) {
      result.put("success", false);
      result.put("message", "您的志愿者状态异常，无法执行任务");
      return result;
    }

    // 验证任务是否属于当前志愿者
    TaskInfo task = taskService.findById(id);
    if (task == null || !currentUser.getId().equals(task.getVolunteerId())) {
      result.put("success", false);
      result.put("message", "无权操作此任务");
      return result;
    }

    // 调用带位置校验的启动方法
    String error = taskService.startTaskWithLocation(id, lat, lng);
    
    if (error == null) {
        result.put("success", true);
        result.put("message", "已开始执行");
    } else {
        result.put("success", false);
        result.put("message", error);
    }

    return result;
  }

  /**
   * 提交完成（AJAX）
   */
  @PostMapping("/submit/{id}")
  @ResponseBody
  public Map<String, Object> submit(@PathVariable Long id,
                                     @RequestParam String completionNote,
                                     HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 检查志愿者状态
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null || !"APPROVED".equals(profile.getVolunteerStatus())) {
      result.put("success", false);
      result.put("message", "您的志愿者状态异常，无法提交任务");
      return result;
    }

    // 验证任务是否属于当前志愿者
    TaskInfo task = taskService.findById(id);
    if (task == null || !currentUser.getId().equals(task.getVolunteerId())) {
      result.put("success", false);
      result.put("message", "无权操作此任务");
      return result;
    }

    boolean success = taskService.submitCompletion(id, completionNote);
    result.put("success", success);
    result.put("message", success ? "提交成功，等待审核" : "提交失败");

    return result;
  }

  /**
   * 放弃任务（AJAX）
   */
  @PostMapping("/cancel/{id}")
  @ResponseBody
  public Map<String, Object> cancel(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 检查志愿者状态
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null || !"APPROVED".equals(profile.getVolunteerStatus())) {
      result.put("success", false);
      result.put("message", "您的志愿者状态异常，无法放弃任务");
      return result;
    }

    // 验证任务是否属于当前志愿者
    TaskInfo task = taskService.findById(id);
    if (task == null || !currentUser.getId().equals(task.getVolunteerId())) {
      result.put("success", false);
      result.put("message", "无权操作此任务");
      return result;
    }

    // 志愿者放弃任务（释放回任务大厅）
    boolean success = taskService.releaseTask(id);
    result.put("success", success);
    result.put("message", success ? "已放弃任务，任务已重新回到大厅" : "操作失败，任务可能已完成或取消");

    return result;
  }

  /**
   * 任务详情
   */
  @GetMapping("/detail/{id}")
  public String detail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");

    // 检查志愿者状态
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) {
      return statusCheck;
    }

    TaskInfo taskInfo = taskService.findById(id);
    if (taskInfo == null) {
      return "redirect:/volunteer/task/hall";
    }

    model.addAttribute("taskInfo", taskInfo);
    model.addAttribute("currentUser", currentUser);
    return "task/detail";
  }

  /**
   * 上传执行照片（AJAX）
   */
  @PostMapping("/uploadPhoto/{id}")
  @ResponseBody
  public Map<String, Object> uploadPhoto(@PathVariable Long id,
                                          @RequestParam String photoUrl,
                                          HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 验证任务是否属于当前志愿者
    TaskInfo task = taskService.findById(id);
    if (task == null || !currentUser.getId().equals(task.getVolunteerId())) {
      result.put("success", false);
      result.put("message", "无权操作此任务");
      return result;
    }

    // 追加照片URL到现有照片列表
    String existingPhotos = task.getExecutionPhotos();
    String newPhotos;
    if (existingPhotos == null || existingPhotos.isEmpty()) {
      newPhotos = photoUrl;
    } else {
      newPhotos = existingPhotos + "," + photoUrl;
    }

    boolean success = taskService.updateExecutionPhotos(id, newPhotos);
    result.put("success", success);
    result.put("message", success ? "照片上传成功" : "上传失败");
    result.put("photos", newPhotos);

    return result;
  }

  /**
   * 删除执行照片（AJAX）
   */
  @PostMapping("/deletePhoto/{id}")
  @ResponseBody
  public Map<String, Object> deletePhoto(@PathVariable Long id,
                                          @RequestParam String photoUrl,
                                          HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    // 验证任务是否属于当前志愿者
    TaskInfo task = taskService.findById(id);
    if (task == null || !currentUser.getId().equals(task.getVolunteerId())) {
      result.put("success", false);
      result.put("message", "无权操作此任务");
      return result;
    }

    // 从照片列表中移除指定照片
    String existingPhotos = task.getExecutionPhotos();
    if (existingPhotos != null && !existingPhotos.isEmpty()) {
      String[] photos = existingPhotos.split(",");
      StringBuilder newPhotos = new StringBuilder();
      for (String photo : photos) {
        if (!photo.equals(photoUrl)) {
          if (newPhotos.length() > 0) {
            newPhotos.append(",");
          }
          newPhotos.append(photo);
        }
      }
      boolean success = taskService.updateExecutionPhotos(id, newPhotos.toString());
      result.put("success", success);
      result.put("message", success ? "照片删除成功" : "删除失败");
      result.put("photos", newPhotos.toString());
    } else {
      result.put("success", false);
      result.put("message", "没有可删除的照片");
    }

    return result;
  }
}
