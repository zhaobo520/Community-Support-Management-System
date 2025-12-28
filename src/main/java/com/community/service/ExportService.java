package com.community.service;

import com.community.dto.StatisticsDTO;

import javax.servlet.http.HttpServletResponse;

/**
 * 数据导出服务接口
 */
public interface ExportService {

    /**
     * 导出Excel格式的统计报表
     *
     * @param statistics 统计数据
     * @param response   HTTP响应
     */
    void exportToExcel(StatisticsDTO statistics, HttpServletResponse response) throws Exception;

    /**
     * 导出PDF格式的统计报表
     *
     * @param statistics 统计数据
     * @param response   HTTP响应
     */
    void exportToPdf(StatisticsDTO statistics, HttpServletResponse response) throws Exception;
}
