package com.community.web.controller;

import com.community.domain.Demand;
import com.community.domain.ElderlyInfo;
import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.service.DemandService;
import com.community.service.ElderlyService;
import com.community.service.NotificationService;
import com.community.service.PointsService;
import com.community.service.TaskService;
import com.community.service.UserService;
import com.community.service.VolunteerScheduleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员任务控制器
 */
@Controller
@RequestMapping("/admin/task")
public class AdminTaskController {

  private static final Logger log = LoggerFactory.getLogger(AdminTaskController.class);

  @Resource
  private TaskService taskService;

  @Resource
  private UserService userService;

  @Resource
  private VolunteerScheduleService volunteerScheduleService;

  @Resource
  private ElderlyService elderlyService;

  @Resource
  private DemandService demandService;

  @Resource
  private NotificationService notificationService;

  @Resource
  private PointsService pointsService;

  /**
   * 任务列表页
   */
  @GetMapping("/list")
  public String list(@RequestParam(required = false) String taskType,
                     @RequestParam(required = false) String priority,
                     @RequestParam(required = false) String status,
                     @RequestParam(required = false) String keyword,
                     Model model,
                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    List<TaskInfo> list = taskService.findAll(taskType, priority, status, keyword);

    // 统计各状态任务数
    int pendingCount = taskService.countByStatus("PENDING");
    int claimedCount = taskService.countByStatus("CLAIMED");
    int inProgressCount = taskService.countByStatus("IN_PROGRESS");
    int completedCount = taskService.countByStatus("COMPLETED");

    model.addAttribute("list", list);
    model.addAttribute("pendingCount", pendingCount);
    model.addAttribute("claimedCount", claimedCount);
    model.addAttribute("inProgressCount", inProgressCount);
    model.addAttribute("completedCount", completedCount);
    model.addAttribute("taskType", taskType);
    model.addAttribute("priority", priority);
    model.addAttribute("status", status);
    model.addAttribute("keyword", keyword);
    model.addAttribute("currentUser", currentUser);

    return "task/admin_list";
  }

  /**
   * 发布任务页面
   */
  @GetMapping("/publish")
  public String publishPage(@RequestParam(required = false) Long demandId,
                            Model model, 
                            HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 如果有需求ID，获取需求信息用于预填
    if (demandId != null) {
      Demand demand = demandService.findById(demandId);
      if (demand != null) {
        model.addAttribute("demand", demand);
      }
    }

    // 获取所有关爱对象列表供选择
    List<ElderlyInfo> elderlyList = elderlyService.findAll(null, null, null);
    model.addAttribute("elderlyList", elderlyList);
    model.addAttribute("currentUser", currentUser);
    return "task/publish";
  }

  /**
   * 从需求创建任务页面
   */
  @GetMapping("/create")
  public String createFromDemandPage(@RequestParam(required = false) Long demandId,
                                     Model model, 
                                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    // 如果有需求ID，获取需求信息
    if (demandId != null) {
      Demand demand = demandService.findById(demandId);
      if (demand != null && "APPROVED".equals(demand.getStatus())) {
        model.addAttribute("demand", demand);
      }
    }

    // 获取所有关爱对象列表供选择
    List<ElderlyInfo> elderlyList = elderlyService.findAll(null, null, null);
    model.addAttribute("elderlyList", elderlyList);
    model.addAttribute("currentUser", currentUser);
    return "task/create_from_demand";
  }

