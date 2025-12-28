package com.community.dao;

import com.community.domain.Notification;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 通知消息Mapper接口
 */
public interface NotificationMapper {

  /**
   * 插入通知
   */
  int insert(Notification notification);

  /**
   * 查询用户的通知列表
   */
  List<Notification> findByUserId(@Param("userId") Long userId,
                                   @Param("isRead") Integer isRead);

  /**
   * 查询用户未读通知数量
   */
  int countUnread(@Param("userId") Long userId);

  /**
   * 根据ID查询通知
   */
  Notification findById(@Param("id") Long id);

  /**
   * 标记为已读
   */
  int markAsRead(@Param("id") Long id);

  /**
   * 批量标记为已读
   */
  int markAllAsRead(@Param("userId") Long userId);

  /**
   * 删除通知
   */
  int delete(@Param("id") Long id);

  /**
   * 清空已读通知
   */
  int deleteRead(@Param("userId") Long userId);
}
