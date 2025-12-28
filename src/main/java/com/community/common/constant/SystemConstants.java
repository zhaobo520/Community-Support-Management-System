package com.community.common.constant;

/**
 * System Constants
 */
public class SystemConstants {

    /**
     * Session Keys
     */
    public static final String SESSION_USER = "CURRENT_USER";
    public static final String SESSION_CODE = "VERIFY_CODE";

    /**
     * Role Types
     */
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_STAFF = "STAFF";
    public static final String ROLE_VOLUNTEER = "VOLUNTEER";
    public static final String ROLE_FAMILY = "FAMILY";

    /**
     * User Status
     */
    public static final Integer STATUS_ACTIVE = 1;
    public static final Integer STATUS_INACTIVE = 0;

    /**
     * Page Size
     */
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;

    /**
     * Upload
     */
    public static final long MAX_UPLOAD_SIZE = 10 * 1024 * 1024; // 10MB
    public static final String UPLOAD_PATH = "/uploads/";

    /**
     * Date Format
     */
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public static final String TIME_FORMAT = "HH:mm:ss";

    /**
     * Response Codes
     */
    public static final int SUCCESS = 200;
    public static final int ERROR = 500;
    public static final int UNAUTHORIZED = 401;
    public static final int FORBIDDEN = 403;
    public static final int NOT_FOUND = 404;

    private SystemConstants() {
        throw new IllegalStateException("Constant class");
    }
}
