package com.community.service.impl;

import com.community.dao.NotificationMapper;
import com.community.domain.Notification;
import com.community.service.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 通知消息服务实现类
 */
@Service("notificationService")
@Transactional
public class NotificationServiceImpl implements NotificationService {

  private static final Logger log = LoggerFactory.getLogger(NotificationServiceImpl.class);

  @Resource
  private NotificationMapper notificationMapper;

  @Override
  public boolean send(Notification notification) {
    try {
      if (notification == null || notification.getUserId() == null) {
        return false;
      }
      int rows = notificationMapper.insert(notification);
      return rows > 0;
    } catch (Exception e) {
      log.error("Failed to send notification", e);
      return false;
    }
  }

  @Override
  public boolean sendNotification(Long userId, String title, String content,
                                   String type, String relatedType, Long relatedId) {
    Notification notification = new Notification();
    notification.setUserId(userId);
    notification.setTitle(title);
    notification.setContent(content);
    notification.setType(type);
    notification.setRelatedType(relatedType);
    notification.setRelatedId(relatedId);
    return send(notification);
  }

  @Override
  public List<Notification> findByUserId(Long userId, Integer isRead) {
    return notificationMapper.findByUserId(userId, isRead);
  }

  @Override
  public int countUnread(Long userId) {
    return notificationMapper.countUnread(userId);
  }

  @Override
  public Notification findById(Long id) {
    return notificationMapper.findById(id);
  }

  @Override
  public boolean markAsRead(Long id) {
    try {
      int rows = notificationMapper.markAsRead(id);
      return rows > 0;
    } catch (Exception e) {
      log.error("Failed to mark notification as read", e);
      return false;
    }
  }

  @Override
  public boolean markAllAsRead(Long userId) {
    try {
      notificationMapper.markAllAsRead(userId);
      return true;
    } catch (Exception e) {
      log.error("Failed to mark all notifications as read", e);
      return false;
    }
  }

  @Override
  public boolean delete(Long id) {
    try {
      int rows = notificationMapper.delete(id);
      return rows > 0;
    } catch (Exception e) {
      log.error("Failed to delete notification", e);
      return false;
    }
  }

  @Override
  public boolean deleteRead(Long userId) {
    try {
      notificationMapper.deleteRead(userId);
      return true;
    } catch (Exception e) {
      log.error("Failed to delete read notifications", e);
      return false;
    }
  }
}
