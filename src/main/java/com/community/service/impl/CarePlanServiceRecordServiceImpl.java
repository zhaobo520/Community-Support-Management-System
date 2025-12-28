package com.community.service.impl;

import com.community.dao.CarePlanMapper;
import com.community.dao.CarePlanServiceRecordMapper;
import com.community.domain.CarePlan;
import com.community.domain.CarePlanServiceRecord;
import com.community.service.CarePlanService;
import com.community.service.CarePlanServiceRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 关爱计划服务记录Service实现
 */
@Service("carePlanServiceRecordService")
public class CarePlanServiceRecordServiceImpl implements CarePlanServiceRecordService {

    private static final Logger log = LoggerFactory.getLogger(CarePlanServiceRecordServiceImpl.class);

    @Resource
    private CarePlanServiceRecordMapper recordMapper;

    @Resource
    private CarePlanMapper carePlanMapper;

    @Resource
    private CarePlanService carePlanService;

    // ==================== 基础查询 ====================

    @Override
    public CarePlanServiceRecord findById(Long id) {
        try {
            return recordMapper.findById(id);
        } catch (Exception e) {
            log.error("根据ID查询服务记录失败: {}", id, e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findByPlanId(Long planId) {
        try {
            return recordMapper.findByPlanId(planId);
        } catch (Exception e) {
            log.error("根据计划ID查询服务记录失败: {}", planId, e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findByPlanIdAndPeriod(Long planId, Integer periodNumber) {
        try {
            return recordMapper.findByPlanIdAndPeriod(planId, periodNumber);
        } catch (Exception e) {
            log.error("根据计划ID和周期号查询服务记录失败: planId={}, periodNumber={}", planId, periodNumber, e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findByVolunteerId(Long volunteerId) {
        try {
            return recordMapper.findByVolunteerId(volunteerId);
        } catch (Exception e) {
            log.error("根据志愿者ID查询服务记录失败: {}", volunteerId, e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findPendingAudit() {
        try {
            return recordMapper.findPendingAudit();
        } catch (Exception e) {
            log.error("查询待审核服务记录失败", e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findAll() {
        try {
            return recordMapper.findAll();
        } catch (Exception e) {
            log.error("查询所有服务记录失败", e);
            return null;
        }
    }

    @Override
    public List<CarePlanServiceRecord> findByAuditStatus(String auditStatus) {
        try {
            return recordMapper.findByAuditStatus(auditStatus);
        } catch (Exception e) {
            log.error("根据审核状态查询服务记录失败: {}", auditStatus, e);
            return null;
        }
    }

    // ==================== 增删改 ====================

    @Override
    @Transactional
    public boolean create(CarePlanServiceRecord record) {
        try {
            // 获取计划信息
            CarePlan plan = carePlanMapper.findById(record.getPlanId());
            if (plan == null) {
                log.warn("关爱计划不存在: {}", record.getPlanId());
                return false;
            }

            // 检查计划是否已被认领
            if (!"CLAIMED".equals(plan.getClaimStatus())) {
                log.warn("关爱计划未被认领，无法提交服务记录: {}", record.getPlanId());
                return false;
            }

            // 检查是否是认领的志愿者
            if (!plan.getAssignedVolunteerId().equals(record.getVolunteerId())) {
                log.warn("非认领志愿者无法提交服务记录: planId={}, volunteerId={}", record.getPlanId(), record.getVolunteerId());
                return false;
            }

            // 设置默认值
            if (record.getAuditStatus() == null) {
                record.setAuditStatus("PENDING");
            }
            if (record.getPeriodNumber() == null) {
                record.setPeriodNumber(plan.getCurrentPeriod() != null ? plan.getCurrentPeriod() : 1);
            }
            record.setCreatedAt(new Date());

            int result = recordMapper.insert(record);
            if (result > 0) {
                // 更新计划的已完成服务次数
                carePlanService.incrementCompletedServices(record.getPlanId());
                log.info("服务记录创建成功: planId={}, volunteerId={}", record.getPlanId(), record.getVolunteerId());
            }
            return result > 0;
        } catch (Exception e) {
            log.error("创建服务记录失败", e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean update(CarePlanServiceRecord record) {
        try {
            return recordMapper.update(record) > 0;
        } catch (Exception e) {
            log.error("更新服务记录失败: {}", record.getId(), e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        try {
            CarePlanServiceRecord record = recordMapper.findById(id);
            if (record == null) {
                return false;
            }
            // 只能删除待审核的记录
            if (!"PENDING".equals(record.getAuditStatus())) {
                log.warn("只能删除待审核的服务记录: {}", id);
                return false;
            }
            int result = recordMapper.deleteById(id);
            if (result > 0) {
                // 减少计划的已完成服务次数
                CarePlan plan = carePlanMapper.findById(record.getPlanId());
                if (plan != null && plan.getCompletedServices() != null && plan.getCompletedServices() > 0) {
                    carePlanService.updateCompletedServices(record.getPlanId(), plan.getCompletedServices() - 1);
                }
            }
            return result > 0;
        } catch (Exception e) {
            log.error("删除服务记录失败: {}", id, e);
            return false;
        }
    }

    // ==================== 审核相关 ====================

    @Override
    @Transactional
    public boolean audit(Long id, String auditStatus, Long auditBy, String auditRemark) {
        try {
            CarePlanServiceRecord record = recordMapper.findById(id);
            if (record == null) {
                log.warn("服务记录不存在: {}", id);
                return false;
            }

            // 只能审核待审核的记录
            if (!"PENDING".equals(record.getAuditStatus())) {
                log.warn("服务记录已审核: {}", id);
                return false;
            }

            int result = recordMapper.audit(id, auditStatus, auditBy, auditRemark);
            if (result > 0 && "APPROVED".equals(auditStatus)) {
                // 审核通过，更新计划的已审核通过服务次数
                carePlanService.incrementApprovedServices(record.getPlanId());
                log.info("服务记录审核通过: id={}, planId={}", id, record.getPlanId());
            }
            return result > 0;
        } catch (Exception e) {
            log.error("审核服务记录失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean approve(Long id, Long auditBy, String remark) {
        return audit(id, "APPROVED", auditBy, remark);
    }

    @Override
    @Transactional
    public boolean reject(Long id, Long auditBy, String remark) {
        return audit(id, "REJECTED", auditBy, remark);
    }

    // ==================== 统计 ====================

    @Override
    public int countByPlanId(Long planId) {
        try {
            return recordMapper.countByPlanId(planId);
        } catch (Exception e) {
            log.error("统计计划服务记录数失败: {}", planId, e);
            return 0;
        }
    }

    @Override
    public int countApprovedByPlanId(Long planId) {
        try {
            return recordMapper.countApprovedByPlanId(planId);
        } catch (Exception e) {
            log.error("统计计划已审核通过服务记录数失败: {}", planId, e);
            return 0;
        }
    }

    @Override
    public int countByVolunteerId(Long volunteerId) {
        try {
            return recordMapper.countByVolunteerId(volunteerId);
        } catch (Exception e) {
            log.error("统计志愿者服务记录数失败: {}", volunteerId, e);
            return 0;
        }
    }

    @Override
    public int countPendingAudit() {
        try {
            return recordMapper.countPendingAudit();
        } catch (Exception e) {
            log.error("统计待审核服务记录数失败", e);
            return 0;
        }
    }

    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        try {
            stats.put("total", recordMapper.countAll());
            stats.put("pending", countPendingAudit());
            stats.put("approved", recordMapper.countByAuditStatus("APPROVED"));
            stats.put("rejected", recordMapper.countByAuditStatus("REJECTED"));
        } catch (Exception e) {
            log.error("获取服务记录统计数据失败", e);
            stats.put("total", 0);
            stats.put("pending", 0);
            stats.put("approved", 0);
            stats.put("rejected", 0);
        }
        return stats;
    }

    // ==================== 业务方法 ====================

    @Override
    public boolean belongsToVolunteer(Long recordId, Long volunteerId) {
        try {
            CarePlanServiceRecord record = recordMapper.findById(recordId);
            return record != null && volunteerId.equals(record.getVolunteerId());
        } catch (Exception e) {
            log.error("检查服务记录归属失败: recordId={}, volunteerId={}", recordId, volunteerId, e);
            return false;
        }
    }

    @Override
    public boolean belongsToPlan(Long recordId, Long planId) {
        try {
            CarePlanServiceRecord record = recordMapper.findById(recordId);
            return record != null && planId.equals(record.getPlanId());
        } catch (Exception e) {
            log.error("检查服务记录归属失败: recordId={}, planId={}", recordId, planId, e);
            return false;
        }
    }

    @Override
    public List<CarePlanServiceRecord> getCurrentPeriodRecords(Long planId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            if (plan == null || plan.getCurrentPeriod() == null) {
                return null;
            }
            return recordMapper.findByPlanIdAndPeriod(planId, plan.getCurrentPeriod());
        } catch (Exception e) {
            log.error("获取当前周期服务记录失败: {}", planId, e);
            return null;
        }
    }

    @Override
    public boolean isCurrentPeriodCompleted(Long planId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            if (plan == null || plan.getCurrentPeriod() == null || plan.getServicesPerPeriod() == null) {
                return false;
            }
            int approvedCount = recordMapper.countApprovedByPlanIdAndPeriod(planId, plan.getCurrentPeriod());
            return approvedCount >= plan.getServicesPerPeriod();
        } catch (Exception e) {
            log.error("检查当前周期是否完成失败: {}", planId, e);
            return false;
        }
    }
}
