package com.community.dao;

import com.community.domain.Permission;
import com.community.domain.Role;
import com.community.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

  User findByUsername(@Param("username") String username);

  User findByPhone(@Param("phone") String phone);

  User findById(@Param("id") Long id);

  List<Role> findRolesByUserId(@Param("userId") Long userId);

  List<Permission> findPermissionsByUserId(@Param("userId") Long userId);

  List<User> findAll();

  int insert(User user);

  int update(User user);

  int delete(@Param("id") Long id);

  /**
   * 统计总用户数
   */
  Long countTotal();

  /**
   * 按角色类型统计用户数
   */
  Long countByRoleType(@Param("roleType") String roleType);

  /**
   * 根据角色类型查找用户
   */
  List<User> findByRoleType(@Param("roleType") String roleType);
}
