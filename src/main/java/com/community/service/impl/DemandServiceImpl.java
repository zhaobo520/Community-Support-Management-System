package com.community.service.impl;

import com.community.dao.DemandMapper;
import com.community.domain.Demand;
import com.community.service.DemandService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 需求服务实现
 */
@Service
public class DemandServiceImpl implements DemandService {

    private static final Logger log = LoggerFactory.getLogger(DemandServiceImpl.class);

    @Resource
    private DemandMapper demandMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean create(Demand demand) {
        try {
            // 设置默认状态为待审核
            if (demand.getStatus() == null) {
                demand.setStatus("PENDING");
            }
            int rows = demandMapper.insert(demand);
            if (rows > 0) {
                log.info("Created demand successfully, id: {}", demand.getId());
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to create demand", e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(Demand demand) {
        try {
            int rows = demandMapper.update(demand);
            if (rows > 0) {
                log.info("Updated demand successfully, id: {}", demand.getId());
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to update demand, id: {}", demand.getId(), e);
            throw e;
        }
    }

    @Override
    public Demand findById(Long id) {
        return demandMapper.findById(id);
    }

    @Override
    public List<Demand> findAll() {
        return demandMapper.findAll();
    }

    @Override
    public List<Demand> findByFamilyUserId(Long familyUserId) {
        return demandMapper.findByFamilyUserId(familyUserId);
    }

    @Override
    public List<Demand> findPendingDemands() {
        return demandMapper.findPendingDemands();
    }

    @Override
    public List<Demand> findByStatus(String status) {
        return demandMapper.findByStatus(status);
    }

    @Override
    public List<Demand> findApprovedDemands() {
        return demandMapper.findApprovedDemands();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean approve(Long id, Long reviewerId, String reviewComment) {
        try {
            int rows = demandMapper.review(id, "APPROVED", reviewerId, reviewComment);
            if (rows > 0) {
                log.info("Approved demand, id: {}, reviewer: {}", id, reviewerId);
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to approve demand, id: {}", id, e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean reject(Long id, Long reviewerId, String reviewComment) {
        try {
            int rows = demandMapper.review(id, "REJECTED", reviewerId, reviewComment);
            if (rows > 0) {
                log.info("Rejected demand, id: {}, reviewer: {}", id, reviewerId);
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to reject demand, id: {}", id, e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean delete(Long id) {
        try {
            int rows = demandMapper.delete(id);
            if (rows > 0) {
                log.info("Deleted demand, id: {}", id);
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to delete demand, id: {}", id, e);
            throw e;
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean linkTask(Long demandId, Long taskId) {
        try {
            int rows = demandMapper.linkTask(demandId, taskId);
            if (rows > 0) {
                log.info("Linked demand {} to task {}", demandId, taskId);
                return true;
            }
            return false;
        } catch (Exception e) {
            log.error("Failed to link demand {} to task {}", demandId, taskId, e);
            throw e;
        }
    }

    @Override
    public Map<String, Object> getStatistics(Long familyUserId) {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", demandMapper.countByFamilyUserId(familyUserId));
        stats.put("pending", demandMapper.findByFamilyUserId(familyUserId).stream()
                .filter(d -> "PENDING".equals(d.getStatus())).count());
        stats.put("approved", demandMapper.findByFamilyUserId(familyUserId).stream()
                .filter(d -> "APPROVED".equals(d.getStatus())).count());
        stats.put("rejected", demandMapper.findByFamilyUserId(familyUserId).stream()
                .filter(d -> "REJECTED".equals(d.getStatus())).count());
        stats.put("matched", demandMapper.findByFamilyUserId(familyUserId).stream()
                .filter(d -> "MATCHED".equals(d.getStatus())).count());
        return stats;
    }

    @Override
    public Map<String, Object> getAdminStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", demandMapper.findAll().size());
        stats.put("pending", demandMapper.countByStatus("PENDING"));
        stats.put("approved", demandMapper.countByStatus("APPROVED"));
        stats.put("rejected", demandMapper.countByStatus("REJECTED"));
        stats.put("matched", demandMapper.countByStatus("MATCHED"));
        stats.put("closed", demandMapper.countByStatus("CLOSED"));
        return stats;
    }
}
