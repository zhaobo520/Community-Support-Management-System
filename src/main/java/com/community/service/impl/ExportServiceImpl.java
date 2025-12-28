package com.community.service.impl;

import com.community.dto.StatisticsDTO;
import com.community.service.ExportService;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * 数据导出服务实现类
 */
@Service
public class ExportServiceImpl implements ExportService {

    @Override
    public void exportToExcel(StatisticsDTO statistics, HttpServletResponse response) throws Exception {
        // 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        
        // 创建样式
        CellStyle titleStyle = createTitleStyle(workbook);
        CellStyle headerStyle = createHeaderStyle(workbook);
        CellStyle dataStyle = createDataStyle(workbook);
        
        // 创建综合统计表
        createOverviewSheet(workbook, statistics, titleStyle, headerStyle, dataStyle);
        
        // 创建需求统计表
        createDemandSheet(workbook, statistics, titleStyle, headerStyle, dataStyle);
        
        // 创建任务统计表
        createTaskSheet(workbook, statistics, titleStyle, headerStyle, dataStyle);
        
        // 创建志愿者统计表
        createVolunteerSheet(workbook, statistics, titleStyle, headerStyle, dataStyle);
        
        // 创建关爱对象统计表
        createElderlySheet(workbook, statistics, titleStyle, headerStyle, dataStyle);
        
        // 设置响应头
        String fileName = "统计报表_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 输出到响应
        OutputStream out = response.getOutputStream();
        workbook.write(out);
        out.flush();
        out.close();
        workbook.close();
    }

    @Override
    public void exportToPdf(StatisticsDTO statistics, HttpServletResponse response) throws Exception {
        // 创建文档
        Document document = new Document(PageSize.A4);
        
        // 设置响应头
        String fileName = "统计报告_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf";
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 创建PDF写入器
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
        
        // 设置中文字体
        BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(bfChinese, 18, com.itextpdf.text.Font.BOLD);
        com.itextpdf.text.Font headerFont = new com.itextpdf.text.Font(bfChinese, 14, com.itextpdf.text.Font.BOLD);
        com.itextpdf.text.Font normalFont = new com.itextpdf.text.Font(bfChinese, 12, com.itextpdf.text.Font.NORMAL);
        
        // 添加标题
        Paragraph title = new Paragraph("社区互助平台数据统计报告", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        // 添加生成时间
        Paragraph dateTime = new Paragraph("生成时间：" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()), normalFont);
        dateTime.setSpacingAfter(20);
        document.add(dateTime);
        
        // 添加综合统计
        addOverviewSection(document, statistics, headerFont, normalFont);
        
        // 添加需求统计
        addDemandSection(document, statistics, headerFont, normalFont);
        
        // 添加任务统计
        addTaskSection(document, statistics, headerFont, normalFont);
        
        // 添加志愿者统计
        addVolunteerSection(document, statistics, headerFont, normalFont);
        
        // 添加关爱对象统计
        addElderlySection(document, statistics, headerFont, normalFont);
        
        document.close();
    }

    // ==================== Excel辅助方法 ====================
    
