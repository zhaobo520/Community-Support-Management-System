package com.community.dto;

import java.util.Date;

/**
 * 时间范围DTO
 */
public class DateRangeDTO {
    
    /**
     * 开始日期
     */
    private Date startDate;
    
    /**
     * 结束日期
     */
    private Date endDate;
    
    /**
     * 快捷选择类型：TODAY, WEEK, MONTH, YEAR, CUSTOM
     */
    private String rangeType;
    
    public DateRangeDTO() {
    }
    
    public DateRangeDTO(Date startDate, Date endDate) {
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    public DateRangeDTO(Date startDate, Date endDate, String rangeType) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.rangeType = rangeType;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getRangeType() {
        return rangeType;
    }
    
    public void setRangeType(String rangeType) {
        this.rangeType = rangeType;
    }
    
    @Override
    public String toString() {
        return "DateRangeDTO{" +
                "startDate=" + startDate +
                ", endDate=" + endDate +
                ", rangeType='" + rangeType + '\'' +
                '}';
    }
}
