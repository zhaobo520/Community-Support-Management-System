package com.community.dao;

import com.community.domain.CarePlan;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 关爱计划Mapper
 */
public interface CarePlanMapper {

    /**
     * 根据ID查询
     */
    CarePlan findById(@Param("id") Long id);

    /**
     * 根据家属用户ID查询
     */
    List<CarePlan> findByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * 查询所有（管理员）
     */
    List<CarePlan> findAll();

    /**
     * 根据状态查询
     */
    List<CarePlan> findByStatus(@Param("status") String status);

    /**
     * 根据审核状态查询
     */
    List<CarePlan> findByAuditStatus(@Param("auditStatus") String auditStatus);

    /**
     * 查询待审核的计划
     */
    List<CarePlan> findPendingAudit();

    /**
     * 查询可认领的计划（已审核通过且未被认领）
     */
    List<CarePlan> findClaimable();

    /**
     * 根据志愿者ID查询已认领的计划
     */
    List<CarePlan> findByVolunteerId(@Param("volunteerId") Long volunteerId);

    /**
     * 插入
     */
    int insert(CarePlan plan);

    /**
     * 更新
     */
    int update(CarePlan plan);

    /**
     * 审核计划
     */
    int audit(@Param("id") Long id, @Param("auditStatus") String auditStatus,
              @Param("auditBy") Long auditBy, @Param("auditRemark") String auditRemark);

    /**
     * 认领计划
     */
    int claim(@Param("id") Long id, @Param("volunteerId") Long volunteerId);

    /**
     * 更新状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 更新已完成服务次数
     */
    int updateCompletedServices(@Param("id") Long id, @Param("completedServices") Integer completedServices);

    /**
     * 更新已审核通过服务次数
     */
    int updateApprovedServices(@Param("id") Long id, @Param("approvedServices") Integer approvedServices);

    /**
     * 删除
     */
    int deleteById(@Param("id") Long id);

    /**
     * 统计：根据家属用户ID
     */
    int countByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * 统计：根据家属用户ID和状态
     */
    int countActiveByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * 统计：全部
     */
    int countAll();

    /**
     * 统计：根据状态
     */
    int countByStatus(@Param("status") String status);

    /**
     * 统计：根据审核状态
     */
    int countByAuditStatus(@Param("auditStatus") String auditStatus);

    /**
     * 统计：待审核
     */
    int countPendingAudit();

    /**
     * 统计：可认领
     */
    int countClaimable();

    /**
     * 统计：根据志愿者ID
     */
    int countByVolunteerId(@Param("volunteerId") Long volunteerId);

    /**
     * 统计：根据志愿者ID和状态
     */
    int countActiveByVolunteerId(@Param("volunteerId") Long volunteerId);
}
