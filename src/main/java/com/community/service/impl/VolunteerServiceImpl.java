package com.community.service.impl;

import com.community.dao.VolunteerMapper;
import com.community.domain.VolunteerProfile;
import com.community.service.VolunteerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 志愿者业务实现类
 */
@Service("volunteerService")
@Transactional
public class VolunteerServiceImpl implements VolunteerService {

  private static final Logger log = LoggerFactory.getLogger(VolunteerServiceImpl.class);

  @Resource
  private VolunteerMapper volunteerMapper;

  @Override
  public List<VolunteerProfile> findAll(String status, String keyword) {
    return volunteerMapper.findAll(status, keyword);
  }

  @Override
  public VolunteerProfile findById(Long id) {
    return volunteerMapper.findById(id);
  }

  @Override
  public VolunteerProfile findByUserId(Long userId) {
    return volunteerMapper.findByUserId(userId);
  }

  @Override
  public boolean add(VolunteerProfile profile) {
    if (profile == null || profile.getUserId() == null) {
      log.warn("Invalid volunteer profile for add");
      return false;
    }

    // 检查是否已存在
    if (volunteerMapper.existsByUserId(profile.getUserId()) > 0) {
      log.warn("Volunteer profile already exists for user: {}", profile.getUserId());
      return false;
    }

    int rows = volunteerMapper.insert(profile);
    if (rows > 0) {
      log.info("Added volunteer profile for user: {}", profile.getUserId());
      return true;
    }
    return false;
  }

  @Override
  public boolean update(VolunteerProfile profile) {
    if (profile == null || profile.getId() == null) {
      log.warn("Invalid volunteer profile for update");
      return false;
    }

    int rows = volunteerMapper.update(profile);
    if (rows > 0) {
      log.info("Updated volunteer profile: {}", profile.getId());
      return true;
    }
    return false;
  }

  @Override
  public boolean approve(Long id, String status, Long approveBy) {
    if (id == null || status == null) {
      return false;
    }

    // 验证状态值
    if (!"APPROVED".equals(status) && !"REJECTED".equals(status)) {
      log.warn("Invalid approve status: {}", status);
      return false;
    }

    int rows = volunteerMapper.approve(id, status, approveBy);
    if (rows > 0) {
      log.info("Approved volunteer {} with status {}", id, status);
      return true;
    }
    return false;
  }

  @Override
  public boolean updateServiceStats(Long userId, Double serviceHours, Integer taskCount, Double averageRating) {
    if (userId == null) {
      return false;
    }

    int rows = volunteerMapper.updateServiceStats(userId, serviceHours, taskCount, averageRating);
    if (rows > 0) {
      log.info("Updated service stats for volunteer: {}", userId);
      return true;
    }
    return false;
  }

  @Override
  public int countByStatus(String status) {
    return volunteerMapper.countByStatus(status);
  }

  @Override
  public boolean existsByUserId(Long userId) {
    return volunteerMapper.existsByUserId(userId) > 0;
  }
}
