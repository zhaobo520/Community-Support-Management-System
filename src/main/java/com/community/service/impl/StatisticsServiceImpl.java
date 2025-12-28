package com.community.service.impl;

import com.community.dao.*;
import com.community.dto.DateRangeDTO;
import com.community.dto.StatisticsDTO;
import com.community.service.StatisticsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 统计服务实现类
 */
@Service
@Transactional(readOnly = true)
public class StatisticsServiceImpl implements StatisticsService {

    @Resource
    private DemandMapper demandMapper;

    @Resource
    private TaskMapper taskMapper;

    @Resource
    private VolunteerMapper volunteerMapper;

    @Resource
    private ElderlyMapper elderlyMapper;

    @Resource
    private UserMapper userMapper;

    @Override
    public StatisticsDTO getOverallStatistics() {
        StatisticsDTO dto = new StatisticsDTO();

        // 需求统计
        Long totalDemands = demandMapper.countTotal();
        dto.setTotalDemands(totalDemands != null ? totalDemands : 0L);
        dto.setPendingDemands((long) demandMapper.countByStatus("PENDING"));
        dto.setApprovedDemands((long) demandMapper.countByStatus("APPROVED"));
        dto.setRejectedDemands((long) demandMapper.countByStatus("REJECTED"));
        dto.setMatchedDemands((long) demandMapper.countByStatus("MATCHED"));
        dto.setClosedDemands((long) demandMapper.countByStatus("CLOSED"));

        // 按需求类型统计
        List<Map<String, Object>> demandTypes = demandMapper.countByDemandType();
        for (Map<String, Object> item : demandTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getDemandsByType().put(type, count);
        }

        // 任务统计
        Long totalTasks = taskMapper.countTotal();
        dto.setTotalTasks(totalTasks != null ? totalTasks : 0L);
        dto.setPendingTasks((long) taskMapper.countByStatus("PENDING"));
        dto.setClaimedTasks((long) taskMapper.countByStatus("CLAIMED"));
        dto.setInProgressTasks((long) taskMapper.countByStatus("IN_PROGRESS"));
        dto.setCompletedTasks((long) taskMapper.countByStatus("COMPLETED"));
        dto.setApprovedTasks((long) taskMapper.countByStatus("APPROVED"));
        dto.setCancelledTasks((long) taskMapper.countByStatus("CANCELLED"));

        // 按任务类型统计
        List<Map<String, Object>> taskTypes = taskMapper.countByTaskType();
        for (Map<String, Object> item : taskTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getTasksByType().put(type, count);
        }

        // 平均评分
        Double avgRating = taskMapper.getAverageRating();
        dto.setAverageRating(avgRating != null ? avgRating : 0.0);
        dto.setTotalServices(dto.getApprovedTasks()); // 已审核任务即完成服务

        // 志愿者统计
        Long totalVolunteers = volunteerMapper.countTotal();
        dto.setTotalVolunteers(totalVolunteers != null ? totalVolunteers : 0L);
        Long activeVolunteers = volunteerMapper.countActive();
        dto.setActiveVolunteers(activeVolunteers != null ? activeVolunteers : 0L);
        dto.setPendingVolunteers((long) volunteerMapper.countByStatus("PENDING"));
        dto.setApprovedVolunteers((long) volunteerMapper.countByStatus("APPROVED"));
        dto.setRejectedVolunteers((long) volunteerMapper.countByStatus("REJECTED"));

        // 关爱对象统计
        Long totalElderly = elderlyMapper.countTotal();
        dto.setTotalElderly(totalElderly != null ? totalElderly : 0L);
        Long activeElderly = elderlyMapper.countActive();
        dto.setActiveElderly(activeElderly != null ? activeElderly : 0L);
        Long inactiveElderly = elderlyMapper.countInactive();
        dto.setInactiveElderly(inactiveElderly != null ? inactiveElderly : 0L);

        // 按护理等级统计
        List<Map<String, Object>> careLevels = elderlyMapper.countByCareLevel();
        for (Map<String, Object> item : careLevels) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getElderlyByCareLevel().put(type, count);
        }

