package com.community.web.controller;

import com.community.domain.SysFile;
import com.community.service.SysFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * 文件查看控制器 - 从数据库读取文件并返回
 * 访问方式: /file/view/{id}
 */
@Controller
@RequestMapping("/file")
public class FileViewController {

    private static final Logger log = LoggerFactory.getLogger(FileViewController.class);

    @Resource
    private SysFileService sysFileService;

    /**
     * 查看/下载文件
     * 支持两种URL格式:
     *   /file/view/123
     *   /file/view/123.jpg (带扩展名，用于前端识别文件类型)
     */
    @GetMapping("/view/{idWithExt}")
    public ResponseEntity<byte[]> viewFile(@PathVariable String idWithExt) {
        try {
            // 解析ID（去掉可能的扩展名）
            String idStr = idWithExt;
            int dotIdx = idWithExt.lastIndexOf('.');
            if (dotIdx > 0) {
                idStr = idWithExt.substring(0, dotIdx);
            }

            Long id;
            try {
                id = Long.parseLong(idStr);
            } catch (NumberFormatException e) {
                log.warn("无效的文件ID: {}", idWithExt);
                return ResponseEntity.badRequest().build();
            }

            SysFile sysFile = sysFileService.findById(id);
            if (sysFile == null || sysFile.getFileData() == null) {
                log.warn("文件不存在: id={}", id);
                return ResponseEntity.notFound().build();
            }

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(sysFile.getContentType()));
            headers.setContentLength(sysFile.getFileSize());
            // 浏览器缓存1小时
            headers.setCacheControl("max-age=3600");

            return new ResponseEntity<>(sysFile.getFileData(), headers, HttpStatus.OK);
        } catch (Exception e) {
            log.error("读取文件失败: {}", idWithExt, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
