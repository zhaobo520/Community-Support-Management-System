package com.community.dao;

import com.community.domain.Appeal;
import java.util.List;

public interface AppealMapper {
    int insert(Appeal appeal);
    int update(Appeal appeal);
    int delete(Long id);
    Appeal selectById(Long id);
    List<Appeal> selectAll();
    List<Appeal> selectByUserId(Long userId);
    List<Appeal> selectByStatus(String status);
    List<Appeal> selectByUserRole(String userRole);
    int countByStatus(String status);
}
