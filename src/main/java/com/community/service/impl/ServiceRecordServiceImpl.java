package com.community.service.impl;

import com.community.dao.ServiceRecordMapper;
import com.community.domain.ServiceRecord;
import com.community.service.ServiceRecordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Service Record Service Implementation
 */
@Service("serviceRecordService")
public class ServiceRecordServiceImpl implements ServiceRecordService {

    private static final Logger log = LoggerFactory.getLogger(ServiceRecordServiceImpl.class);

    @Resource
    private ServiceRecordMapper serviceRecordMapper;

    @Override
    public List<ServiceRecord> findByFamilyUserId(Long familyUserId) {
        try {
            return serviceRecordMapper.findByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Find service records by family user ID failed: {}", familyUserId, e);
            return null;
        }
    }

    @Override
    public ServiceRecord findById(Long id) {
        try {
            return serviceRecordMapper.findById(id);
        } catch (Exception e) {
            log.error("Find service record by ID failed: {}", id, e);
            return null;
        }
    }

    @Override
    public boolean addFeedback(Long id, String feedback, Integer rating) {
        try {
            ServiceRecord record = new ServiceRecord();
            record.setId(id);
            record.setFamilyFeedback(feedback);
            record.setRating(rating);
            return serviceRecordMapper.update(record) > 0;
        } catch (Exception e) {
            log.error("Add feedback failed: {}", id, e);
            return false;
        }
    }

    @Override
    public int countByFamilyUserId(Long familyUserId) {
        try {
            return serviceRecordMapper.countByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Count service records failed: {}", familyUserId, e);
            return 0;
        }
    }
}
