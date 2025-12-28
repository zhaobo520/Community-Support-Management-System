package com.community.service.impl;

import com.community.dao.ElderlyMapper;
import com.community.domain.ElderlyInfo;
import com.community.service.ElderlyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 关爱对象业务实现类
 */
@Service("elderlyService")
@Transactional
public class ElderlyServiceImpl implements ElderlyService {

  private static final Logger log = LoggerFactory.getLogger(ElderlyServiceImpl.class);

  @Resource
  private ElderlyMapper elderlyMapper;

  @Override
  public List<ElderlyInfo> findAll(String keyword, String careLevel, Integer livingAlone) {
    return elderlyMapper.findAll(keyword, careLevel, livingAlone);
  }

  @Override
  public ElderlyInfo findById(Long id) {
    return elderlyMapper.findById(id);
  }

  @Override
  public boolean add(ElderlyInfo elderlyInfo) {
    if (elderlyInfo == null || elderlyInfo.getName() == null) {
      log.warn("Invalid elderly info for add");
      return false;
    }

    // 检查身份证号是否重复
    if (elderlyInfo.getIdCard() != null && !elderlyInfo.getIdCard().isEmpty()) {
      if (isIdCardExists(elderlyInfo.getIdCard(), null)) {
        log.warn("ID card already exists: {}", elderlyInfo.getIdCard());
        return false;
      }
    }

    int rows = elderlyMapper.insert(elderlyInfo);
    if (rows > 0) {
      log.info("Added elderly info: {}", elderlyInfo.getName());
      return true;
    }
    return false;
  }

  @Override
  public boolean update(ElderlyInfo elderlyInfo) {
    if (elderlyInfo == null || elderlyInfo.getId() == null) {
      log.warn("Invalid elderly info for update");
      return false;
    }

    // 检查身份证号是否重复（排除自己）
    if (elderlyInfo.getIdCard() != null && !elderlyInfo.getIdCard().isEmpty()) {
      if (isIdCardExists(elderlyInfo.getIdCard(), elderlyInfo.getId())) {
        log.warn("ID card already exists: {}", elderlyInfo.getIdCard());
        return false;
      }
    }

    int rows = elderlyMapper.update(elderlyInfo);
    if (rows > 0) {
      log.info("Updated elderly info: {}", elderlyInfo.getId());
      return true;
    }
    return false;
  }

  @Override
  public boolean delete(Long id) {
    if (id == null) {
      return false;
    }
    int rows = elderlyMapper.delete(id);
    if (rows > 0) {
      log.info("Deleted elderly info: {}", id);
      return true;
    }
    return false;
  }

  @Override
  public int count(String keyword, String careLevel, Integer livingAlone) {
    return elderlyMapper.count(keyword, careLevel, livingAlone);
  }

  @Override
  public boolean isIdCardExists(String idCard, Long excludeId) {
    if (idCard == null || idCard.isEmpty()) {
      return false;
    }
    int count = elderlyMapper.checkIdCard(idCard, excludeId);
    return count > 0;
  }

  @Override
  public List<ElderlyInfo> findByFamilyUserId(Long familyUserId) {
    if (familyUserId == null) {
      return null;
    }
    return elderlyMapper.findByFamilyUserId(familyUserId);
  }

  @Override
  public List<ElderlyInfo> findApprovedByFamilyUserId(Long familyUserId) {
    if (familyUserId == null) {
      return null;
    }
    return elderlyMapper.findApprovedByFamilyUserId(familyUserId);
  }

  @Override
  public List<ElderlyInfo> findPendingAudit() {
    return elderlyMapper.findPendingAudit();
  }

  @Override
  public int countPendingAudit() {
    return elderlyMapper.countPendingAudit();
  }

  @Override
  public boolean audit(Long id, String auditStatus, Long auditBy, String auditRemark) {
    if (id == null || auditStatus == null) {
      log.warn("Invalid audit parameters");
      return false;
    }
    int rows = elderlyMapper.audit(id, auditStatus, auditBy, auditRemark);
    if (rows > 0) {
      log.info("Audited elderly info: id={}, status={}", id, auditStatus);
      return true;
    }
    return false;
  }

  @Override
  public int countByFamilyUserId(Long familyUserId) {
    if (familyUserId == null) {
      return 0;
    }
    return elderlyMapper.countByFamilyUserId(familyUserId);
  }

  @Override
  public int countApprovedByFamilyUserId(Long familyUserId) {
    if (familyUserId == null) {
      return 0;
    }
    return elderlyMapper.countApprovedByFamilyUserId(familyUserId);
  }

  @Override
  public List<ElderlyInfo> findApproved() {
    return elderlyMapper.findApproved();
  }
}
