package com.community.dao;

import com.community.domain.CarePlanServiceRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 关爱计划服务记录Mapper
 */
public interface CarePlanServiceRecordMapper {

    /**
     * 根据ID查询
     */
    CarePlanServiceRecord findById(@Param("id") Long id);

    /**
     * 根据计划ID查询所有服务记录
     */
    List<CarePlanServiceRecord> findByPlanId(@Param("planId") Long planId);

    /**
     * 根据计划ID和周期编号查询服务记录
     */
    List<CarePlanServiceRecord> findByPlanIdAndPeriod(@Param("planId") Long planId,
                                                       @Param("periodNumber") Integer periodNumber);

    /**
     * 根据志愿者ID查询服务记录
     */
    List<CarePlanServiceRecord> findByVolunteerId(@Param("volunteerId") Long volunteerId);

    /**
     * 查询待审核的服务记录
     */
    List<CarePlanServiceRecord> findPendingAudit();

    /**
     * 查询所有服务记录
     */
    List<CarePlanServiceRecord> findAll();

    /**
     * 根据审核状态查询
     */
    List<CarePlanServiceRecord> findByAuditStatus(@Param("auditStatus") String auditStatus);

    /**
     * 插入服务记录
     */
    int insert(CarePlanServiceRecord record);

    /**
     * 更新服务记录
     */
    int update(CarePlanServiceRecord record);

    /**
     * 审核服务记录
     */
    int audit(@Param("id") Long id, @Param("auditStatus") String auditStatus,
              @Param("auditBy") Long auditBy, @Param("auditRemark") String auditRemark);

    /**
     * 删除服务记录
     */
    int deleteById(@Param("id") Long id);

    /**
     * 统计所有服务记录数
     */
    int countAll();

    /**
     * 统计计划的服务记录数
     */
    int countByPlanId(@Param("planId") Long planId);

    /**
     * 统计计划的已审核通过服务记录数
     */
    int countApprovedByPlanId(@Param("planId") Long planId);

    /**
     * 统计志愿者的服务记录数
     */
    int countByVolunteerId(@Param("volunteerId") Long volunteerId);

    /**
     * 统计待审核的服务记录数
     */
    int countPendingAudit();

    /**
     * 根据审核状态统计
     */
    int countByAuditStatus(@Param("auditStatus") String auditStatus);

    /**
     * 统计周期的已提交服务次数
     */
    int countByPlanIdAndPeriod(@Param("planId") Long planId,
                                @Param("periodNumber") Integer periodNumber);

    /**
     * 统计周期的已审核通过服务次数
     */
    int countApprovedByPlanIdAndPeriod(@Param("planId") Long planId,
                                        @Param("periodNumber") Integer periodNumber);

    /**
     * 获取本周期下一个服务编号
     */
    int getNextServiceNumber(@Param("planId") Long planId,
                              @Param("periodNumber") Integer periodNumber);
}
