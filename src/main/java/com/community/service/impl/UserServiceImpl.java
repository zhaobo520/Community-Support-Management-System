package com.community.service.impl;

import com.community.dao.UserMapper;
import com.community.domain.Permission;
import com.community.domain.Role;
import com.community.domain.User;
import com.community.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import javax.annotation.Resource;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Objects;

@Service
public class UserServiceImpl implements UserService {

  private static final Logger log = LoggerFactory.getLogger(UserServiceImpl.class);

  @Resource
  private UserMapper userMapper;

  @Override
  public User login(String username, String rawPassword) {
    User user = userMapper.findByUsername(username);
    if (user == null) {
      log.warn("Login failed, user not found: {}", username);
      return null;
    }
    if (user.getStatus() != null && user.getStatus() == 0) {
      log.warn("Login blocked, user disabled: {}", username);
      return null;
    }

    String hashedInput = DigestUtils.md5DigestAsHex(rawPassword.getBytes(StandardCharsets.UTF_8));
    String stored = user.getPassword();
    boolean passwordMatch = Objects.equals(stored, hashedInput) || Objects.equals(stored, rawPassword);
    if (!passwordMatch) {
      log.warn("Login failed, password mismatch for user: {}", username);
      return null;
    }

    enrichUserAuthorities(user);
    return user;
  }

  @Override
  public User findById(Long id) {
    User user = userMapper.findById(id);
    if (user != null) {
      enrichUserAuthorities(user);
    }
    return user;
  }

  @Override
  public List<Role> findRoles(Long userId) {
    return userMapper.findRolesByUserId(userId);
  }

  @Override
  public List<Permission> findPermissions(Long userId) {
    return userMapper.findPermissionsByUserId(userId);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public boolean updateProfile(User user) {
    return userMapper.update(user) > 0;
  }

  @Override
  public List<User> listAll() {
    return userMapper.findAll();
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public boolean register(User user) {
    try {
      // 检查用户名是否已存在
      User existingUser = userMapper.findByUsername(user.getUsername());
      if (existingUser != null) {
        log.warn("Username already exists: {}", user.getUsername());
        return false;
      }

      // 检查手机号是否已存在
      if (user.getPhone() != null && !user.getPhone().isEmpty()) {
        User existingPhone = userMapper.findByPhone(user.getPhone());
        if (existingPhone != null) {
          log.warn("Phone number already exists: {}", user.getPhone());
          return false;
        }
      }

      // 对密码进行MD5加密
      String hashedPassword = DigestUtils.md5DigestAsHex(user.getPassword().getBytes(StandardCharsets.UTF_8));
      user.setPassword(hashedPassword);

      // 插入用户
      int rows = userMapper.insert(user);
      if (rows > 0) {
        log.info("User registered successfully: {}", user.getUsername());
        return true;
      }
      return false;
    } catch (Exception e) {
      log.error("Failed to register user: {}", user.getUsername(), e);
      throw e;
    }
  }

  @Override
  public User findByUsername(String username) {
    return userMapper.findByUsername(username);
  }

  @Override
  public List<User> findByRoleType(String roleType) {
    try {
      return userMapper.findByRoleType(roleType);
    } catch (Exception e) {
      log.error("Failed to find users by role type: {}", roleType, e);
      return null;
    }
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public boolean updatePassword(Long userId, String oldPassword, String newPassword) {
    try {
      User user = userMapper.findById(userId);
      if (user == null) {
        log.warn("User not found: {}", userId);
        return false;
      }

      String hashedOldPassword = DigestUtils.md5DigestAsHex(oldPassword.getBytes(StandardCharsets.UTF_8));
      String stored = user.getPassword();
      boolean passwordMatch = Objects.equals(stored, hashedOldPassword) || Objects.equals(stored, oldPassword);
      if (!passwordMatch) {
        log.warn("Old password mismatch for user: {}", userId);
        return false;
      }

      String hashedNewPassword = DigestUtils.md5DigestAsHex(newPassword.getBytes(StandardCharsets.UTF_8));
      user.setPassword(hashedNewPassword);
      int rows = userMapper.update(user);
      if (rows > 0) {
        log.info("Password updated successfully for user: {}", userId);
        return true;
      }
      return false;
    } catch (Exception e) {
      log.error("Failed to update password for user: {}", userId, e);
      return false;
    }
  }

  private void enrichUserAuthorities(User user) {
    Long userId = user.getId();
    user.setRoles(userMapper.findRolesByUserId(userId));
    user.setPermissions(userMapper.findPermissionsByUserId(userId));
  }
}
