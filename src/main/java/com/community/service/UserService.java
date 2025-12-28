package com.community.service;

import com.community.domain.Permission;
import com.community.domain.Role;
import com.community.domain.User;

import java.util.List;

public interface UserService {

  /**
   * 登录校验，成功返回带角色与权限的用户对象。
   */
  User login(String username, String rawPassword);

  User findById(Long id);

  List<Role> findRoles(Long userId);

  List<Permission> findPermissions(Long userId);

  boolean updateProfile(User user);

  List<User> listAll();

  /**
   * 用户注册
   */
  boolean register(User user);

  /**
   * 根据用户名查找用户
   */
  User findByUsername(String username);

  /**
   * 根据角色类型查找用户
   */
  List<User> findByRoleType(String roleType);

  /**
   * 修改用户密码
   */
  boolean updatePassword(Long userId, String oldPassword, String newPassword);
}