        // 用户统计
        Long totalUsers = userMapper.countTotal();
        dto.setTotalUsers(totalUsers != null ? totalUsers : 0L);
        Long familyUsers = userMapper.countByRoleType("FAMILY");
        dto.setFamilyUsers(familyUsers != null ? familyUsers : 0L);
        Long staffUsers = userMapper.countByRoleType("STAFF");
        dto.setStaffUsers(staffUsers != null ? staffUsers : 0L);
        Long volunteerUsers = userMapper.countByRoleType("VOLUNTEER");
        dto.setVolunteerUsers(volunteerUsers != null ? volunteerUsers : 0L);

        return dto;
    }

    @Override
    public StatisticsDTO getOverallStatistics(DateRangeDTO dateRange) {
        StatisticsDTO dto = new StatisticsDTO();

        // 如果没有指定时间范围，使用原有方法
        if (dateRange == null || dateRange.getStartDate() == null) {
            return getOverallStatistics();
        }

        // 需求统计（带时间范围）
        Long totalDemands = demandMapper.countTotalWithDateRange(dateRange.getStartDate(), dateRange.getEndDate());
        dto.setTotalDemands(totalDemands != null ? totalDemands : 0L);
        dto.setPendingDemands((long) demandMapper.countByStatusWithDateRange("PENDING", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setApprovedDemands((long) demandMapper.countByStatusWithDateRange("APPROVED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setRejectedDemands((long) demandMapper.countByStatusWithDateRange("REJECTED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setMatchedDemands((long) demandMapper.countByStatusWithDateRange("MATCHED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setClosedDemands((long) demandMapper.countByStatusWithDateRange("CLOSED", dateRange.getStartDate(), dateRange.getEndDate()));

        // 按需求类型统计（暂时使用全部数据，可以后续优化）
        List<Map<String, Object>> demandTypes = demandMapper.countByDemandType();
        for (Map<String, Object> item : demandTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getDemandsByType().put(type, count);
        }

        // 任务统计（带时间范围）
        Long totalTasks = taskMapper.countTotalWithDateRange(dateRange.getStartDate(), dateRange.getEndDate());
        dto.setTotalTasks(totalTasks != null ? totalTasks : 0L);
        dto.setPendingTasks((long) taskMapper.countByStatusWithDateRange("PENDING", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setClaimedTasks((long) taskMapper.countByStatusWithDateRange("CLAIMED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setInProgressTasks((long) taskMapper.countByStatusWithDateRange("IN_PROGRESS", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setCompletedTasks((long) taskMapper.countByStatusWithDateRange("COMPLETED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setApprovedTasks((long) taskMapper.countByStatusWithDateRange("APPROVED", dateRange.getStartDate(), dateRange.getEndDate()));
        dto.setCancelledTasks((long) taskMapper.countByStatusWithDateRange("CANCELLED", dateRange.getStartDate(), dateRange.getEndDate()));

        // 按任务类型统计（暂时使用全部数据）
        List<Map<String, Object>> taskTypes = taskMapper.countByTaskType();
        for (Map<String, Object> item : taskTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getTasksByType().put(type, count);
        }

        // 平均评分（使用全部数据）
        Double avgRating = taskMapper.getAverageRating();
        dto.setAverageRating(avgRating != null ? avgRating : 0.0);
        dto.setTotalServices(dto.getApprovedTasks());

        // 志愿者统计（使用全部数据，因为志愿者注册时间与统计时间范围关系不大）
        Long totalVolunteers = volunteerMapper.countTotal();
        dto.setTotalVolunteers(totalVolunteers != null ? totalVolunteers : 0L);
        Long activeVolunteers = volunteerMapper.countActive();
        dto.setActiveVolunteers(activeVolunteers != null ? activeVolunteers : 0L);
        dto.setPendingVolunteers((long) volunteerMapper.countByStatus("PENDING"));
        dto.setApprovedVolunteers((long) volunteerMapper.countByStatus("APPROVED"));
        dto.setRejectedVolunteers((long) volunteerMapper.countByStatus("REJECTED"));

        // 关爱对象统计（使用全部数据）
        Long totalElderly = elderlyMapper.countTotal();
        dto.setTotalElderly(totalElderly != null ? totalElderly : 0L);
        Long activeElderly = elderlyMapper.countActive();
        dto.setActiveElderly(activeElderly != null ? activeElderly : 0L);
        Long inactiveElderly = elderlyMapper.countInactive();
        dto.setInactiveElderly(inactiveElderly != null ? inactiveElderly : 0L);

        // 按护理等级统计
        List<Map<String, Object>> careLevels = elderlyMapper.countByCareLevel();
        for (Map<String, Object> item : careLevels) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getElderlyByCareLevel().put(type, count);
        }

        // 用户统计（使用全部数据）
        Long totalUsers = userMapper.countTotal();
        dto.setTotalUsers(totalUsers != null ? totalUsers : 0L);
        Long familyUsers = userMapper.countByRoleType("FAMILY");
        dto.setFamilyUsers(familyUsers != null ? familyUsers : 0L);
        Long staffUsers = userMapper.countByRoleType("STAFF");
        dto.setStaffUsers(staffUsers != null ? staffUsers : 0L);
        Long volunteerUsers = userMapper.countByRoleType("VOLUNTEER");
        dto.setVolunteerUsers(volunteerUsers != null ? volunteerUsers : 0L);

        return dto;
    }

    @Override
    public StatisticsDTO getDemandStatistics() {
        StatisticsDTO dto = new StatisticsDTO();

        dto.setTotalDemands(demandMapper.countTotal());
        dto.setPendingDemands((long) demandMapper.countByStatus("PENDING"));
        dto.setApprovedDemands((long) demandMapper.countByStatus("APPROVED"));
        dto.setRejectedDemands((long) demandMapper.countByStatus("REJECTED"));
        dto.setMatchedDemands((long) demandMapper.countByStatus("MATCHED"));
        dto.setClosedDemands((long) demandMapper.countByStatus("CLOSED"));

        // 按需求类型统计
        List<Map<String, Object>> demandTypes = demandMapper.countByDemandType();
        for (Map<String, Object> item : demandTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getDemandsByType().put(type, count);
        }

        return dto;
    }

    @Override
    public StatisticsDTO getTaskStatistics() {
        StatisticsDTO dto = new StatisticsDTO();

        dto.setTotalTasks(taskMapper.countTotal());
        dto.setPendingTasks((long) taskMapper.countByStatus("PENDING"));
        dto.setClaimedTasks((long) taskMapper.countByStatus("CLAIMED"));
        dto.setInProgressTasks((long) taskMapper.countByStatus("IN_PROGRESS"));
        dto.setCompletedTasks((long) taskMapper.countByStatus("COMPLETED"));
        dto.setApprovedTasks((long) taskMapper.countByStatus("APPROVED"));
        dto.setCancelledTasks((long) taskMapper.countByStatus("CANCELLED"));

        // 按任务类型统计
        List<Map<String, Object>> taskTypes = taskMapper.countByTaskType();
        for (Map<String, Object> item : taskTypes) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getTasksByType().put(type, count);
        }

        // 平均评分
        dto.setAverageRating(taskMapper.getAverageRating());

        return dto;
    }

    @Override
    public StatisticsDTO getVolunteerStatistics() {
        StatisticsDTO dto = new StatisticsDTO();

        dto.setTotalVolunteers(volunteerMapper.countTotal());
        dto.setActiveVolunteers(volunteerMapper.countActive());
        dto.setPendingVolunteers((long) volunteerMapper.countByStatus("PENDING"));
        dto.setApprovedVolunteers((long) volunteerMapper.countByStatus("APPROVED"));
        dto.setRejectedVolunteers((long) volunteerMapper.countByStatus("REJECTED"));

        return dto;
    }

    @Override
    public StatisticsDTO getElderlyStatistics() {
        StatisticsDTO dto = new StatisticsDTO();

        dto.setTotalElderly(elderlyMapper.countTotal());
        dto.setActiveElderly(elderlyMapper.countActive());
        dto.setInactiveElderly(elderlyMapper.countInactive());

        // 按护理等级统计
        List<Map<String, Object>> careLevels = elderlyMapper.countByCareLevel();
        for (Map<String, Object> item : careLevels) {
            String type = (String) item.get("type");
            Long count = (Long) item.get("count");
            dto.getElderlyByCareLevel().put(type, count);
        }

        return dto;
    }
}
