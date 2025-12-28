package com.community.service;

import com.community.domain.VolunteerProfile;

import java.util.List;

/**
 * 志愿者业务接口
 */
public interface VolunteerService {

  /**
   * 查询所有志愿者
   */
  List<VolunteerProfile> findAll(String status, String keyword);

  /**
   * 根据ID查询志愿者详情
   */
  VolunteerProfile findById(Long id);

  /**
   * 根据用户ID查询志愿者信息
   */
  VolunteerProfile findByUserId(Long userId);

  /**
   * 新增志愿者信息
   */
  boolean add(VolunteerProfile profile);

  /**
   * 更新志愿者信息
   */
  boolean update(VolunteerProfile profile);

  /**
   * 审核志愿者
   */
  boolean approve(Long id, String status, Long approveBy);

  /**
   * 更新服务统计
   */
  boolean updateServiceStats(Long userId, Double serviceHours, Integer taskCount, Double averageRating);

  /**
   * 统计志愿者数量
   */
  int countByStatus(String status);

  /**
   * 检查用户是否已有志愿者信息
   */
  boolean existsByUserId(Long userId);
}
