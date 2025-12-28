package com.community.dao;

import com.community.domain.Demand;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 需求数据访问接口
 */
public interface DemandMapper {

    /**
     * 插入需求
     */
    int insert(Demand demand);

    /**
     * 更新需求
     */
    int update(Demand demand);

    /**
     * 根据ID查询需求（带关联信息）
     */
    Demand findById(Long id);

    /**
     * 根据ID查询需求（不带关联）
     */
    Demand findByIdSimple(Long id);

    /**
     * 查询所有需求（带关联信息）
     */
    List<Demand> findAll();

    /**
     * 根据家属用户ID查询需求列表
     */
    List<Demand> findByFamilyUserId(Long familyUserId);

    /**
     * 根据状态查询需求列表
     */
    List<Demand> findByStatus(@Param("status") String status);

    /**
     * 查询待审核的需求
     */
    List<Demand> findPendingDemands();

    /**
     * 查询已通过的需求
     */
    List<Demand> findApprovedDemands();

    /**
     * 统计家属的需求数量
     */
    int countByFamilyUserId(Long familyUserId);

    /**
     * 统计各状态的需求数量
     */
    int countByStatus(@Param("status") String status);

    /**
     * 删除需求
     */
    int delete(Long id);

    /**
     * 审核需求
     */
    int review(@Param("id") Long id, 
               @Param("status") String status, 
               @Param("reviewerId") Long reviewerId, 
               @Param("reviewComment") String reviewComment);

    /**
     * 关联任务
     */
    int linkTask(@Param("id") Long id, @Param("taskId") Long taskId);

    /**
     * 按需求类型统计数量
     */
    List<java.util.Map<String, Object>> countByDemandType();

    /**
     * 统计总需求数
     */
    Long countTotal();

    /**
     * 统计指定时间范围内的需求数（按状态）
     */
    int countByStatusWithDateRange(@Param("status") String status, 
                                  @Param("startDate") java.util.Date startDate,
                                  @Param("endDate") java.util.Date endDate);

    /**
     * 统计指定时间范围内的总需求数
     */
    Long countTotalWithDateRange(@Param("startDate") java.util.Date startDate,
                                @Param("endDate") java.util.Date endDate);
}
