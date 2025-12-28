package com.community.service;

import com.community.domain.ServiceRecord;

import java.util.List;

/**
 * Service Record Service Interface
 */
public interface ServiceRecordService {

    /**
     * Find service records by family user ID
     */
    List<ServiceRecord> findByFamilyUserId(Long familyUserId);

    /**
     * Find service record by ID
     */
    ServiceRecord findById(Long id);

    /**
     * Add feedback and rating
     */
    boolean addFeedback(Long id, String feedback, Integer rating);

    /**
     * Count by family user ID
     */
    int countByFamilyUserId(Long familyUserId);
}