    /**
     * 创建标题样式
     */
    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        org.apache.poi.ss.usermodel.Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 16);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }
    
    /**
     * 创建表头样式
     */
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        org.apache.poi.ss.usermodel.Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 12);
        style.setFont(font);
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }
    
    /**
     * 创建数据样式
     */
    private CellStyle createDataStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        style.setVerticalAlignment(VerticalAlignment.CENTER);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        return style;
    }
    
    /**
     * 创建综合统计表
     */
    private void createOverviewSheet(Workbook workbook, StatisticsDTO statistics, 
                                     CellStyle titleStyle, CellStyle headerStyle, CellStyle dataStyle) {
        Sheet sheet = workbook.createSheet("综合统计");
        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 4000);
        
        int rowNum = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("综合统计数据");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
        rowNum++;
        
        // 需求统计
        createSectionRow(sheet, rowNum++, "需求统计", "", headerStyle);
        createDataRow(sheet, rowNum++, "总需求数", statistics.getTotalDemands(), dataStyle);
        createDataRow(sheet, rowNum++, "待审核", statistics.getPendingDemands(), dataStyle);
        createDataRow(sheet, rowNum++, "已通过", statistics.getApprovedDemands(), dataStyle);
        createDataRow(sheet, rowNum++, "已拒绝", statistics.getRejectedDemands(), dataStyle);
        createDataRow(sheet, rowNum++, "已匹配", statistics.getMatchedDemands(), dataStyle);
        createDataRow(sheet, rowNum++, "已关闭", statistics.getClosedDemands(), dataStyle);
        rowNum++;
        
        // 任务统计
        createSectionRow(sheet, rowNum++, "任务统计", "", headerStyle);
        createDataRow(sheet, rowNum++, "总任务数", statistics.getTotalTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "待认领", statistics.getPendingTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "已认领", statistics.getClaimedTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "进行中", statistics.getInProgressTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "已完成", statistics.getCompletedTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "已审核", statistics.getApprovedTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "已取消", statistics.getCancelledTasks(), dataStyle);
        createDataRow(sheet, rowNum++, "平均评分", String.format("%.2f", statistics.getAverageRating()), dataStyle);
        rowNum++;
        
        // 志愿者统计
        createSectionRow(sheet, rowNum++, "志愿者统计", "", headerStyle);
        createDataRow(sheet, rowNum++, "总志愿者数", statistics.getTotalVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "活跃志愿者", statistics.getActiveVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "待审核", statistics.getPendingVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "已通过", statistics.getApprovedVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "已拒绝", statistics.getRejectedVolunteers(), dataStyle);
        rowNum++;
        
        // 关爱对象统计
        createSectionRow(sheet, rowNum++, "关爱对象统计", "", headerStyle);
        createDataRow(sheet, rowNum++, "总关爱对象数", statistics.getTotalElderly(), dataStyle);
        createDataRow(sheet, rowNum++, "启用状态", statistics.getActiveElderly(), dataStyle);
        createDataRow(sheet, rowNum++, "停用状态", statistics.getInactiveElderly(), dataStyle);
    }
    
    /**
     * 创建需求统计表
     */
    private void createDemandSheet(Workbook workbook, StatisticsDTO statistics,
                                   CellStyle titleStyle, CellStyle headerStyle, CellStyle dataStyle) {
        Sheet sheet = workbook.createSheet("需求统计");
        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 4000);
        
        int rowNum = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("需求类型统计");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
        rowNum++;
        
        // 表头
        createSectionRow(sheet, rowNum++, "需求类型", "数量", headerStyle);
        
        // 数据
        Map<String, Long> demandsByType = statistics.getDemandsByType();
        if (demandsByType != null && !demandsByType.isEmpty()) {
            for (Map.Entry<String, Long> entry : demandsByType.entrySet()) {
                createDataRow(sheet, rowNum++, entry.getKey(), entry.getValue(), dataStyle);
            }
        }
    }
    
    /**
     * 创建任务统计表
     */
    private void createTaskSheet(Workbook workbook, StatisticsDTO statistics,
                                 CellStyle titleStyle, CellStyle headerStyle, CellStyle dataStyle) {
        Sheet sheet = workbook.createSheet("任务统计");
        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 4000);
        
        int rowNum = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("任务类型统计");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
        rowNum++;
        
        // 表头
        createSectionRow(sheet, rowNum++, "任务类型", "数量", headerStyle);
        
        // 数据
        Map<String, Long> tasksByType = statistics.getTasksByType();
        if (tasksByType != null && !tasksByType.isEmpty()) {
            for (Map.Entry<String, Long> entry : tasksByType.entrySet()) {
                createDataRow(sheet, rowNum++, entry.getKey(), entry.getValue(), dataStyle);
            }
        }
    }
    
    /**
     * 创建志愿者统计表
     */
    private void createVolunteerSheet(Workbook workbook, StatisticsDTO statistics,
                                      CellStyle titleStyle, CellStyle headerStyle, CellStyle dataStyle) {
        Sheet sheet = workbook.createSheet("志愿者统计");
        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 4000);
        
        int rowNum = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("志愿者详细统计");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
        rowNum++;
        
        // 数据
        createSectionRow(sheet, rowNum++, "统计项", "数值", headerStyle);
        createDataRow(sheet, rowNum++, "总志愿者数", statistics.getTotalVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "活跃志愿者", statistics.getActiveVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "待审核", statistics.getPendingVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "已通过", statistics.getApprovedVolunteers(), dataStyle);
        createDataRow(sheet, rowNum++, "已拒绝", statistics.getRejectedVolunteers(), dataStyle);
    }
    
    /**
     * 创建关爱对象统计表
     */
    private void createElderlySheet(Workbook workbook, StatisticsDTO statistics,
                                    CellStyle titleStyle, CellStyle headerStyle, CellStyle dataStyle) {
        Sheet sheet = workbook.createSheet("关爱对象统计");
        sheet.setColumnWidth(0, 6000);
        sheet.setColumnWidth(1, 4000);
        
        int rowNum = 0;
        
        // 标题
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("关爱对象护理等级统计");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 1));
        rowNum++;
        
        // 表头
        createSectionRow(sheet, rowNum++, "护理等级", "数量", headerStyle);
        
        // 数据
        Map<String, Long> elderlyByCareLevel = statistics.getElderlyByCareLevel();
        if (elderlyByCareLevel != null && !elderlyByCareLevel.isEmpty()) {
            for (Map.Entry<String, Long> entry : elderlyByCareLevel.entrySet()) {
                createDataRow(sheet, rowNum++, entry.getKey(), entry.getValue(), dataStyle);
            }
        }
    }
    
    /**
     * 创建章节行
     */
    private void createSectionRow(Sheet sheet, int rowNum, String col1, String col2, CellStyle style) {
        Row row = sheet.createRow(rowNum);
        Cell cell1 = row.createCell(0);
        cell1.setCellValue(col1);
        cell1.setCellStyle(style);
        Cell cell2 = row.createCell(1);
        cell2.setCellValue(col2);
        cell2.setCellStyle(style);
    }
    
    /**
     * 创建数据行
     */
    private void createDataRow(Sheet sheet, int rowNum, String label, Object value, CellStyle style) {
        Row row = sheet.createRow(rowNum);
        Cell labelCell = row.createCell(0);
        labelCell.setCellValue(label);
        labelCell.setCellStyle(style);
        
        Cell valueCell = row.createCell(1);
        if (value instanceof Number) {
            valueCell.setCellValue(((Number) value).doubleValue());
        } else {
            valueCell.setCellValue(value.toString());
        }
        valueCell.setCellStyle(style);
    }
    
    // ==================== PDF辅助方法 ====================
    
    private void addOverviewSection(Document document, StatisticsDTO statistics, com.itextpdf.text.Font headerFont, com.itextpdf.text.Font normalFont) throws com.itextpdf.text.DocumentException {
        Paragraph header = new Paragraph("一、综合统计", headerFont);
        header.setSpacingAfter(10);
        document.add(header);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        addTableCell(table, "总需求数", statistics.getTotalDemands() + "", normalFont);
        addTableCell(table, "总任务数", statistics.getTotalTasks() + "", normalFont);
        addTableCell(table, "总志愿者数", statistics.getTotalVolunteers() + "", normalFont);
        addTableCell(table, "总关爱对象数", statistics.getTotalElderly() + "", normalFont);
        addTableCell(table, "完成服务数", statistics.getApprovedTasks() + "", normalFont);
        addTableCell(table, "平均评分", String.format("%.2f", statistics.getAverageRating()), normalFont);
        
        document.add(table);
    }
    
    private void addDemandSection(Document document, StatisticsDTO statistics, com.itextpdf.text.Font headerFont, com.itextpdf.text.Font normalFont) throws com.itextpdf.text.DocumentException {
        Paragraph header = new Paragraph("二、需求统计", headerFont);
        header.setSpacingAfter(10);
        document.add(header);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        addTableCell(table, "待审核", statistics.getPendingDemands() + "", normalFont);
        addTableCell(table, "已通过", statistics.getApprovedDemands() + "", normalFont);
        addTableCell(table, "已拒绝", statistics.getRejectedDemands() + "", normalFont);
        addTableCell(table, "已匹配", statistics.getMatchedDemands() + "", normalFont);
        addTableCell(table, "已关闭", statistics.getClosedDemands() + "", normalFont);
        
        document.add(table);
    }
    
    private void addTaskSection(Document document, StatisticsDTO statistics, com.itextpdf.text.Font headerFont, com.itextpdf.text.Font normalFont) throws com.itextpdf.text.DocumentException {
        Paragraph header = new Paragraph("三、任务统计", headerFont);
        header.setSpacingAfter(10);
        document.add(header);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        addTableCell(table, "待认领", statistics.getPendingTasks() + "", normalFont);
        addTableCell(table, "已认领", statistics.getClaimedTasks() + "", normalFont);
        addTableCell(table, "进行中", statistics.getInProgressTasks() + "", normalFont);
        addTableCell(table, "已完成", statistics.getCompletedTasks() + "", normalFont);
        addTableCell(table, "已审核", statistics.getApprovedTasks() + "", normalFont);
        addTableCell(table, "已取消", statistics.getCancelledTasks() + "", normalFont);
        
        document.add(table);
    }
    
    private void addVolunteerSection(Document document, StatisticsDTO statistics, com.itextpdf.text.Font headerFont, com.itextpdf.text.Font normalFont) throws com.itextpdf.text.DocumentException {
        Paragraph header = new Paragraph("四、志愿者统计", headerFont);
        header.setSpacingAfter(10);
        document.add(header);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        addTableCell(table, "活跃志愿者", statistics.getActiveVolunteers() + "", normalFont);
        addTableCell(table, "待审核", statistics.getPendingVolunteers() + "", normalFont);
        addTableCell(table, "已通过", statistics.getApprovedVolunteers() + "", normalFont);
        addTableCell(table, "已拒绝", statistics.getRejectedVolunteers() + "", normalFont);
        
        document.add(table);
    }
    
    private void addElderlySection(Document document, StatisticsDTO statistics, com.itextpdf.text.Font headerFont, com.itextpdf.text.Font normalFont) throws com.itextpdf.text.DocumentException {
        Paragraph header = new Paragraph("五、关爱对象统计", headerFont);
        header.setSpacingAfter(10);
        document.add(header);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        addTableCell(table, "启用状态", statistics.getActiveElderly() + "", normalFont);
        addTableCell(table, "停用状态", statistics.getInactiveElderly() + "", normalFont);
        
        document.add(table);
        
        // 护理等级分布
        Paragraph levelHeader = new Paragraph("护理等级分布：", normalFont);
        levelHeader.setSpacingBefore(10);
        levelHeader.setSpacingAfter(5);
        document.add(levelHeader);
        
        PdfPTable levelTable = new PdfPTable(2);
        levelTable.setWidthPercentage(100);
        
        Map<String, Long> elderlyByCareLevel = statistics.getElderlyByCareLevel();
        if (elderlyByCareLevel != null && !elderlyByCareLevel.isEmpty()) {
            for (Map.Entry<String, Long> entry : elderlyByCareLevel.entrySet()) {
                addTableCell(levelTable, entry.getKey(), entry.getValue() + "", normalFont);
            }
        }
        
        document.add(levelTable);
    }
    
    private void addTableCell(PdfPTable table, String label, String value, com.itextpdf.text.Font font) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, font));
        labelCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        labelCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        labelCell.setPadding(5);
        table.addCell(labelCell);
        
        PdfPCell valueCell = new PdfPCell(new Phrase(value, font));
        valueCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        valueCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        valueCell.setPadding(5);
        table.addCell(valueCell);
    }
}
