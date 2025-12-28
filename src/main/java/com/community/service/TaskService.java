package com.community.service;

import com.community.domain.TaskInfo;

import java.util.List;

/**
 * 任务业务接口
 */
public interface TaskService {

  /**
   * 查询所有任务（管理员）
   */
  List<TaskInfo> findAll(String taskType, String priority, String status, String keyword);

  /**
   * 查询待认领任务（志愿者大厅）
   */
  List<TaskInfo> findPendingTasks(String taskType);

  /**
   * 查询我的任务（志愿者）
   */
  List<TaskInfo> findMyTasks(Long volunteerId, String status);

  /**
   * 根据ID查询任务
   */
  TaskInfo findById(Long id);

  /**
   * 发布任务
   */
  boolean publish(TaskInfo taskInfo);

  /**
   * 更新任务
   */
  boolean update(TaskInfo taskInfo);

  /**
   * 认领任务
   */
  boolean claimTask(Long id, Long volunteerId, String volunteerName);

  /**
   * 开始任务（无位置校验）
   */
  boolean startTask(Long id);

  /**
   * 开始任务（带位置校验）
   * @param id 任务ID
   * @param lat 志愿者当前纬度
   * @param lng 志愿者当前经度
   * @return 结果消息（成功返回null，失败返回错误原因）
   */
  String startTaskWithLocation(Long id, Double lat, Double lng);

  /**
   * 提交任务完成
   */
  boolean submitCompletion(Long id, String completionNote);

  /**
   * 审核任务
   */
  boolean approveTask(Long id, Integer rating, String feedback);

  /**
   * 取消任务
   */
  boolean cancelTask(Long id);

  /**
   * 放弃任务（志愿者）
   */
  boolean releaseTask(Long id);

  /**
   * 统计任务数量
   */
  int countByStatus(String status);

  /**
   * 统计志愿者任务数
   */
  int countVolunteerTasks(Long volunteerId);

  /**
   * 查询志愿者历史任务（支持按年月筛选）
   */
  List<TaskInfo> findHistoryTasks(Long volunteerId, String startDate, String endDate);

  /**
   * 统计志愿者某时间段内的服务次数
   */
  int countServiceTimes(Long volunteerId, String startDate, String endDate);

  /**
   * 统计志愿者某时间段内的平均评分
   */
  Double getAverageRatingByVolunteer(Long volunteerId, String startDate, String endDate);

  /**
   * 更新执行照片
   */
  boolean updateExecutionPhotos(Long id, String executionPhotos);
}
