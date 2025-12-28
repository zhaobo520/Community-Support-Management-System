package com.community.dao;

import com.community.domain.ServiceRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Service Record Mapper
 */
public interface ServiceRecordMapper {

    /**
     * Find service records by family user ID
     */
    List<ServiceRecord> findByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * Find service record by ID
     */
    ServiceRecord findById(@Param("id") Long id);

    /**
     * Insert service record
     */
    int insert(ServiceRecord record);

    /**
     * Update service record
     */
    int update(ServiceRecord record);

    /**
     * Delete service record
     */
    int deleteById(@Param("id") Long id);

    /**
     * Count by family user ID
     */
    int countByFamilyUserId(@Param("familyUserId") Long familyUserId);
}
