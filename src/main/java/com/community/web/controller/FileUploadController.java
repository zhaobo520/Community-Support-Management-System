package com.community.web.controller;

import com.community.common.ApiResponse;
import com.community.common.util.FileUtil;
import com.community.domain.User;
import com.community.service.SysFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 文件上传控制器 - 所有文件统一上传到数据库
 * 返回的URL格式: /file/view/{id}.{ext}
 */
@Controller
@RequestMapping("/upload")
public class FileUploadController {

    private static final Logger log = LoggerFactory.getLogger(FileUploadController.class);

    @Resource
    private SysFileService sysFileService;

    private Long getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("CURRENT_USER");
            if (user != null) return user.getId();
        }
        return null;
    }

    private String buildFileUrl(Long fileId, String originalName) {
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf('.'));
        }
        return "/file/view/" + fileId + ext;
    }

    private ApiResponse<Map<String, String>> doUpload(MultipartFile file, HttpServletRequest request) {
        try {
            if (file == null || file.isEmpty()) {
                return ApiResponse.error("请选择文件");
            }

            Long userId = getCurrentUserId(request);
            Long fileId = sysFileService.upload(file, userId);
            String fileUrl = buildFileUrl(fileId, file.getOriginalFilename());

            Map<String, String> result = new HashMap<>();
            result.put("fileId", String.valueOf(fileId));
            result.put("filename", String.valueOf(fileId));
            result.put("originalName", file.getOriginalFilename());
            result.put("url", fileUrl);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));

            log.info("文件上传成功: fileId={}, name={}", fileId, file.getOriginalFilename());
            return ApiResponse.success("上传成功", result);

        } catch (IllegalArgumentException e) {
            log.warn("文件上传参数错误: {}", e.getMessage());
            return ApiResponse.error("上传失败：" + e.getMessage());
        } catch (Exception e) {
            log.error("文件上传失败", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    @PostMapping("/avatar")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadAvatar(@RequestParam("file") MultipartFile file,
                                                          HttpServletRequest request) {
        return doUpload(file, request);
    }

    @PostMapping("/service-photo")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadServicePhoto(@RequestParam("file") MultipartFile file,
                                                                HttpServletRequest request) {
        return doUpload(file, request);
    }

    @PostMapping("/elderly-photo")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadElderlyPhoto(@RequestParam("file") MultipartFile file,
                                                                HttpServletRequest request) {
        return doUpload(file, request);
    }

    @PostMapping("/task-attachment")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadTaskAttachment(@RequestParam("file") MultipartFile file,
                                                                  HttpServletRequest request) {
        return doUpload(file, request);
    }

    @PostMapping("/demand-attachment")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadDemandAttachment(@RequestParam("file") MultipartFile file,
                                                                   HttpServletRequest request) {
        return doUpload(file, request);
    }

    @PostMapping("/execution-media")
    @ResponseBody
    public ApiResponse<Map<String, String>> uploadExecutionMedia(@RequestParam("file") MultipartFile file,
                                                                  HttpServletRequest request) {
        try {
            if (file == null || file.isEmpty()) {
                return ApiResponse.error("请选择文件");
            }

            String originalFilename = file.getOriginalFilename();
            String mediaType = "image";
            if (originalFilename != null) {
                String lower = originalFilename.toLowerCase();
                if (lower.endsWith(".mp4") || lower.endsWith(".avi") || lower.endsWith(".mov")
                    || lower.endsWith(".wmv") || lower.endsWith(".flv") || lower.endsWith(".webm")
                    || lower.endsWith(".mkv") || lower.endsWith(".m4v")) {
                    mediaType = "video";
                } else if (!FileUtil.isImage(originalFilename)) {
                    return ApiResponse.error("不支持的文件格式，请上传图片或视频");
                }
            }

            Long userId = getCurrentUserId(request);
            Long fileId = sysFileService.upload(file, userId);
            String fileUrl = buildFileUrl(fileId, originalFilename);

            Map<String, String> result = new HashMap<>();
            result.put("fileId", String.valueOf(fileId));
            result.put("filename", String.valueOf(fileId));
            result.put("originalName", originalFilename);
            result.put("url", fileUrl);
            result.put("type", mediaType);
            result.put("size", FileUtil.getReadableFileSize(file.getSize()));

            log.info("执行媒体上传成功: fileId={}, name={}, type={}", fileId, originalFilename, mediaType);
            return ApiResponse.success("上传成功", result);

        } catch (IllegalArgumentException e) {
            return ApiResponse.error("上传失败：" + e.getMessage());
        } catch (Exception e) {
            log.error("执行媒体上传失败", e);
            return ApiResponse.error("上传失败：" + e.getMessage());
        }
    }

    @PostMapping("/delete")
    @ResponseBody
    public ApiResponse<?> deleteFile(@RequestParam("filename") String filename,
                                     @RequestParam(value = "type", required = false) String type) {
        try {
            if (filename == null || filename.trim().isEmpty()) {
                return ApiResponse.error("缺少文件标识");
            }

            String raw = filename.trim();
            if (raw.startsWith("/file/view/")) {
                raw = raw.substring("/file/view/".length());
            }
            int slashIndex = raw.lastIndexOf('/');
            if (slashIndex >= 0) {
                raw = raw.substring(slashIndex + 1);
            }
            int dotIndex = raw.indexOf('.');
            if (dotIndex > 0) {
                raw = raw.substring(0, dotIndex);
            }

            Long fileId;
            try {
                fileId = Long.parseLong(raw);
            } catch (NumberFormatException e) {
                log.warn("删除文件失败，无法解析fileId: filename={}", filename);
                return ApiResponse.error("删除失败：无法识别文件ID");
            }

            boolean deleted = sysFileService.delete(fileId);
            if (deleted) {
                log.info("文件删除成功: fileId={}", fileId);
                return ApiResponse.success("删除成功");
            }
            return ApiResponse.error("删除失败");
        } catch (Exception e) {
            log.error("文件删除失败", e);
            return ApiResponse.error("删除失败：" + e.getMessage());
        }
    }
}
