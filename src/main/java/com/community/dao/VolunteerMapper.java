package com.community.dao;

import com.community.domain.VolunteerProfile;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 志愿者数据访问接口
 */
public interface VolunteerMapper {

  /**
   * 查询所有志愿者（含用户信息）
   */
  List<VolunteerProfile> findAll(@Param("status") String status,
                                  @Param("keyword") String keyword);

  /**
   * 根据ID查询志愿者详情
   */
  VolunteerProfile findById(Long id);

  /**
   * 根据用户ID查询志愿者信息
   */
  VolunteerProfile findByUserId(Long userId);

  /**
   * 新增志愿者信息
   */
  int insert(VolunteerProfile profile);

  /**
   * 更新志愿者信息
   */
  int update(VolunteerProfile profile);

  /**
   * 审核志愿者
   */
  int approve(@Param("id") Long id,
              @Param("status") String status,
              @Param("approveBy") Long approveBy);

  /**
   * 更新服务统计
   */
  int updateServiceStats(@Param("userId") Long userId,
                         @Param("serviceHours") Double serviceHours,
                         @Param("taskCount") Integer taskCount,
                         @Param("averageRating") Double averageRating);

  /**
   * 统计志愿者数量
   */
  int countByStatus(@Param("status") String status);

  /**
   * 检查用户是否已有志愿者信息
   */
  int existsByUserId(Long userId);

  /**
   * 统计总志愿者数
   */
  Long countTotal();

  /**
   * 统计活跃志愿者数（最近30天有服务记录）
   */
  Long countActive();
}
