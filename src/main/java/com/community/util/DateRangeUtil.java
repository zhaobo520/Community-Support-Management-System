package com.community.util;

import com.community.dto.DateRangeDTO;

import java.util.Calendar;
import java.util.Date;

/**
 * 日期范围工具类
 */
public class DateRangeUtil {
    
    /**
     * 获取今日范围
     */
    public static DateRangeDTO getToday() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date startDate = cal.getTime();
        
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        Date endDate = cal.getTime();
        
        return new DateRangeDTO(startDate, endDate, "TODAY");
    }
    
    /**
     * 获取本周范围（周一到周日）
     */
    public static DateRangeDTO getThisWeek() {
        Calendar cal = Calendar.getInstance();
        
        // 设置为本周周一
        cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date startDate = cal.getTime();
        
        // 设置为本周周日
        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        Date endDate = cal.getTime();
        
        return new DateRangeDTO(startDate, endDate, "WEEK");
    }
    
    /**
     * 获取本月范围
     */
    public static DateRangeDTO getThisMonth() {
        Calendar cal = Calendar.getInstance();
        
        // 设置为本月第一天
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date startDate = cal.getTime();
        
        // 设置为本月最后一天
        cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        Date endDate = cal.getTime();
        
        return new DateRangeDTO(startDate, endDate, "MONTH");
    }
    
    /**
     * 获取本年范围
     */
    public static DateRangeDTO getThisYear() {
        Calendar cal = Calendar.getInstance();
        
        // 设置为本年第一天
        cal.set(Calendar.MONTH, Calendar.JANUARY);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date startDate = cal.getTime();
        
        // 设置为本年最后一天
        cal.set(Calendar.MONTH, Calendar.DECEMBER);
        cal.set(Calendar.DAY_OF_MONTH, 31);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);
        Date endDate = cal.getTime();
        
        return new DateRangeDTO(startDate, endDate, "YEAR");
    }
    
    /**
     * 获取全部范围（不限时间）
     */
    public static DateRangeDTO getAllTime() {
        return new DateRangeDTO(null, null, "ALL");
    }
    
    /**
     * 根据类型获取日期范围
     */
    public static DateRangeDTO getDateRange(String rangeType) {
        if (rangeType == null || "ALL".equals(rangeType)) {
            return getAllTime();
        }
        
        switch (rangeType.toUpperCase()) {
            case "TODAY":
                return getToday();
            case "WEEK":
                return getThisWeek();
            case "MONTH":
                return getThisMonth();
            case "YEAR":
                return getThisYear();
            default:
                return getAllTime();
        }
    }
}
