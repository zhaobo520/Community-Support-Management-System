package com.community.dao;

import com.community.domain.TaskInfo;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 任务数据访问接口
 */
public interface TaskMapper {

  /**
   * 查询所有任务（管理员）
   */
  List<TaskInfo> findAll(@Param("taskType") String taskType,
                         @Param("priority") String priority,
                         @Param("status") String status,
                         @Param("keyword") String keyword);

  /**
   * 查询待认领任务（志愿者大厅）
   */
  List<TaskInfo> findPendingTasks(@Param("taskType") String taskType);

  /**
   * 查询我的任务（志愿者）
   */
  List<TaskInfo> findMyTasks(@Param("volunteerId") Long volunteerId,
                             @Param("status") String status);

  /**
   * 根据ID查询任务
   */
  TaskInfo findById(Long id);

  /**
   * 新增任务
   */
  int insert(TaskInfo taskInfo);

  /**
   * 更新任务
   */
  int update(TaskInfo taskInfo);

  /**
   * 认领任务
   */
  int claimTask(@Param("id") Long id,
                @Param("volunteerId") Long volunteerId,
                @Param("volunteerName") String volunteerName);

  /**
   * 更新任务状态
   */
  int updateStatus(@Param("id") Long id, @Param("status") String status);

  /**
   * 提交任务完成
   */
  int submitCompletion(@Param("id") Long id,
                       @Param("completionNote") String completionNote);

  /**
   * 审核任务
   */
  int approveTask(@Param("id") Long id,
                  @Param("rating") Integer rating,
                  @Param("feedback") String feedback);

  /**
   * 统计任务数量
   */
  int countByStatus(@Param("status") String status);

  /**
   * 统计志愿者任务数
   */
  int countVolunteerTasks(@Param("volunteerId") Long volunteerId);

  /**
   * 按任务类型统计数量
   */
  List<java.util.Map<String, Object>> countByTaskType();

  /**
   * 统计总任务数
   */
  Long countTotal();

  /**
   * 统计平均评分
   */
  Double getAverageRating();

  /**
   * 统计指定时间范围内的任务数（按状态）
   */
  int countByStatusWithDateRange(@Param("status") String status,
                                  @Param("startDate") java.util.Date startDate,
                                  @Param("endDate") java.util.Date endDate);

  /**
   * 统计指定时间范围内的总任务数
   */
  Long countTotalWithDateRange(@Param("startDate") java.util.Date startDate,
                                @Param("endDate") java.util.Date endDate);

  /**
   * 查询志愿者历史任务（支持按年月筛选）
   */
  List<TaskInfo> findHistoryTasks(@Param("volunteerId") Long volunteerId,
                                  @Param("startDate") String startDate,
                                  @Param("endDate") String endDate);

  /**
   * 统计志愿者某时间段内的服务次数（已完成/已审核）
   */
  int countServiceTimes(@Param("volunteerId") Long volunteerId,
                        @Param("startDate") String startDate,
                        @Param("endDate") String endDate);

  /**
   * 统计志愿者某时间段内的平均评分
   */
  Double getAverageRatingByVolunteer(@Param("volunteerId") Long volunteerId,
                                     @Param("startDate") String startDate,
                                     @Param("endDate") String endDate);

  /**
   * 查询志愿者在指定日期和时间段的任务（用于排班冲突检测）
   * @param volunteerId 志愿者ID
   * @param scheduledDate 服务日期
   * @param timeSlot 时间段（MORNING/AFTERNOON/EVENING）
   * @return 该时段的任务列表
   */
  List<TaskInfo> findTasksByVolunteerAndTime(@Param("volunteerId") Long volunteerId,
                                             @Param("scheduledDate") Date scheduledDate,
                                             @Param("timeSlot") String timeSlot);
  /**
   * 释放任务（放弃任务，重置为待认领）
   */
  int releaseTask(Long id);

  /**
   * 更新执行照片
   */
  int updateExecutionPhotos(@Param("id") Long id, @Param("executionPhotos") String executionPhotos);
}
