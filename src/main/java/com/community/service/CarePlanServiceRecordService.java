package com.community.service;

import com.community.domain.CarePlanServiceRecord;

import java.util.List;
import java.util.Map;

/**
 * 关爱计划服务记录Service接口
 */
public interface CarePlanServiceRecordService {

    // ==================== 基础查询 ====================

    /**
     * 根据ID查询
     */
    CarePlanServiceRecord findById(Long id);

    /**
     * 根据计划ID查询所有服务记录
     */
    List<CarePlanServiceRecord> findByPlanId(Long planId);

    /**
     * 根据计划ID和周期号查询服务记录
     */
    List<CarePlanServiceRecord> findByPlanIdAndPeriod(Long planId, Integer periodNumber);

    /**
     * 根据志愿者ID查询服务记录
     */
    List<CarePlanServiceRecord> findByVolunteerId(Long volunteerId);

    /**
     * 查询待审核的服务记录
     */
    List<CarePlanServiceRecord> findPendingAudit();

    /**
     * 查询所有服务记录（管理员）
     */
    List<CarePlanServiceRecord> findAll();

    /**
     * 根据审核状态查询
     */
    List<CarePlanServiceRecord> findByAuditStatus(String auditStatus);

    // ==================== 增删改 ====================

    /**
     * 创建服务记录（志愿者提交）
     */
    boolean create(CarePlanServiceRecord record);

    /**
     * 更新服务记录
     */
    boolean update(CarePlanServiceRecord record);

    /**
     * 删除服务记录
     */
    boolean delete(Long id);

    // ==================== 审核相关 ====================

    /**
     * 审核服务记录（管理员）
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

    // ==================== 统计 ====================

    /**
     * 统计计划的服务记录数
     */
    int countByPlanId(Long planId);

    /**
     * 统计计划的已审核通过服务记录数
     */
    int countApprovedByPlanId(Long planId);

    /**
     * 统计志愿者的服务记录数
     */
    int countByVolunteerId(Long volunteerId);

    /**
     * 统计待审核的服务记录数
     */
    int countPendingAudit();

    /**
     * 获取统计数据
     */
    Map<String, Object> getStatistics();

    // ==================== 业务方法 ====================

    /**
     * 检查服务记录是否属于指定志愿者
     */
    boolean belongsToVolunteer(Long recordId, Long volunteerId);

    /**
     * 检查服务记录是否属于指定计划
     */
    boolean belongsToPlan(Long recordId, Long planId);

    /**
     * 获取计划当前周期的服务记录
     */
    List<CarePlanServiceRecord> getCurrentPeriodRecords(Long planId);

    /**
     * 检查当前周期是否已完成
     */
    boolean isCurrentPeriodCompleted(Long planId);
}
