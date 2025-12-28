package com.community.service.impl;

import com.community.dao.TaskMapper;
import com.community.domain.TaskInfo;
import com.community.service.TaskService;
import com.community.utils.DistanceUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * 任务业务实现类
 */
@Service("taskService")
@Transactional
public class TaskServiceImpl implements TaskService {

  private static final Logger log = LoggerFactory.getLogger(TaskServiceImpl.class);
  private static final double MAX_DISTANCE_METERS = 500.0; // 最大允许距离：500米

  @Resource
  private TaskMapper taskMapper;

  @Override
  public List<TaskInfo> findAll(String taskType, String priority, String status, String keyword) {
    return taskMapper.findAll(taskType, priority, status, keyword);
  }

  @Override
  public List<TaskInfo> findPendingTasks(String taskType) {
    return taskMapper.findPendingTasks(taskType);
  }

  @Override
  public List<TaskInfo> findMyTasks(Long volunteerId, String status) {
    return taskMapper.findMyTasks(volunteerId, status);
  }

  @Override
  public TaskInfo findById(Long id) {
    return taskMapper.findById(id);
  }

  @Override
  public boolean publish(TaskInfo taskInfo) {
    if (taskInfo == null || taskInfo.getTaskTitle() == null) {
      log.warn("Invalid task info for publish");
      return false;
    }

    int rows = taskMapper.insert(taskInfo);
    if (rows > 0) {
      log.info("Published task: {}", taskInfo.getTaskTitle());
      return true;
    }
    return false;
  }

  @Override
  public boolean update(TaskInfo taskInfo) {
    if (taskInfo == null || taskInfo.getId() == null) {
      log.warn("Invalid task info for update");
      return false;
    }

    int rows = taskMapper.update(taskInfo);
    if (rows > 0) {
      log.info("Updated task: {}", taskInfo.getId());
      return true;
    }
    return false;
  }

  @Override
  public boolean claimTask(Long id, Long volunteerId, String volunteerName) {
    if (id == null || volunteerId == null) {
      return false;
    }

    TaskInfo task = taskMapper.findById(id);
    if (task == null || !"PENDING".equals(task.getStatus())) {
      log.warn("Task {} is not available for claiming", id);
      return false;
    }

    int rows = taskMapper.claimTask(id, volunteerId, volunteerName);
    if (rows > 0) {
      log.info("Volunteer {} claimed task {}", volunteerId, id);
      return true;
    }
    return false;
  }

  @Override
  public boolean startTask(Long id) {
    if (id == null) {
      return false;
    }

    TaskInfo task = taskMapper.findById(id);
    if (task == null || !"CLAIMED".equals(task.getStatus())) {
      log.warn("Task {} cannot be started", id);
      return false;
    }

    int rows = taskMapper.updateStatus(id, "IN_PROGRESS");
    if (rows > 0) {
      log.info("Started task {}", id);
      return true;
    }
    return false;
  }

  @Override
  public String startTaskWithLocation(Long id, Double lat, Double lng) {
      if (id == null) {
          return "参数错误";
      }

      TaskInfo task = taskMapper.findById(id);
      if (task == null) {
          return "任务不存在";
      }
      if (!"CLAIMED".equals(task.getStatus())) {
          return "任务状态不正确，无法开始";
      }
      
      // 位置校验逻辑
      if (task.getLatitude() != null && task.getLongitude() != null) {
          if (lat == null || lng == null) {
              return "请开启定位服务，此任务需要地理围栏签到";
          }
          
          double distance = DistanceUtil.getDistance(lat, lng, task.getLatitude(), task.getLongitude());
          log.info("Task {} start check: user at ({}, {}), task at ({}, {}), distance: {}m", 
                  id, lat, lng, task.getLatitude(), task.getLongitude(), distance);
                  
          if (distance > MAX_DISTANCE_METERS) {
              return String.format("距离任务地点 %.0f 米，超过限制(500米)，请到达指定地点后再试", distance);
          }
      }
      
      // 通过校验，开始任务
      int rows = taskMapper.updateStatus(id, "IN_PROGRESS");
      if (rows > 0) {
          log.info("Started task {} with location check passed", id);
          return null; // null indicates success
      }
      return "系统错误，更新状态失败";
  }

  @Override
  public boolean submitCompletion(Long id, String completionNote) {
    if (id == null) {
      return false;
    }

    TaskInfo task = taskMapper.findById(id);
    if (task == null || !("IN_PROGRESS".equals(task.getStatus()) || "CLAIMED".equals(task.getStatus()))) {
      log.warn("Task {} cannot be completed", id);
      return false;
    }

    int rows = taskMapper.submitCompletion(id, completionNote);
    if (rows > 0) {
      log.info("Submitted completion for task {}", id);
      return true;
    }
    return false;
  }

  @Override
  public boolean approveTask(Long id, Integer rating, String feedback) {
    if (id == null) {
      return false;
    }

    TaskInfo task = taskMapper.findById(id);
    if (task == null || !"COMPLETED".equals(task.getStatus())) {
      log.warn("Task {} cannot be approved", id);
      return false;
    }

    int rows = taskMapper.approveTask(id, rating, feedback);
    if (rows > 0) {
      log.info("Approved task {}", id);
      return true;
    }
    return false;
  }

  @Override
  public boolean cancelTask(Long id) {
    if (id == null) {
      return false;
    }

    int rows = taskMapper.updateStatus(id, "CANCELLED");
    if (rows > 0) {
      log.info("Cancelled task {}", id);
      return true;
    }
    return false;
  }

  @Override
  public boolean releaseTask(Long id) {
    if (id == null) {
      return false;
    }

    int rows = taskMapper.releaseTask(id);
    if (rows > 0) {
      log.info("Released task {}", id);
      return true;
    }
    return false;
  }

  @Override
  public int countByStatus(String status) {
    return taskMapper.countByStatus(status);
  }

  @Override
  public int countVolunteerTasks(Long volunteerId) {
    return taskMapper.countVolunteerTasks(volunteerId);
  }

  @Override
  public List<TaskInfo> findHistoryTasks(Long volunteerId, String startDate, String endDate) {
    return taskMapper.findHistoryTasks(volunteerId, startDate, endDate);
  }

  @Override
  public int countServiceTimes(Long volunteerId, String startDate, String endDate) {
    return taskMapper.countServiceTimes(volunteerId, startDate, endDate);
  }

  @Override
  public Double getAverageRatingByVolunteer(Long volunteerId, String startDate, String endDate) {
    Double rating = taskMapper.getAverageRatingByVolunteer(volunteerId, startDate, endDate);
    return rating != null ? rating : 0.0;
  }

  @Override
  public boolean updateExecutionPhotos(Long id, String executionPhotos) {
    if (id == null) {
      return false;
    }
    int rows = taskMapper.updateExecutionPhotos(id, executionPhotos);
    if (rows > 0) {
      log.info("Updated execution photos for task {}", id);
      return true;
    }
    return false;
  }
}
