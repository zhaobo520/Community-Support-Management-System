package com.community.common.util;

/**
 * Validation Utility
 */
public class ValidationUtil {

    private ValidationUtil() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Validate required field
     */
    public static void required(Object value, String fieldName) {
        if (value == null) {
            throw new IllegalArgumentException(fieldName + " is required");
        }
        if (value instanceof String && StringUtil.isEmpty((String) value)) {
            throw new IllegalArgumentException(fieldName + " cannot be empty");
        }
    }

    /**
     * Validate string length
     */
    public static void validateLength(String value, String fieldName, int min, int max) {
        if (value == null) {
            return;
        }
        int length = value.length();
        if (length < min || length > max) {
            throw new IllegalArgumentException(
                fieldName + " length must be between " + min + " and " + max
            );
        }
    }

    /**
     * Validate email
     */
    public static void validateEmail(String email) {
        if (StringUtil.isNotEmpty(email) && !StringUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format");
        }
    }

    /**
     * Validate phone
     */
    public static void validatePhone(String phone) {
        if (StringUtil.isNotEmpty(phone) && !StringUtil.isValidPhone(phone)) {
            throw new IllegalArgumentException("Invalid phone format");
        }
    }

    /**
     * Validate ID card
     */
    public static void validateIdCard(String idCard) {
        if (StringUtil.isNotEmpty(idCard) && !StringUtil.isValidIdCard(idCard)) {
            throw new IllegalArgumentException("Invalid ID card format");
        }
    }

    /**
     * Validate range
     */
    public static void validateRange(Number value, String fieldName, Number min, Number max) {
        if (value == null) {
            return;
        }
        double doubleValue = value.doubleValue();
        double minValue = min.doubleValue();
        double maxValue = max.doubleValue();
        
        if (doubleValue < minValue || doubleValue > maxValue) {
            throw new IllegalArgumentException(
                fieldName + " must be between " + min + " and " + max
            );
        }
    }

    /**
     * Validate positive number
     */
    public static void validatePositive(Number value, String fieldName) {
        if (value != null && value.doubleValue() <= 0) {
            throw new IllegalArgumentException(fieldName + " must be positive");
        }
    }
}
