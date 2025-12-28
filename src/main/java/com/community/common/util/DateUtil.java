package com.community.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Date Utility
 */
public class DateUtil {

    private static final String DEFAULT_DATE_FORMAT = "yyyy-MM-dd";
    private static final String DEFAULT_DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    private DateUtil() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Format date to string
     */
    public static String format(Date date) {
        return format(date, DEFAULT_DATETIME_FORMAT);
    }

    /**
     * Format date to string with pattern
     */
    public static String format(Date date, String pattern) {
        if (date == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        return sdf.format(date);
    }

    /**
     * Parse string to date
     */
    public static Date parse(String dateStr) {
        return parse(dateStr, DEFAULT_DATETIME_FORMAT);
    }

    /**
     * Parse string to date with pattern
     */
    public static Date parse(String dateStr, String pattern) {
        if (dateStr == null || dateStr.isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(pattern);
            return sdf.parse(dateStr);
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format: " + dateStr, e);
        }
    }

    /**
     * Get current date string
     */
    public static String getCurrentDate() {
        return format(new Date(), DEFAULT_DATE_FORMAT);
    }

    /**
     * Get current datetime string
     */
    public static String getCurrentDateTime() {
        return format(new Date(), DEFAULT_DATETIME_FORMAT);
    }

    /**
     * Check if date1 is before date2
     */
    public static boolean isBefore(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return date1.before(date2);
    }

    /**
     * Check if date1 is after date2
     */
    public static boolean isAfter(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return false;
        }
        return date1.after(date2);
    }

    /**
     * Get days between two dates
     */
    public static long getDaysBetween(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return 0;
        }
        long diff = date2.getTime() - date1.getTime();
        return diff / (1000 * 60 * 60 * 24);
    }
}
