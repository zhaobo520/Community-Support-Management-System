package com.community.service;

import com.community.domain.Appeal;
import java.util.List;

public interface AppealService {
    boolean submit(Appeal appeal);
    boolean review(Appeal appeal);
    Appeal findById(Long id);
    List<Appeal> findAll();
    List<Appeal> findByUserId(Long userId);
    List<Appeal> findByStatus(String status);
    List<Appeal> findByUserRole(String userRole);
    int countPending();
}
