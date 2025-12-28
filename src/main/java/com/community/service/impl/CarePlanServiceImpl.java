package com.community.service.impl;

import com.community.dao.CarePlanMapper;
import com.community.domain.CarePlan;
import com.community.service.CarePlanService;
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
 * 关爱计划服务实现
 */
@Service("carePlanService")
public class CarePlanServiceImpl implements CarePlanService {

    private static final Logger log = LoggerFactory.getLogger(CarePlanServiceImpl.class);

    @Resource
    private CarePlanMapper carePlanMapper;

    // ==================== 基础查询 ====================

    @Override
    public CarePlan findById(Long id) {
        try {
            return carePlanMapper.findById(id);
        } catch (Exception e) {
            log.error("根据ID查询关爱计划失败: {}", id, e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findByFamilyUserId(Long familyUserId) {
        try {
            return carePlanMapper.findByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("根据家属ID查询关爱计划失败: {}", familyUserId, e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findAll() {
        try {
            return carePlanMapper.findAll();
        } catch (Exception e) {
            log.error("查询所有关爱计划失败", e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findByStatus(String status) {
        try {
            return carePlanMapper.findByStatus(status);
        } catch (Exception e) {
            log.error("根据状态查询关爱计划失败: {}", status, e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findByAuditStatus(String auditStatus) {
        try {
            return carePlanMapper.findByAuditStatus(auditStatus);
        } catch (Exception e) {
            log.error("根据审核状态查询关爱计划失败: {}", auditStatus, e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findPendingAudit() {
        try {
            return carePlanMapper.findPendingAudit();
        } catch (Exception e) {
            log.error("查询待审核关爱计划失败", e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findClaimable() {
        try {
            return carePlanMapper.findClaimable();
        } catch (Exception e) {
            log.error("查询可认领关爱计划失败", e);
            return null;
        }
    }

    @Override
    public List<CarePlan> findByVolunteerId(Long volunteerId) {
        try {
            return carePlanMapper.findByVolunteerId(volunteerId);
        } catch (Exception e) {
            log.error("根据志愿者ID查询关爱计划失败: {}", volunteerId, e);
            return null;
        }
    }

    // ==================== 增删改 ====================

    @Override
    @Transactional
    public boolean create(CarePlan plan) {
        try {
            // 设置默认值
            // 新创建的计划状态为DRAFT（草稿），审核通过后才变为ACTIVE
            if (plan.getStatus() == null) {
                plan.setStatus("DRAFT");
            }
            if (plan.getAuditStatus() == null) {
                plan.setAuditStatus("PENDING");
            }
            if (plan.getClaimStatus() == null) {
                plan.setClaimStatus("UNCLAIMED");
            }
            if (plan.getCurrentPeriod() == null) {
                plan.setCurrentPeriod(1);
            }
            if (plan.getCompletedServices() == null) {
                plan.setCompletedServices(0);
            }
            if (plan.getApprovedServices() == null) {
                plan.setApprovedServices(0);
            }
            // 计算总服务次数
            if (plan.getTotalPeriods() != null && plan.getServicesPerPeriod() != null) {
                plan.setTotalServices(plan.getTotalPeriods() * plan.getServicesPerPeriod());
            }
            plan.setCreatedAt(new Date());
            return carePlanMapper.insert(plan) > 0;
        } catch (Exception e) {
            log.error("创建关爱计划失败", e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean update(CarePlan plan) {
        try {
            // 重新计算总服务次数
            if (plan.getTotalPeriods() != null && plan.getServicesPerPeriod() != null) {
                plan.setTotalServices(plan.getTotalPeriods() * plan.getServicesPerPeriod());
            }
            return carePlanMapper.update(plan) > 0;
        } catch (Exception e) {
            log.error("更新关爱计划失败: {}", plan.getId(), e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        try {
            return carePlanMapper.deleteById(id) > 0;
        } catch (Exception e) {
            log.error("删除关爱计划失败: {}", id, e);
            return false;
        }
    }

    // ==================== 审核相关 ====================

    @Override
    @Transactional
    public boolean audit(Long id, String auditStatus, Long auditBy, String auditRemark) {
        try {
            return carePlanMapper.audit(id, auditStatus, auditBy, auditRemark) > 0;
        } catch (Exception e) {
            log.error("审核关爱计划失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean approve(Long id, Long auditBy, String remark) {
        try {
            // 审核通过：只更新审核状态，计划状态保持DRAFT
            // 等志愿者接单后，状态才变为ACTIVE
            boolean auditResult = audit(id, "APPROVED", auditBy, remark);
            return auditResult;
        } catch (Exception e) {
            log.error("审核通过关爱计划失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean reject(Long id, Long auditBy, String remark) {
        return audit(id, "REJECTED", auditBy, remark);
    }

    // ==================== 认领相关 ====================

    @Override
    @Transactional
    public boolean claim(Long id, Long volunteerId) {
        try {
            // 检查计划是否可以被认领
            CarePlan plan = carePlanMapper.findById(id);
            if (plan == null) {
                log.warn("关爱计划不存在: {}", id);
                return false;
            }
            if (!"APPROVED".equals(plan.getAuditStatus())) {
                log.warn("关爱计划未审核通过，无法认领: {}", id);
                return false;
            }
            if (!"UNCLAIMED".equals(plan.getClaimStatus())) {
                log.warn("关爱计划已被认领: {}", id);
                return false;
            }
            // 认领计划
            int result = carePlanMapper.claim(id, volunteerId);
            if (result > 0) {
                // 认领成功后，将计划状态改为ACTIVE（进行中）
                carePlanMapper.updateStatus(id, "ACTIVE");
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("认领关爱计划失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean unclaim(Long id, Long volunteerId) {
        try {
            CarePlan plan = carePlanMapper.findById(id);
            if (plan == null) {
                return false;
            }
            // 只有认领者本人可以取消认领
            if (!volunteerId.equals(plan.getAssignedVolunteerId())) {
                log.warn("非认领者无法取消认领: planId={}, volunteerId={}", id, volunteerId);
                return false;
            }
            // 如果已经有服务记录，不允许取消认领
            if (plan.getCompletedServices() != null && plan.getCompletedServices() > 0) {
                log.warn("已有服务记录，无法取消认领: {}", id);
                return false;
            }
            CarePlan updatePlan = new CarePlan();
            updatePlan.setId(id);
            updatePlan.setClaimStatus("UNCLAIMED");
            updatePlan.setAssignedVolunteerId(null);
            updatePlan.setClaimedTime(null);
            return carePlanMapper.update(updatePlan) > 0;
        } catch (Exception e) {
            log.error("取消认领关爱计划失败: {}", id, e);
            return false;
        }
    }

    // ==================== 状态更新 ====================

    @Override
    @Transactional
    public boolean updateStatus(Long id, String status) {
        try {
            return carePlanMapper.updateStatus(id, status) > 0;
        } catch (Exception e) {
            log.error("更新关爱计划状态失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean updateCompletedServices(Long id, Integer completedServices) {
        try {
            int result = carePlanMapper.updateCompletedServices(id, completedServices);
            if (result > 0) {
                checkAndUpdateCompletionStatus(id);
            }
            return result > 0;
        } catch (Exception e) {
            log.error("更新已完成服务次数失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean updateApprovedServices(Long id, Integer approvedServices) {
        try {
            int result = carePlanMapper.updateApprovedServices(id, approvedServices);
            if (result > 0) {
                checkAndUpdateCompletionStatus(id);
            }
            return result > 0;
        } catch (Exception e) {
            log.error("更新已审核通过服务次数失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean incrementCompletedServices(Long id) {
        try {
            CarePlan plan = carePlanMapper.findById(id);
            if (plan == null) {
                return false;
            }
            int newCount = (plan.getCompletedServices() == null ? 0 : plan.getCompletedServices()) + 1;
            return updateCompletedServices(id, newCount);
        } catch (Exception e) {
            log.error("增加已完成服务次数失败: {}", id, e);
            return false;
        }
    }

    @Override
    @Transactional
    public boolean incrementApprovedServices(Long id) {
        try {
            CarePlan plan = carePlanMapper.findById(id);
            if (plan == null) {
                return false;
            }
            int newCount = (plan.getApprovedServices() == null ? 0 : plan.getApprovedServices()) + 1;
            return updateApprovedServices(id, newCount);
        } catch (Exception e) {
            log.error("增加已审核通过服务次数失败: {}", id, e);
            return false;
        }
    }

    // ==================== 统计 ====================

    @Override
    public int countByFamilyUserId(Long familyUserId) {
        try {
            return carePlanMapper.countByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("统计家属关爱计划数量失败: {}", familyUserId, e);
            return 0;
        }
    }

    @Override
    public int countActiveByFamilyUserId(Long familyUserId) {
        try {
            return carePlanMapper.countActiveByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("统计家属进行中关爱计划数量失败: {}", familyUserId, e);
            return 0;
        }
    }

    @Override
    public int countAll() {
        try {
            return carePlanMapper.countAll();
        } catch (Exception e) {
            log.error("统计所有关爱计划数量失败", e);
            return 0;
        }
    }

    @Override
    public int countByStatus(String status) {
        try {
            return carePlanMapper.countByStatus(status);
        } catch (Exception e) {
            log.error("根据状态统计关爱计划数量失败: {}", status, e);
            return 0;
        }
    }

    @Override
    public int countByAuditStatus(String auditStatus) {
        try {
            return carePlanMapper.countByAuditStatus(auditStatus);
        } catch (Exception e) {
            log.error("根据审核状态统计关爱计划数量失败: {}", auditStatus, e);
            return 0;
        }
    }

    @Override
    public int countPendingAudit() {
        try {
            return carePlanMapper.countPendingAudit();
        } catch (Exception e) {
            log.error("统计待审核关爱计划数量失败", e);
            return 0;
        }
    }

    @Override
    public int countClaimable() {
        try {
            return carePlanMapper.countClaimable();
        } catch (Exception e) {
            log.error("统计可认领关爱计划数量失败", e);
            return 0;
        }
    }

    @Override
    public int countByVolunteerId(Long volunteerId) {
        try {
            return carePlanMapper.countByVolunteerId(volunteerId);
        } catch (Exception e) {
            log.error("统计志愿者关爱计划数量失败: {}", volunteerId, e);
            return 0;
        }
    }

    @Override
    public int countActiveByVolunteerId(Long volunteerId) {
        try {
            return carePlanMapper.countActiveByVolunteerId(volunteerId);
        } catch (Exception e) {
            log.error("统计志愿者进行中关爱计划数量失败: {}", volunteerId, e);
            return 0;
        }
    }

    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        try {
            stats.put("total", countAll());
            stats.put("active", countByStatus("ACTIVE"));
            stats.put("completed", countByStatus("COMPLETED"));
            stats.put("cancelled", countByStatus("CANCELLED"));
            stats.put("pendingAudit", countPendingAudit());
            stats.put("claimable", countClaimable());
        } catch (Exception e) {
            log.error("获取统计数据失败", e);
            stats.put("total", 0);
            stats.put("active", 0);
            stats.put("completed", 0);
            stats.put("cancelled", 0);
            stats.put("pendingAudit", 0);
            stats.put("claimable", 0);
        }
        return stats;
    }

    // ==================== 业务方法 ====================

    @Override
    public boolean belongsToFamily(Long planId, Long familyUserId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            return plan != null && familyUserId.equals(plan.getFamilyUserId());
        } catch (Exception e) {
            log.error("检查计划归属失败: planId={}, familyUserId={}", planId, familyUserId, e);
            return false;
        }
    }

    @Override
    public boolean belongsToVolunteer(Long planId, Long volunteerId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            return plan != null && volunteerId.equals(plan.getAssignedVolunteerId());
        } catch (Exception e) {
            log.error("检查计划归属失败: planId={}, volunteerId={}", planId, volunteerId, e);
            return false;
        }
    }

    @Override
    public boolean canBeClaimed(Long planId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            if (plan == null) {
                return false;
            }
            // 审核通过、未被认领、状态为DRAFT的计划可以被认领
            return "APPROVED".equals(plan.getAuditStatus())
                    && "UNCLAIMED".equals(plan.getClaimStatus())
                    && ("DRAFT".equals(plan.getStatus()) || "ACTIVE".equals(plan.getStatus()));
        } catch (Exception e) {
            log.error("检查计划是否可认领失败: {}", planId, e);
            return false;
        }
    }

    @Override
    public boolean isCompleted(Long planId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            if (plan == null) {
                return false;
            }
            return "COMPLETED".equals(plan.getStatus());
        } catch (Exception e) {
            log.error("检查计划是否完成失败: ", planId, e);
            return false;
        }
    }

    @Override
    @Transactional
    public void checkAndUpdateCompletionStatus(Long planId) {
        try {
            CarePlan plan = carePlanMapper.findById(planId);
            if (plan == null || plan.getTotalServices() == null) {
                return;
            }
            // 当审核通过的服务次数达到总次数时，标记计划为完成
            int approvedServices = plan.getApprovedServices() == null ? 0 : plan.getApprovedServices();
            if (approvedServices >= plan.getTotalServices() && !"COMPLETED".equals(plan.getStatus())) {
                carePlanMapper.updateStatus(planId, "COMPLETED");
                log.info("关爱计划已自动标记为完成: {}", planId);
            }
        } catch (Exception e) {
            log.error("检查并更新计划完成状态失败: {}", planId, e);
        }
    }
}
