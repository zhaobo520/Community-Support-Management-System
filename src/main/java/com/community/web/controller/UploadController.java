package com.community.web.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

/**
 * 处理上传文件的访问
 * 使用固定的外部目录存储上传文件，避免重新部署时丢失
 */
@Controller
@RequestMapping("/uploads")
public class UploadController {

    private static final Logger log = LoggerFactory.getLogger(UploadController.class);

    // 使用固定的外部目录存储上传文件
    public static final String UPLOAD_BASE_PATH = "C:/uploads/community/";

    @PostConstruct
    public void init() {
        // 确保上传目录存在
        File uploadDir = new File(UPLOAD_BASE_PATH);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
            log.info("Created upload directory: {}", UPLOAD_BASE_PATH);
        }
        log.info("Upload base path: {}", UPLOAD_BASE_PATH);
    }

    /**
     * 访问服务记录照片
     * URL: /uploads/service_records/{planId}/{filename}
     * 文件实际路径: C:/uploads/community/uploads/service_records/{planId}/{filename}
     */
    @GetMapping("/service_records/{planId}/{filename:.+}")
    public ResponseEntity<Resource> getServiceRecordPhoto(
            @PathVariable Long planId,
            @PathVariable String filename) {

        try {
            // 文件保存时使用了 UPLOAD_DIR = "uploads/service_records/"
            // 所以实际路径需要加上 "uploads/" 前缀
            String filePath = UPLOAD_BASE_PATH + "uploads/service_records/" + planId + "/" + filename;
            File file = new File(filePath);

            log.debug("Requesting file: {}", filePath);

            if (!file.exists()) {
                log.warn("File not found: {}", filePath);
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            // 确定内容类型
            String contentType = Files.probeContentType(file.toPath());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CACHE_CONTROL, "max-age=3600")
                    .body(resource);

        } catch (IOException e) {
            log.error("Error reading file", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * 通用上传文件访问
     * 根据路径类型选择正确的基础目录：
     * - service_records: 文件在 C:/uploads/community/uploads/service_records/
     * - 其他(avatars, elderly-photos等): 文件在 C:/uploads/community/xxx/
     */
    @GetMapping("/**")
    public ResponseEntity<Resource> getUploadedFile(javax.servlet.http.HttpServletRequest request) {
        try {
            String requestPath = request.getRequestURI();
            String contextPath = request.getContextPath();
            String relativePath = requestPath.substring(contextPath.length() + "/uploads/".length());

            // 根据路径类型决定实际文件位置
            // service_records 是通过 VolunteerCarePlanController 保存的，路径包含 uploads/ 前缀
            // 其他文件是通过 FileUploadController 保存的，直接在 UPLOAD_BASE_PATH 下
            String filePath;
            if (relativePath.startsWith("service_records/")) {
                // 服务记录照片：C:/uploads/community/uploads/service_records/...
                filePath = UPLOAD_BASE_PATH + "uploads/" + relativePath;
            } else {
                // 其他文件（avatars, elderly-photos, demand-attachments等）：C:/uploads/community/xxx/...
                filePath = UPLOAD_BASE_PATH + relativePath;
            }

            File file = new File(filePath);

            log.debug("Requesting file: {}", filePath);

            if (!file.exists()) {
                log.warn("File not found: {}", filePath);
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String contentType = Files.probeContentType(file.toPath());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CACHE_CONTROL, "max-age=3600")
                    .body(resource);

        } catch (IOException e) {
            log.error("Error reading file", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
