package com.community.service;

import com.community.domain.ElderlyInfo;

import java.util.List;

/**
 * 关爱对象业务接口
 */
public interface ElderlyService {

  /**
   * 查询所有关爱对象（只查询已审核通过的）
   */
  List<ElderlyInfo> findAll(String keyword, String careLevel, Integer livingAlone);

  /**
   * 根据ID查询关爱对象
   */
  ElderlyInfo findById(Long id);

  /**
   * 新增关爱对象
   */
  boolean add(ElderlyInfo elderlyInfo);

  /**
   * 更新关爱对象
   */
  boolean update(ElderlyInfo elderlyInfo);

  /**
   * 删除关爱对象
   */
  boolean delete(Long id);

  /**
   * 统计数量
   */
  int count(String keyword, String careLevel, Integer livingAlone);

  /**
   * 检查身份证号是否已存在
   */
  boolean isIdCardExists(String idCard, Long excludeId);

  /**
   * 根据家属用户ID查询关爱人员列表
   */
  List<ElderlyInfo> findByFamilyUserId(Long familyUserId);

  /**
   * 根据家属用户ID查询已审核通过的关爱人员列表
   */
  List<ElderlyInfo> findApprovedByFamilyUserId(Long familyUserId);

  /**
   * 查询待审核的关爱人员列表
   */
  List<ElderlyInfo> findPendingAudit();

  /**
   * 统计待审核数量
   */
  int countPendingAudit();

  /**
   * 审核关爱人员
   */
  boolean audit(Long id, String auditStatus, Long auditBy, String auditRemark);

  /**
   * 统计家属的关爱人员数量
   */
  int countByFamilyUserId(Long familyUserId);

  /**
   * 统计家属已审核通过的关爱人员数量
   */
  int countApprovedByFamilyUserId(Long familyUserId);

  /**
   * 查询所有已审核通过的关爱人员
   */
  List<ElderlyInfo> findApproved();
}
