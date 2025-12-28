package com.community.common.constant;

/**
 * Message Constants
 */
public class MessageConstants {

    /**
     * Success Messages
     */
    public static final String SUCCESS = "操作成功";
    public static final String SAVE_SUCCESS = "保存成功";
    public static final String UPDATE_SUCCESS = "更新成功";
    public static final String DELETE_SUCCESS = "删除成功";
    public static final String SUBMIT_SUCCESS = "提交成功";
    public static final String LOGIN_SUCCESS = "登录成功";
    public static final String REGISTER_SUCCESS = "注册成功";

    /**
     * Error Messages
     */
    public static final String ERROR = "操作失败";
    public static final String SAVE_ERROR = "保存失败";
    public static final String UPDATE_ERROR = "更新失败";
    public static final String DELETE_ERROR = "删除失败";
    public static final String SUBMIT_ERROR = "提交失败";

    /**
     * Validation Messages
     */
    public static final String PARAM_ERROR = "参数错误";
    public static final String PARAM_REQUIRED = "必填参数缺失";
    public static final String PARAM_INVALID = "参数格式不正确";

    /**
     * Auth Messages
     */
    public static final String LOGIN_ERROR = "用户名或密码错误";
    public static final String USER_NOT_FOUND = "用户不存在";
    public static final String USER_DISABLED = "用户已被禁用";
    public static final String UNAUTHORIZED = "未授权访问";
    public static final String PERMISSION_DENIED = "权限不足";

    /**
     * Data Messages
     */
    public static final String DATA_NOT_FOUND = "数据不存在";
    public static final String DATA_EXISTS = "数据已存在";
    public static final String USERNAME_EXISTS = "用户名已存在";
    public static final String PHONE_EXISTS = "手机号已存在";

    private MessageConstants() {
        throw new IllegalStateException("Constant class");
    }
}
