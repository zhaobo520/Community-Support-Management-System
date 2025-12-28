package com.community.service.impl;

import com.community.dao.FeedbackMapper;
import com.community.domain.Feedback;
import com.community.service.FeedbackService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Feedback Service Implementation
 */
@Service("feedbackService")
public class FeedbackServiceImpl implements FeedbackService {

    private static final Logger log = LoggerFactory.getLogger(FeedbackServiceImpl.class);

    @Resource
    private FeedbackMapper feedbackMapper;

    @Override
    public List<Feedback> findByFamilyUserId(Long familyUserId) {
        try {
            return feedbackMapper.findByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Find feedbacks by family user ID failed: {}", familyUserId, e);
            return null;
        }
    }

    @Override
    public Feedback findById(Long id) {
        try {
            return feedbackMapper.findById(id);
        } catch (Exception e) {
            log.error("Find feedback by ID failed: {}", id, e);
            return null;
        }
    }

    @Override
    public boolean submit(Feedback feedback) {
        try {
            if (feedback.getStatus() == null) {
                feedback.setStatus("PENDING");
            }
            return feedbackMapper.insert(feedback) > 0;
        } catch (Exception e) {
            log.error("Submit feedback failed", e);
            return false;
        }
    }

    @Override
    public int countByFamilyUserId(Long familyUserId) {
        try {
            return feedbackMapper.countByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Count feedbacks failed: {}", familyUserId, e);
            return 0;
        }
    }

    @Override
    public int countPendingByFamilyUserId(Long familyUserId) {
        try {
            return feedbackMapper.countPendingByFamilyUserId(familyUserId);
        } catch (Exception e) {
            log.error("Count pending feedbacks failed: {}", familyUserId, e);
            return 0;
        }
    }

    @Override
    public List<Feedback> findAll() {
        try {
            return feedbackMapper.findAll();
        } catch (Exception e) {
            log.error("Find all feedbacks failed", e);
            return null;
        }
    }

    @Override
    public boolean update(Feedback feedback) {
        try {
            return feedbackMapper.update(feedback) > 0;
        } catch (Exception e) {
            log.error("Update feedback failed: {}", feedback.getId(), e);
            return false;
        }
    }

    @Override
    public int countAll() {
        try {
            return feedbackMapper.countAll();
        } catch (Exception e) {
            log.error("Count all feedbacks failed", e);
            return 0;
        }
    }

    @Override
    public int countByStatus(String status) {
        try {
            return feedbackMapper.countByStatus(status);
        } catch (Exception e) {
            log.error("Count feedbacks by status failed: {}", status, e);
            return 0;
        }
    }
}
