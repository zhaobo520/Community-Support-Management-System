package com.community.web.controller;

import com.community.common.ApiResponse;
import com.community.common.util.FileUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * File Upload Controller
 */
@Controller
@RequestMapping("/upload")
public class FileUploadController {

    private static final Logger log = LoggerFactory.getLogger(FileUploadController.class);

    // Upload directory (can be configured in properties)
    @Value("${upload.path:C:/uploads/community/}")
    private String uploadBasePath;

    /**
     * Upload avatar
     */
    @PostMapping("/avatar")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadAvatar(@RequestParam("file") MultipartFile file,
                                                          HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "avatars/";
            String filename = FileUtil.uploadImage(file, uploadDir);
            
            // Get access URL
            String contextPath = request.getContextPath();
            String fileUrl = contextPath + "/uploads/avatars/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));
            
            log.info("Avatar uploaded successfully: {}", filename);
            return ApiResponse.success("上传成功", result);
            
        } catch (Exception e) {
            log.error("Avatar upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Upload service photo
     */
    @PostMapping("/service-photo")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadServicePhoto(@RequestParam("file") MultipartFile file,
                                                                HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "service-photos/";
            String filename = FileUtil.uploadImage(file, uploadDir);
            
            String contextPath = request.getContextPath();
            String fileUrl = contextPath + "/uploads/service-photos/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));
            
            log.info("Service photo uploaded successfully: {}", filename);
            return ApiResponse.success("上传成功", result);
            
        } catch (Exception e) {
            log.error("Service photo upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Upload elderly photo
     */
    @PostMapping("/elderly-photo")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadElderlyPhoto(@RequestParam("file") MultipartFile file,
                                                                HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "elderly-photos/";
            String filename = FileUtil.uploadImage(file, uploadDir);
            
            // Return relative path without contextPath (JSP will add it)
            String fileUrl = "/uploads/elderly-photos/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));
            
            log.info("Elderly photo uploaded successfully: {}", filename);
            return ApiResponse.success("上传成功", result);
            
        } catch (Exception e) {
            log.error("Elderly photo upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Upload task attachment
     */
    @PostMapping("/task-attachment")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadTaskAttachment(@RequestParam("file") MultipartFile file,
                                                                  HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "task-attachments/";
            
            // Check if it's an image or document
            String filename;
            
            if (FileUtil.isImage(file.getOriginalFilename())) {
                filename = FileUtil.uploadImage(file, uploadDir);
            } else {
                filename = FileUtil.uploadDocument(file, uploadDir);
            }
            
            String contextPath = request.getContextPath();
            String fileUrl = contextPath + "/uploads/task-attachments/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("originalName", file.getOriginalFilename());
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));
            result.put("type", FileUtil.isImage(filename) ? "image" : "document");
            
            log.info("Task attachment uploaded successfully: {}", filename);
            return ApiResponse.success("上传成功", result);
            
        } catch (Exception e) {
            log.error("Task attachment upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Upload demand attachment
     */
    @PostMapping("/demand-attachment")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadDemandAttachment(@RequestParam("file") MultipartFile file,
                                                                   HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "demand-attachments/";
            String filename = FileUtil.uploadImage(file, uploadDir);
            
            // Get access URL
            String contextPath = request.getContextPath();
            String fileUrl = contextPath + "/uploads/demand-attachments/" + filename;
            
            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));
            
            log.info("Demand attachment uploaded successfully: {}", filename);
            return ApiResponse.success("上传成功", result);
            
        } catch (Exception e) {
            log.error("Demand attachment upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Delete uploaded file
     */
    @PostMapping("/delete")
    @ResponseBody
    public ApiResponse<?> deleteFile(@RequestParam("filename") String filename,
                                      @RequestParam("type") String type) {
        try {
            String filePath = uploadBasePath + type + "/" + filename;
            boolean deleted = FileUtil.deleteFile(filePath);

            if (deleted) {
                log.info("File deleted successfully: {}", filePath);
                return ApiResponse.success("删除成功");
            } else {
                return ApiResponse.error("删除失败");
            }

        } catch (Exception e) {
            log.error("File delete failed", e);
            return ApiResponse.error("删除失败：" + e.getMessage());
        }
    }

    /**
     * Upload execution media (photo or video) for task
     */
    @PostMapping("/execution-media")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadExecutionMedia(@RequestParam("file") MultipartFile file,
                                                                  HttpServletRequest request) {
        try {
            String uploadDir = uploadBasePath + "execution-media/";
            String originalFilename = file.getOriginalFilename();
            String filename;
            String mediaType;

            // Check if it's a video or image
            if (isVideo(originalFilename)) {
                filename = FileUtil.uploadVideo(file, uploadDir); // Use video upload for videos
                mediaType = "video";
            } else if (FileUtil.isImage(originalFilename)) {
                filename = FileUtil.uploadImage(file, uploadDir);
                mediaType = "image";
            } else {
                return ApiResponse.error("不支持的文件格式，请上传图片或视频");
            }

            String contextPath = request.getContextPath();
            String fileUrl = contextPath + "/uploads/execution-media/" + filename;

            Map<String, String> result = new HashMap<>();
            result.put("filename", filename);
            result.put("url", fileUrl);
            result.put("type", mediaType);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));

            log.info("Execution media uploaded successfully: {} ({})", filename, mediaType);
            return ApiResponse.success("上传成功", result);

        } catch (Exception e) {
            log.error("Execution media upload failed", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    /**
     * Check if file is a video
     */
    private boolean isVideo(String filename) {
        if (filename == null) return false;
        String lower = filename.toLowerCase();
        return lower.endsWith(".mp4") || lower.endsWith(".avi") || lower.endsWith(".mov")
            || lower.endsWith(".wmv") || lower.endsWith(".flv") || lower.endsWith(".webm")
            || lower.endsWith(".mkv") || lower.endsWith(".m4v");
    }
}
