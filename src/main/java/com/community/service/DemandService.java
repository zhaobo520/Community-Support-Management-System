package com.community.service;

import com.community.domain.Demand;

import java.util.List;
import java.util.Map;

/**
 * 需求服务接口
 */
public interface DemandService {

    /**
     * 创建需求
     */
    boolean create(Demand demand);

    /**
     * 更新需求
     */
    boolean update(Demand demand);

    /**
     * 根据ID查询需求
     */
    Demand findById(Long id);

    /**
     * 查询所有需求
     */
    List<Demand> findAll();

    /**
     * 根据家属用户ID查询需求列表
     */
    List<Demand> findByFamilyUserId(Long familyUserId);

    /**
     * 查询待审核的需求
     */
    List<Demand> findPendingDemands();

    /**
     * 查询已通过的需求
     */
    List<Demand> findApprovedDemands();

    /**
     * 审核需求（通过）
     */
    boolean approve(Long id, Long reviewerId, String reviewComment);

    /**
     * 审核需求（拒绝）
     */
    boolean reject(Long id, Long reviewerId, String reviewComment);

    /**
     * 删除需求
     */
    boolean delete(Long id);

    /**
     * 关联任务
     */
    boolean linkTask(Long demandId, Long taskId);

    /**
     * 获取需求统计信息
     */
    Map<String, Object> getStatistics(Long familyUserId);

    /**
     * 获取管理员需求统计
     */
    Map<String, Object> getAdminStatistics();
}
