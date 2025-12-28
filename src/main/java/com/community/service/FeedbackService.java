package com.community.service;

import com.community.domain.Feedback;

import java.util.List;

/**
 * Feedback Service Interface
 */
public interface FeedbackService {

    /**
     * Find feedbacks by family user ID
     */
    List<Feedback> findByFamilyUserId(Long familyUserId);

    /**
     * Find feedback by ID
     */
    Feedback findById(Long id);

    /**
     * Submit feedback
     */
    boolean submit(Feedback feedback);

    /**
     * Count total feedbacks
     */
    int countByFamilyUserId(Long familyUserId);

    /**
     * Count pending feedbacks
     */
    int countPendingByFamilyUserId(Long familyUserId);

    /**
     * Find all feedbacks (for admin)
     */
    List<Feedback> findAll();

    /**
     * Update feedback (for admin response)
     */
    boolean update(Feedback feedback);

    /**
     * Count all feedbacks
     */
    int countAll();

    /**
     * Count feedbacks by status
     */
    int countByStatus(String status);
}
