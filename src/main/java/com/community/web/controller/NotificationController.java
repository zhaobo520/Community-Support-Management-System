package com.community.web.controller;

import com.community.domain.Notification;
import com.community.domain.User;
import com.community.service.NotificationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 通知消息控制器
 */
@Controller
@RequestMapping("/notification")
public class NotificationController {

  @Resource
  private NotificationService notificationService;

  /**
   * 消息中心页面
   */
  @GetMapping("/list")
  public String list(@RequestParam(required = false) String filter,
                     Model model,
                     HttpSession session) {
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    if (currentUser == null) {
      return "redirect:/user/login";
    }

    Integer isRead = null;
    if ("unread".equals(filter)) {
      isRead = 0;
    } else if ("read".equals(filter)) {
      isRead = 1;
    }

    List<Notification> notifications = notificationService.findByUserId(currentUser.getId(), isRead);
    int unreadCount = notificationService.countUnread(currentUser.getId());

    model.addAttribute("notifications", notifications);
    model.addAttribute("unreadCount", unreadCount);
    model.addAttribute("filter", filter);
    model.addAttribute("currentUser", currentUser);

    return "notification/list";
  }

  /**
   * 获取未读消息数量（AJAX）
   */
  @GetMapping("/unread-count")
  @ResponseBody
  public Map<String, Object> getUnreadCount(HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    if (currentUser == null) {
      result.put("success", false);
      result.put("count", 0);
      return result;
    }

    int count = notificationService.countUnread(currentUser.getId());
    result.put("success", true);
    result.put("count", count);
    return result;
  }

  /**
   * 标记为已读（AJAX）
   */
  @PostMapping("/read/{id}")
  @ResponseBody
  public Map<String, Object> markAsRead(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    if (currentUser == null) {
      result.put("success", false);
      result.put("message", "未登录");
      return result;
    }

    // 验证消息是否属于当前用户
    Notification notification = notificationService.findById(id);
    if (notification == null || !notification.getUserId().equals(currentUser.getId())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = notificationService.markAsRead(id);
    result.put("success", success);
    result.put("message", success ? "已标记为已读" : "操作失败");
    return result;
  }

  /**
   * 全部标记为已读（AJAX）
   */
  @PostMapping("/read-all")
  @ResponseBody
  public Map<String, Object> markAllAsRead(HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    if (currentUser == null) {
      result.put("success", false);
      result.put("message", "未登录");
      return result;
    }

    boolean success = notificationService.markAllAsRead(currentUser.getId());
    result.put("success", success);
    result.put("message", success ? "已全部标记为已读" : "操作失败");
    return result;
  }

  /**
   * 删除消息（AJAX）
   */
  @PostMapping("/delete/{id}")
  @ResponseBody
  public Map<String, Object> delete(@PathVariable Long id, HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    if (currentUser == null) {
      result.put("success", false);
      result.put("message", "未登录");
      return result;
    }

    // 验证消息是否属于当前用户
    Notification notification = notificationService.findById(id);
    if (notification == null || !notification.getUserId().equals(currentUser.getId())) {
      result.put("success", false);
      result.put("message", "无权限");
      return result;
    }

    boolean success = notificationService.delete(id);
    result.put("success", success);
    result.put("message", success ? "已删除" : "操作失败");
    return result;
  }

  /**
   * 清空已读消息（AJAX）
   */
  @PostMapping("/clear-read")
  @ResponseBody
  public Map<String, Object> clearRead(HttpSession session) {
    Map<String, Object> result = new HashMap<>();
    User currentUser = (User) session.getAttribute("CURRENT_USER");
    
    if (currentUser == null) {
      result.put("success", false);
      result.put("message", "未登录");
      return result;
    }

    boolean success = notificationService.deleteRead(currentUser.getId());
    result.put("success", success);
    result.put("message", success ? "已清空已读消息" : "操作失败");
    return result;
  }
}
