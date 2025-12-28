package com.community.dao;

import com.community.domain.CarePlanPeriod;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 关爱计划周期Mapper
 */
public interface CarePlanPeriodMapper {

    /**
     * 根据ID查询
     */
    CarePlanPeriod findById(@Param("id") Long id);

    /**
     * 根据计划ID查询所有周期
     */
    List<CarePlanPeriod> findByCarePlanId(@Param("carePlanId") Long carePlanId);

    /**
     * 根据计划ID和周期编号查询
     */
    CarePlanPeriod findByCarePlanIdAndPeriodNumber(@Param("carePlanId") Long carePlanId,
                                                    @Param("periodNumber") Integer periodNumber);

    /**
     * 插入周期
     */
    int insert(CarePlanPeriod period);

    /**
     * 批量插入周期
     */
    int batchInsert(@Param("list") List<CarePlanPeriod> periods);

    /**
     * 更新周期
     */
    int update(CarePlanPeriod period);

    /**
     * 更新周期已完成服务次数
     */
    int updateCompletedServices(@Param("id") Long id, @Param("completedServices") Integer completedServices);

    /**
     * 更新周期已审核通过服务次数
     */
    int updateApprovedServices(@Param("id") Long id, @Param("approvedServices") Integer approvedServices);

    /**
     * 更新周期状态
     */
    int updateStatus(@Param("id") Long id, @Param("status") String status);

    /**
     * 删除周期
     */
    int deleteById(@Param("id") Long id);

    /**
     * 根据计划ID删除所有周期
     */
    int deleteByCarePlanId(@Param("carePlanId") Long carePlanId);

    /**
     * 统计计划的周期数
     */
    int countByCarePlanId(@Param("carePlanId") Long carePlanId);

    /**
     * 获取当前进行中的周期
     */
    CarePlanPeriod findCurrentPeriod(@Param("carePlanId") Long carePlanId);
}
