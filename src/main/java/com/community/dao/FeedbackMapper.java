package com.community.dao;

import com.community.domain.Feedback;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Feedback Mapper
 */
public interface FeedbackMapper {

    /**
     * Find feedbacks by family user ID
     */
    List<Feedback> findByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * Find feedback by ID
     */
    Feedback findById(@Param("id") Long id);

    /**
     * Insert feedback
     */
    int insert(Feedback feedback);

    /**
     * Update feedback
     */
    int update(Feedback feedback);

    /**
     * Delete feedback
     */
    int deleteById(@Param("id") Long id);

    /**
     * Count by family user ID
     */
    int countByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * Count pending feedbacks
     */
    int countPendingByFamilyUserId(@Param("familyUserId") Long familyUserId);

    /**
     * Find all feedbacks (for admin)
     */
    List<Feedback> findAll();

    /**
     * Count all feedbacks
     */
    int countAll();

    /**
     * Count feedbacks by status
     */
    int countByStatus(@Param("status") String status);
}