  /**
   * 提交发布任务
   */
  @PostMapping("/publish")
  public String doPublish(TaskInfo taskInfo, 
                          @RequestParam(required = false) Long demandId,
                          HttpSession session, 
                          Model model) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      return "redirect:/user/login";
    }

    taskInfo.setCreatedBy(currentUser.getId());
    
    // 如果是从需求创建的任务，设置需求ID
    if (demandId != null) {
      taskInfo.setDemandId(demandId);
    }

    // 根据elderlyId获取关爱对象信息
    if (taskInfo.getElderlyId() != null) {
      ElderlyInfo elderly = elderlyService.findById(taskInfo.getElderlyId());
      if (elderly != null) {
        taskInfo.setElderlyName(elderly.getName());
        if (taskInfo.getAddress() == null || taskInfo.getAddress().isEmpty()) {
          taskInfo.setAddress(elderly.getAddress());
        }
        if (taskInfo.getContactPhone() == null || taskInfo.getContactPhone().isEmpty()) {
          taskInfo.setContactPhone(elderly.getPhone());
        }
      }
    }

    // 处理志愿者指派
    if (taskInfo.getVolunteerId() != null) {
        User volunteer = userService.findById(taskInfo.getVolunteerId());
        if (volunteer != null) {
            taskInfo.setVolunteerName(volunteer.getFullName());
            taskInfo.setStatus("CLAIMED");
        } else {
            taskInfo.setVolunteerId(null); // ID无效，置空
            taskInfo.setStatus("PENDING");
        }
    } else {
        taskInfo.setStatus("PENDING");
    }

    boolean success = taskService.publish(taskInfo);
    if (success) {
      // 如果是从需求创建的任务，关联需求
      if (demandId != null) {
        demandService.linkTask(demandId, taskInfo.getId());
      }
      return "redirect:/admin/task/list";
    } else {
      model.addAttribute("error", "发布失败");
      model.addAttribute("taskInfo", taskInfo);
      List<ElderlyInfo> elderlyList = elderlyService.findAll(null, null, null);
      model.addAttribute("elderlyList", elderlyList);
      
      // 如果是从需求创建的，返回对应页面并加载需求数据
      if (demandId != null) {
        Demand demand = demandService.findById(demandId);
        model.addAttribute("demand", demand);
        return "task/create_from_demand";
      }
      
      return "task/publish";
    }
  }

  /**
   * 任务详情
   */
  @GetMapping("/detail/{id}")
  public String detail(@PathVariable Long id, Model model, HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null) {
      return "redirect:/user/login";
    }

    TaskInfo taskInfo = taskService.findById(id);
    if (taskInfo == null) {
      return "redirect:/admin/task/list";
    }

    model.addAttribute("taskInfo", taskInfo);
    model.addAttribute("currentUser", currentUser);
    return "task/detail";
  }

  /**
   * 审核任务（AJAX）
   */
  @PostMapping("/approve/{id}")
  @ResponseBody
  public Map<String, Object> approve(@PathVariable Long id,
                                      @RequestParam(required = false) Integer rating,
                                      @RequestParam(required = false) String feedback,
                                      HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    TaskInfo task = taskService.findById(id);
    boolean success = taskService.approveTask(id, rating, feedback);
    
    // 任务审核通过后的后续处理
    if (success && task != null && task.getVolunteerId() != null) {
        // 1. 添加积分奖励
        if (pointsService != null) {
            try {
                pointsService.addPointsForTaskApprove(id, task.getVolunteerId(), rating);
                log.info("任务审核通过，已为志愿者 {} 添加积分", task.getVolunteerId());
            } catch (Exception pe) {
                log.warn("添加积分失败", pe);
                // 积分添加失败不影响主流程
            }
        }
        
        // 2. 发送通知给志愿者
        if (notificationService != null) {
            try {
                String notifContent = "您的任务《" + task.getTaskTitle() + "》已审核通过！";
                if (rating != null) {
                    notifContent += " 评分：" + rating + "分";
                }
                if (feedback != null && !feedback.trim().isEmpty()) {
                    notifContent += " 评价：" + feedback;
                }
                notificationService.sendNotification(
                    task.getVolunteerId(),
                    "任务审核通过",
                    notifContent,
                    "TASK_APPROVE",
                    "TASK",
                    id
                );
            } catch (Exception ne) {
                log.warn("Failed to send notification", ne);
                // 通知发送失败不影响主流程
            }
        }
    }
    
    result.put("success", success);
    result.put("message", success ? "审核通过" : "审核失败");

    return result;
  }

  /**
   * 获取推荐志愿者
   */
  @GetMapping("/recommend-volunteers")
  @ResponseBody
  public List<Map<String, Object>> recommendVolunteers(
      @RequestParam @DateTimeFormat(pattern="yyyy-MM-dd") Date date,
      @RequestParam String time,
      HttpSession session) {
      
      User currentUser = (User) session.getAttribute("CURRENT_USER");
      if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
          return java.util.Collections.emptyList();
      }
      
      return volunteerScheduleService.getRecommendedVolunteers(date, time);
  }

  /**
   * 关闭任务（AJAX）
   */
  @PostMapping("/close/{id}")
  @ResponseBody
  public Map<String, Object> close(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();

    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = taskService.cancelTask(id);
    result.put("success", success);
    result.put("message", success ? "任务已关闭" : "操作失败");

    return result;
  }
}
