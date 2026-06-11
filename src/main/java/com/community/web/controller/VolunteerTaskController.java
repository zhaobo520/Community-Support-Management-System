package com.community.web.controller;

import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.domain.VolunteerProfile;
import com.community.service.TaskService;
import com.community.service.VolunteerService;
import com.community.service.SysFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 志愿者任务控制器
 */
@Controller
@RequestMapping("/volunteer/task")
public class VolunteerTaskController {

  private static final Logger log = LoggerFactory.getLogger(VolunteerTaskController.class);

  @Resource
  private TaskService taskService;

  @Resource
  private VolunteerService volunteerService;

  @Resource
  private SysFileService sysFileService;

  private String checkVolunteerStatus(User currentUser, Model model) {
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }
    VolunteerProfile profile = volunteerService.findByUserId(currentUser.getId());
    if (profile == null) {
      model.addAttribute("errorMsg", "您还未注册成为志愿者，请先完善志愿者信息");
      return "error/volunteer_not_registered";
    }
    if (!"APPROVED".equals(profile.getVolunteerStatus())) {
        String msg = "REJECTED".equals(profile.getVolunteerStatus()) ? "您的志愿者申请已被拒绝，无法接单" :
                     "SUSPENDED".equals(profile.getVolunteerStatus()) ? "您的志愿者服务已被暂停，无法接单" :
                     "您的志愿者申请正在审核中，请耐心等待";
        model.addAttribute("errorMsg", msg);
        return "error/volunteer_status_error";
    }
    return null;
  }

  @GetMapping("/hall")
  public String hall(@RequestParam(required = false) String taskType, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) return statusCheck;
    List<TaskInfo> list = taskService.findPendingTasks(taskType);
    model.addAttribute("list", list);
    model.addAttribute("taskType", taskType);
    model.addAttribute("currentUser", currentUser);
    return "task/volunteer_hall";
  }

  @GetMapping("/my")
  public String myTasks(@RequestParam(required = false) String status, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) return statusCheck;
    List<TaskInfo> list = taskService.findMyTasks(currentUser.getId(), status);
    model.addAttribute("list", list);
    model.addAttribute("currentUser", currentUser);
    return "task/volunteer_my";
  }

  @PostMapping("/claim/{id}")
  @ResponseBody
  public Map<String, Object> claim(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false); result.put("message", "无权限"); return result;
    }
    boolean success = taskService.claimTask(id, currentUser.getId(), currentUser.getFullName());
    result.put("success", success); result.put("message", success ? "认领成功" : "认领失败");
    return result;
  }

  @PostMapping("/start/{id}")
  @ResponseBody
  public Map<String, Object> start(@PathVariable Long id, @RequestParam(required = false) Double lat, @RequestParam(required = false) Double lng, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
        result.put("success", false); result.put("message", "无权限"); return result;
    }
    String error = taskService.startTaskWithLocation(id, lat, lng);
    result.put("success", error == null); result.put("message", error == null ? "已开始执行" : error);
    return result;
  }

  @PostMapping("/submit/{id}")
  @ResponseBody
  public Map<String, Object> submit(@PathVariable Long id, @RequestParam String completionNote, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
        result.put("success", false); result.put("message", "无权限"); return result;
    }
    boolean success = taskService.submitCompletion(id, completionNote);
    result.put("success", success); result.put("message", success ? "提交成功" : "提交失败");
    return result;
  }

  @PostMapping("/cancel/{id}")
  @ResponseBody
  public Map<String, Object> cancel(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
        result.put("success", false); result.put("message", "无权限"); return result;
    }
    boolean success = taskService.releaseTask(id);
    result.put("success", success); result.put("message", success ? "已放弃" : "失败");
    return result;
  }

  @GetMapping("/detail/{id}")
  public String detail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    String statusCheck = checkVolunteerStatus(currentUser, model);
    if (statusCheck != null) return statusCheck;
    TaskInfo taskInfo = taskService.findById(id);
    model.addAttribute("taskInfo", taskInfo);
    model.addAttribute("currentUser", currentUser);
    return "task/detail";
  }

  @PostMapping("/uploadPhoto/{id}")
  @ResponseBody
  public Map<String, Object> uploadPhoto(@PathVariable Long id,
                                          @RequestParam(value="file", required=false) MultipartFile file,
                                          @RequestParam(value="photoUrl", required=false) String photoUrl,
                                          HttpServletRequest request) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) request.getSession().getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false); result.put("message", "无权限"); return result;
    }

    String finalUrl = "";
    if (file != null && !file.isEmpty()) {
        try {
            Long fileId = sysFileService.upload(file, currentUser.getId());
            String ext = "";
            String originalName = file.getOriginalFilename();
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf('.'));
            }
            finalUrl = "/file/view/" + fileId + ext;
        } catch (Exception e) {
            log.error("Upload error", e);
            result.put("success", false); result.put("message", "上传失败"); return result;
        }
    } else if (photoUrl != null && !photoUrl.isEmpty()) {
        String contextPath = request.getContextPath();
        finalUrl = photoUrl.startsWith(contextPath) ? photoUrl.substring(contextPath.length()) : photoUrl;
    } else {
        result.put("success", false); result.put("message", "未获取到文件"); return result;
    }

    TaskInfo task = taskService.findById(id);
    String existing = task.getExecutionPhotos();
    String newPhotos = (existing == null || existing.isEmpty()) ? finalUrl : existing + "," + finalUrl;
    boolean success = taskService.updateExecutionPhotos(id, newPhotos);
    result.put("success", success);
    result.put("url", finalUrl);
    result.put("message", success ? "上传成功" : "保存失败");
    return result;
  }

  @PostMapping("/deletePhoto/{id}")
  @ResponseBody
  public Map<String, Object> deletePhoto(@PathVariable Long id,
                                         @RequestParam("photoUrl") String photoUrl,
                                         HttpServletRequest request) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) request.getSession().getAttribute("CURRENT_USER");
    if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    TaskInfo task = taskService.findById(id);
    if (task == null) {
      result.put("success", false);
      result.put("message", "任务不存在");
      return result;
    }
    if (task.getVolunteerId() == null || !task.getVolunteerId().equals(currentUser.getId())) {
      result.put("success", false);
      result.put("message", "只能删除自己任务的执行记录");
      return result;
    }

    String contextPath = request.getContextPath();
    String normalizedUrl = photoUrl.startsWith(contextPath) ? photoUrl.substring(contextPath.length()) : photoUrl;
    String existing = task.getExecutionPhotos();
    if (existing == null || existing.trim().isEmpty()) {
      result.put("success", false);
      result.put("message", "没有可删除的记录");
      return result;
    }

    List<String> remain = Arrays.stream(existing.split(","))
        .map(String::trim)
        .filter(s -> !s.isEmpty())
        .filter(s -> !s.equals(normalizedUrl))
        .collect(Collectors.toList());

    if (remain.size() == Arrays.stream(existing.split(",")).map(String::trim).filter(s -> !s.isEmpty()).count()) {
      result.put("success", false);
      result.put("message", "未找到对应记录");
      return result;
    }

    String newPhotos = String.join(",", remain);
    boolean success = taskService.updateExecutionPhotos(id, newPhotos);
    if (success) {
      try {
        String raw = normalizedUrl;
        if (raw.startsWith("/file/view/")) {
          raw = raw.substring("/file/view/".length());
        }
        int dotIndex = raw.indexOf('.');
        if (dotIndex > 0) {
          raw = raw.substring(0, dotIndex);
        }
        Long fileId = Long.parseLong(raw);
        sysFileService.delete(fileId);
      } catch (Exception e) {
        log.warn("删除任务执行文件记录成功，但删除文件实体失败: {}", normalizedUrl, e);
      }
    }

    result.put("success", success);
    result.put("message", success ? "删除成功" : "删除失败");
    return result;
  }
}
