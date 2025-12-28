package com.community.service.impl;

import com.community.dao.AppealMapper;
import com.community.domain.Appeal;
import com.community.service.AppealService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service("appealService")
public class AppealServiceImpl implements AppealService {

  private static final Logger log = LoggerFactory.getLogger(AppealServiceImpl.class);

  @Resource
  private AppealMapper appealMapper;

  @Override
  @Transactional(rollbackFor = Exception.class)
  public boolean submit(Appeal appeal) {
    try {
      if (appeal == null || appeal.getUsername() == null) {
        return false;
      }
      appeal.setStatus("PENDING");
      int result = appealMapper.insert(appeal);
      if (result > 0) {
        log.info("Appeal submitted successfully: {}", appeal.getUsername());
        return true;
      }
      return false;
    } catch (Exception e) {
      log.error("Failed to submit appeal", e);
      throw e;
    }
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public boolean review(Appeal appeal) {
    try {
      if (appeal == null || appeal.getId() == null) {
        return false;
      }
      int result = appealMapper.update(appeal);
      if (result > 0) {
        log.info("Appeal reviewed successfully: {}", appeal.getId());
        return true;
      }
      return false;
    } catch (Exception e) {
      log.error("Failed to review appeal", e);
      throw e;
    }
  }

  @Override
  public Appeal findById(Long id) {
    if (id == null) {
      return null;
    }
    return appealMapper.selectById(id);
  }

  @Override
  public List<Appeal> findAll() {
    return appealMapper.selectAll();
  }

  @Override
  public List<Appeal> findByUserId(Long userId) {
    if (userId == null) {
      return null;
    }
    return appealMapper.selectByUserId(userId);
  }

  @Override
  public List<Appeal> findByStatus(String status) {
    if (status == null) {
      return null;
    }
    return appealMapper.selectByStatus(status);
  }

  @Override
  public List<Appeal> findByUserRole(String userRole) {
    if (userRole == null) {
      return null;
    }
    return appealMapper.selectByUserRole(userRole);
  }

  @Override
  public int countPending() {
    return appealMapper.countByStatus("PENDING");
  }
}
