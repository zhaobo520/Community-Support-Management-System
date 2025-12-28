package com.community.service;

import com.community.domain.Notification;

import java.util.List;

/**
 * 通知消息服务接口
 */
public interface NotificationService {

  /**
   * 发送通知
   */
  boolean send(Notification notification);

  /**
   * 发送通知（简化方法）
   */
  boolean sendNotification(Long userId, String title, String content, 
                          String type, String relatedType, Long relatedId);

  /**
   * 查询用户的通知列表
   */
  List<Notification> findByUserId(Long userId, Integer isRead);

  /**
   * 查询用户未读通知数量
   */
  int countUnread(Long userId);

  /**
   * 根据ID查询通知
   */
  Notification findById(Long id);

  /**
   * 标记为已读
   */
  boolean markAsRead(Long id);

  /**
   * 全部标记为已读
   */
  boolean markAllAsRead(Long userId);

  /**
   * 删除通知
   */
  boolean delete(Long id);

  /**
   * 清空已读通知
   */
  boolean deleteRead(Long userId);
}
