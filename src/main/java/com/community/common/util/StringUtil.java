package com.community.common.util;

import java.util.regex.Pattern;

/**
 * String Utility
 */
public class StringUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^1[3-9]\\d{9}$");
    private static final Pattern ID_CARD_PATTERN = Pattern.compile("^\\d{17}[\\dXx]$");

    private StringUtil() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Check if string is empty
     */
    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * Check if string is not empty
     */
    public static boolean isNotEmpty(String str) {
        return !isEmpty(str);
    }

    /**
     * Check if email is valid
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }

    /**
     * Check if phone is valid
     */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) {
            return false;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }

    /**
     * Check if ID card is valid
     */
    public static boolean isValidIdCard(String idCard) {
        if (isEmpty(idCard)) {
            return false;
        }
        return ID_CARD_PATTERN.matcher(idCard).matches();
    }

    /**
     * Mask phone number (keep first 3 and last 4 digits)
     */
    public static String maskPhone(String phone) {
        if (isEmpty(phone) || phone.length() != 11) {
            return phone;
        }
        return phone.substring(0, 3) + "****" + phone.substring(7);
    }

    /**
     * Mask email (keep first 2 chars before @)
     */
    public static String maskEmail(String email) {
        if (isEmpty(email) || !email.contains("@")) {
            return email;
        }
        int atIndex = email.indexOf("@");
        if (atIndex <= 2) {
            return "*****" + email.substring(atIndex);
        }
        return email.substring(0, 2) + "*****" + email.substring(atIndex);
    }

    /**
     * Truncate string
     */
    public static String truncate(String str, int maxLength) {
        if (isEmpty(str) || str.length() <= maxLength) {
            return str;
        }
        return str.substring(0, maxLength) + "...";
    }

    /**
     * Remove HTML tags
     */
    public static String removeHtmlTags(String html) {
        if (isEmpty(html)) {
            return html;
        }
        return html.replaceAll("<[^>]*>", "");
    }

    /**
     * Escape HTML
     */
    public static String escapeHtml(String html) {
        if (isEmpty(html)) {
            return html;
        }
        return html.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;");
    }
}
