package com.community.service.impl;

import com.community.domain.Badge;
import com.community.domain.User;
import com.community.service.CertificateService;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.springframework.stereotype.Service;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 证书生成服务实现
 */
@Service
public class CertificateServiceImpl implements CertificateService {

    private static final float PAGE_WIDTH = 842f;  // A4横向宽度
    private static final float PAGE_HEIGHT = 595f; // A4横向高度
    
    @Override
    public void generateBadgeCertificate(User user, Badge badge, Date earnedAt, OutputStream outputStream) throws Exception {
        // 创建文档（A4横向，边距更小以适应单页）
        Document document = new Document(PageSize.A4.rotate(), 40, 40, 35, 35);
        PdfWriter writer = PdfWriter.getInstance(document, outputStream);
        
        document.open();
        
        // 创建中文字体 - 红色氛围主题
        BaseFont bfChinese = BaseFont.createFont("STSong-Light", "UniGB-UCS2-H", BaseFont.NOT_EMBEDDED);
        com.itextpdf.text.Font titleFont = new com.itextpdf.text.Font(bfChinese, 28, com.itextpdf.text.Font.BOLD, new BaseColor(178, 34, 34));  // 红色
        com.itextpdf.text.Font nameFont = new com.itextpdf.text.Font(bfChinese, 20, com.itextpdf.text.Font.BOLD, new BaseColor(139, 0, 0));    // 深红
        com.itextpdf.text.Font contentFont = new com.itextpdf.text.Font(bfChinese, 13, com.itextpdf.text.Font.NORMAL, new BaseColor(60, 60, 60));  // 深灰
        com.itextpdf.text.Font badgeFont = new com.itextpdf.text.Font(bfChinese, 18, com.itextpdf.text.Font.BOLD, new BaseColor(220, 20, 60));  // 猩红
        com.itextpdf.text.Font dateFont = new com.itextpdf.text.Font(bfChinese, 11, com.itextpdf.text.Font.NORMAL, new BaseColor(100, 100, 100));
        
        // 绘制证书边框
        drawCertificateBorder(writer);
        
        // 添加顶部装饰线
        addTopDecoration(document);
        
        // 添加标题
        Paragraph title = new Paragraph("荣 誉 证 书", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(6f);
        document.add(title);
        
        // 添加英文副标题
        com.itextpdf.text.Font subtitleFont = new com.itextpdf.text.Font(bfChinese, 12, com.itextpdf.text.Font.ITALIC, new BaseColor(178, 34, 34));
        Paragraph subtitle = new Paragraph("Certificate of Achievement", subtitleFont);
        subtitle.setAlignment(Element.ALIGN_CENTER);
        subtitle.setSpacingAfter(15f);
        document.add(subtitle);
        
        // 添加证书编号
        String certNumber = generateCertificateNumber(user.getId(), badge.getId(), earnedAt);
        Paragraph certNo = new Paragraph("证书编号：" + certNumber, dateFont);
        certNo.setAlignment(Element.ALIGN_CENTER);
        certNo.setSpacingAfter(18f);
        document.add(certNo);
        
        // 添加志愿者姓名
        Paragraph name = new Paragraph(user.getFullName() + " 志愿者：", nameFont);
        name.setAlignment(Element.ALIGN_CENTER);
        name.setSpacingAfter(15f);
        document.add(name);
        
        // 添加表彰内容（精简）
        String content = "在社区志愿服务活动中表现优异，积极参与各项公益活动，热心帮助社区关爱对象，\n" +
                         "展现了良好的奉献精神和服务意识。经系统认证，特授予以下荣誉：";
        Paragraph contentPara = new Paragraph(content, contentFont);
        contentPara.setAlignment(Element.ALIGN_CENTER);
        contentPara.setSpacingAfter(18f);
        contentPara.setLeading(18f);
        document.add(contentPara);
        
        // 添加勋章信息（突出显示）
        Paragraph badgeInfo = new Paragraph(badge.getBadgeIcon() + " " + badge.getBadgeName(), badgeFont);
        badgeInfo.setAlignment(Element.ALIGN_CENTER);
        badgeInfo.setSpacingAfter(8f);
        document.add(badgeInfo);
        
        // 添加勋章描述
        if (badge.getDescription() != null && !badge.getDescription().isEmpty()) {
            Paragraph badgeDesc = new Paragraph("（" + badge.getDescription() + "）", contentFont);
            badgeDesc.setAlignment(Element.ALIGN_CENTER);
            badgeDesc.setSpacingAfter(18f);
            document.add(badgeDesc);
        }
        
        // 添加获得日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
        Paragraph datePara = new Paragraph("获得日期：" + sdf.format(earnedAt), contentFont);
        datePara.setAlignment(Element.ALIGN_CENTER);
        datePara.setSpacingAfter(20f);
        document.add(datePara);
        
        // 添加底部签名和印章
        addBottomSignature(document, contentFont, dateFont);
        
        // 添加底部装饰
        addBottomDecoration(document, dateFont);
        
        // 绘制右下角印章
        drawSeal(writer, bfChinese);
        
        document.close();
    }
    
    /**
     * 绘制证书边框 - 红色主题，新颖设计
     */
    private void drawCertificateBorder(PdfWriter writer) {
        PdfContentByte canvas = writer.getDirectContent();
        
        // 外边框（深红色，较粗）
        canvas.setColorStroke(new BaseColor(178, 34, 34));  // 火砖红
        canvas.setLineWidth(4f);
        canvas.rectangle(28, 28, PAGE_WIDTH - 56, PAGE_HEIGHT - 56);
        canvas.stroke();
        
        // 内边框（猩红色）
        canvas.setColorStroke(new BaseColor(220, 20, 60));  // 猩红
        canvas.setLineWidth(1.5f);
        canvas.rectangle(36, 36, PAGE_WIDTH - 72, PAGE_HEIGHT - 72);
        canvas.stroke();
        
        // 最内层装饰线（浅红）
        canvas.setColorStroke(new BaseColor(255, 99, 71));  // 番茄红
        canvas.setLineWidth(0.8f);
        canvas.rectangle(32, 32, PAGE_WIDTH - 64, PAGE_HEIGHT - 64);
        canvas.stroke();
        
        // 添加四角装饰（红色花纹）
        drawCornerDecorations(canvas);
    }
    
    /**
     * 绘制四角装饰 - 新颖设计
     */
    private void drawCornerDecorations(PdfContentByte canvas) {
        canvas.setColorStroke(new BaseColor(220, 20, 60));
        canvas.setLineWidth(2f);
        
        float cornerSize = 25f;
        float margin = 28f;
        
        // 左上角
        canvas.moveTo(margin, margin + cornerSize);
        canvas.lineTo(margin, margin);
        canvas.lineTo(margin + cornerSize, margin);
        canvas.stroke();
        
        // 右上角
        canvas.moveTo(PAGE_WIDTH - margin - cornerSize, margin);
        canvas.lineTo(PAGE_WIDTH - margin, margin);
        canvas.lineTo(PAGE_WIDTH - margin, margin + cornerSize);
        canvas.stroke();
        
        // 左下角
        canvas.moveTo(margin, PAGE_HEIGHT - margin - cornerSize);
        canvas.lineTo(margin, PAGE_HEIGHT - margin);
        canvas.lineTo(margin + cornerSize, PAGE_HEIGHT - margin);
        canvas.stroke();
        
        // 右下角
        canvas.moveTo(PAGE_WIDTH - margin - cornerSize, PAGE_HEIGHT - margin);
        canvas.lineTo(PAGE_WIDTH - margin, PAGE_HEIGHT - margin);
        canvas.lineTo(PAGE_WIDTH - margin, PAGE_HEIGHT - margin - cornerSize);
        canvas.stroke();
    }
    
    /**
     * 添加顶部装饰线
     */
    private void addTopDecoration(Document document) throws DocumentException {
        // 添加较小的装饰性空白
        Paragraph space = new Paragraph(" ");
        space.setSpacingAfter(5f);
        document.add(space);
    }
    
    /**
     * 添加底部签名 - 紧凑布局
     */
    private void addBottomSignature(Document document, com.itextpdf.text.Font contentFont, com.itextpdf.text.Font dateFont) throws DocumentException {
        // 创建表格用于签名布局
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(85);
        table.setSpacingBefore(12f);
        
        // 左侧：颁发单位
        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        leftCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        Paragraph issuer = new Paragraph("\n颁发单位：社区志愿服务平台", contentFont);
        issuer.setAlignment(Element.ALIGN_LEFT);
        leftCell.addElement(issuer);
        
        // 右侧：颁发日期
        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        rightCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
        Paragraph issueDate = new Paragraph("\n颁发日期：" + sdf.format(new Date()), contentFont);
        issueDate.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(issueDate);
        
        table.addCell(leftCell);
        table.addCell(rightCell);
        
        document.add(table);
    }
    
    /**
     * 添加底部装饰 - 紧凑设计
     */
    private void addBottomDecoration(Document document, com.itextpdf.text.Font dateFont) throws DocumentException {
        Paragraph footer = new Paragraph("此证书仅用于表彰志愿者的优秀表现，特此证明。", dateFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(8f);
        document.add(footer);
    }
    
    /**
     * 绘制印章 - 在颁发日期上方
     */
    private void drawSeal(PdfWriter writer, BaseFont bfChinese) {
        PdfContentByte canvas = writer.getDirectContent();
        
        // 印章位置（颁发日期上方）
        float sealX = PAGE_WIDTH - 180f;  // 距离右边180pt
        float sealY = 140f;                // 距离底部140pt（颁发日期上方）
        float sealRadius = 55f;            // 印章半径（变大）
        
        // 设置半透明效果
        PdfGState gState = new PdfGState();
        gState.setFillOpacity(0.6f);      // 60%不透明度
        gState.setStrokeOpacity(0.6f);
        canvas.setGState(gState);
        
        // 绘制外圆（深红色，线条更粗）
        canvas.setColorStroke(new BaseColor(178, 34, 34));
        canvas.setColorFill(new BaseColor(220, 20, 60, 30));  // 浅红色填充
        canvas.setLineWidth(3.5f);  // 线条变粗
        canvas.circle(sealX, sealY, sealRadius);
        canvas.fillStroke();
        
        // 绘制内圆
        canvas.setColorStroke(new BaseColor(178, 34, 34));
        canvas.setLineWidth(2f);    // 线条变粗
        canvas.circle(sealX, sealY, sealRadius - 6f);
        canvas.stroke();
        
        // 恢复不透明度
        gState.setFillOpacity(0.8f);
        canvas.setGState(gState);
        
        // 绘制印章文字 - 圆形排列
        canvas.beginText();
        canvas.setColorFill(new BaseColor(178, 34, 34));
        
        String sealText = "社区志愿服务平台";
        int textLength = sealText.length();
        float fontSize = 13f;                  // 字体变大
        float textRadius = sealRadius - 18f;  // 文字距离圆心的半径
        
        // 计算每个字的角度间隔
        double angleStep = 2 * Math.PI / textLength;
        double startAngle = Math.PI / 2 + angleStep / 2;  // 从顶部开始
        
        for (int i = 0; i < textLength; i++) {
            String ch = String.valueOf(sealText.charAt(i));
            double angle = startAngle - i * angleStep;
            
            float x = (float) (sealX + textRadius * Math.cos(angle));
            float y = (float) (sealY + textRadius * Math.sin(angle));
            
            canvas.setFontAndSize(bfChinese, fontSize);
            canvas.setTextMatrix((float) Math.cos(angle - Math.PI / 2),
                                 (float) Math.sin(angle - Math.PI / 2),
                                 (float) -Math.sin(angle - Math.PI / 2),
                                 (float) Math.cos(angle - Math.PI / 2),
                                 x, y);
            canvas.showText(ch);
        }
        
        canvas.endText();
        
        // 绘制中央五角星（变大）
        drawStar(canvas, sealX, sealY, 15f);
        
        // 恢复完全不透明
        gState.setFillOpacity(1.0f);
        gState.setStrokeOpacity(1.0f);
        canvas.setGState(gState);
    }
    
    /**
     * 绘制五角星
     */
    private void drawStar(PdfContentByte canvas, float cx, float cy, float radius) {
        canvas.setColorFill(new BaseColor(178, 34, 34));
        
        double[] angles = new double[10];
        for (int i = 0; i < 10; i++) {
            angles[i] = Math.PI / 2 + i * Math.PI / 5;
            if (i % 2 == 1) {
                angles[i] = Math.PI / 2 + i * Math.PI / 5;
            }
        }
        
        float outerRadius = radius;
        float innerRadius = radius * 0.382f;  // 黄金比例
        
        canvas.moveTo(cx + outerRadius * (float) Math.cos(angles[0]),
                      cy + outerRadius * (float) Math.sin(angles[0]));
        
        for (int i = 0; i < 5; i++) {
            // 外顶点
            canvas.lineTo(cx + outerRadius * (float) Math.cos(Math.PI / 2 + i * 2 * Math.PI / 5),
                          cy + outerRadius * (float) Math.sin(Math.PI / 2 + i * 2 * Math.PI / 5));
            // 内顶点
            canvas.lineTo(cx + innerRadius * (float) Math.cos(Math.PI / 2 + (i + 0.5) * 2 * Math.PI / 5),
                          cy + innerRadius * (float) Math.sin(Math.PI / 2 + (i + 0.5) * 2 * Math.PI / 5));
        }
        
        canvas.closePathFillStroke();
    }
    
    @Override
    public String generateCertificateNumber(Long userId, Long badgeId, Date earnedAt) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String dateStr = sdf.format(earnedAt);
        return String.format("CERT-%s-%04d-%04d", dateStr, userId % 10000, badgeId % 10000);
    }
}
