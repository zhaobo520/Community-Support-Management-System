package com.community.service;

import com.community.domain.CarePlan;

import java.util.List;
import java.util.Map;

/**
 * 关爱计划服务接口
 */
public interface CarePlanService {

    // ==================== 基础查询 ====================

    /**
     * 根据ID查询
     */
    CarePlan findById(Long id);

    /**
     * 根据家属用户ID查询
     */
    List<CarePlan> findByFamilyUserId(Long familyUserId);

    /**
     * 查询所有（管理员）
     */
    List<CarePlan> findAll();

    /**
     * 根据状态查询
     */
    List<CarePlan> findByStatus(String status);

    /**
     * 根据审核状态查询
     */
    List<CarePlan> findByAuditStatus(String auditStatus);

    /**
     * 查询待审核的计划
     */
    List<CarePlan> findPendingAudit();

    /**
     * 查询可认领的计划
     */
    List<CarePlan> findClaimable();

    /**
     * 根据志愿者ID查询
     */
    List<CarePlan> findByVolunteerId(Long volunteerId);

    // ==================== 增删改 ====================

    /**
     * 创建关爱计划（家属发布）
     */
    boolean create(CarePlan plan);

    /**
     * 更新关爱计划
     */
    boolean update(CarePlan plan);

    /**
     * 删除关爱计划
     */
    boolean delete(Long id);

    // ==================== 审核相关 ====================

    /**
     * 审核计划（管理员）
     */
    boolean audit(Long id, String auditStatus, Long auditBy, String auditRemark);

    /**
     * 审核通过
     */
    boolean approve(Long id, Long auditBy, String remark);

    /**
     * 审核拒绝
     */
    boolean reject(Long id, Long auditBy, String remark);

    // ==================== 认领相关 ====================

    /**
     * 志愿者认领计划
     */
    boolean claim(Long id, Long volunteerId);

    /**
     * 取消认领
     */
    boolean unclaim(Long id, Long volunteerId);

    // ==================== 状态更新 ====================

    /**
     * 更新状态
     */
    boolean updateStatus(Long id, String status);

    /**
     * 更新已完成服务次数
     */
    boolean updateCompletedServices(Long id, Integer completedServices);

    /**
     * 更新已审核通过服务次数
     */
    boolean updateApprovedServices(Long id, Integer approvedServices);

    /**
     * 增加已完成服务次数（+1）
     */
    boolean incrementCompletedServices(Long id);

    /**
     * 增加已审核通过服务次数（+1）
     */
    boolean incrementApprovedServices(Long id);

    // ==================== 统计 ====================

    /**
     * 统计：根据家属用户ID
     */
    int countByFamilyUserId(Long familyUserId);

    /**
     * 统计：根据家属用户ID和状态
     */
    int countActiveByFamilyUserId(Long familyUserId);

    /**
     * 统计：全部
     */
    int countAll();

    /**
     * 统计：根据状态
     */
    int countByStatus(String status);

    /**
     * 统计：根据审核状态
     */
    int countByAuditStatus(String auditStatus);

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
    int countByVolunteerId(Long volunteerId);

    /**
     * 统计：根据志愿者ID和状态
     */
    int countActiveByVolunteerId(Long volunteerId);

    /**
     * 获取统计数据（管理员仪表盘）
     */
    Map<String, Object> getStatistics();

    // ==================== 业务方法 ====================

    /**
     * 检查计划是否属于指定家属
     */
    boolean belongsToFamily(Long planId, Long familyUserId);

    /**
     * 检查计划是否属于指定志愿者
     */
    boolean belongsToVolunteer(Long planId, Long volunteerId);

    /**
     * 检查计划是否可以被认领
     */
    boolean canBeClaimed(Long planId);

    /**
     * 检查计划是否已完成
     */
    boolean isCompleted(Long planId);

    /**
     * 自动检查并更新计划完成状态
     */
    void checkAndUpdateCompletionStatus(Long planId);
}
