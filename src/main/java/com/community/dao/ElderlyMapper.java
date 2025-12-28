package com.community.dao;

import com.community.domain.ElderlyInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 关爱对象数据访问接口
 */
public interface ElderlyMapper {

  /**
   * 查询所有关爱对象（支持搜索和筛选）- 只查询已审核通过的
   */
  List<ElderlyInfo> findAll(@Param("keyword") String keyword,
                            @Param("careLevel") String careLevel,
                            @Param("livingAlone") Integer livingAlone);

  /**
   * 根据ID查询关爱对象
   */
  ElderlyInfo findById(Long id);

  /**
   * 新增关爱对象
   */
  int insert(ElderlyInfo elderlyInfo);

  /**
   * 更新关爱对象
   */
  int update(ElderlyInfo elderlyInfo);

  /**
   * 删除关爱对象（逻辑删除）
   */
  int delete(Long id);

  /**
   * 统计总数
   */
  int count(@Param("keyword") String keyword,
            @Param("careLevel") String careLevel,
            @Param("livingAlone") Integer livingAlone);

  /**
   * 检查身份证号是否已存在
   */
  int checkIdCard(@Param("idCard") String idCard, @Param("excludeId") Long excludeId);

  /**
   * 按护理等级统计数量
   */
  List<Map<String, Object>> countByCareLevel();

  /**
   * 统计总数（启用状态）
   */
  Long countActive();

  /**
   * 统计总数（停用状态）
   */
  Long countInactive();

  /**
   * 统计总数
   */
  Long countTotal();

  /**
   * 根据家属用户ID查询关爱人员列表
   */
  List<ElderlyInfo> findByFamilyUserId(@Param("familyUserId") Long familyUserId);

  /**
   * 根据家属用户ID查询已审核通过的关爱人员列表
   */
  List<ElderlyInfo> findApprovedByFamilyUserId(@Param("familyUserId") Long familyUserId);

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
  int audit(@Param("id") Long id, @Param("auditStatus") String auditStatus,
            @Param("auditBy") Long auditBy, @Param("auditRemark") String auditRemark);

  /**
   * 统计家属的关爱人员数量
   */
  int countByFamilyUserId(@Param("familyUserId") Long familyUserId);

  /**
   * 统计家属已审核通过的关爱人员数量
   */
  int countApprovedByFamilyUserId(@Param("familyUserId") Long familyUserId);

  /**
   * 查询所有已审核通过的关爱人员
   */
  List<ElderlyInfo> findApproved();
}
