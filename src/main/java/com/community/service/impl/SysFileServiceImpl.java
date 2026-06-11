package com.community.service.impl;

import com.community.dao.SysFileMapper;
import com.community.domain.SysFile;
import com.community.service.SysFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;

/**
 * 文件存储服务实现 - 将文件存入数据库BLOB
 */
@Service("sysFileService")
public class SysFileServiceImpl implements SysFileService {

    private static final Logger log = LoggerFactory.getLogger(SysFileServiceImpl.class);

    /** 允许的图片类型 */
    private static final String[] ALLOWED_IMAGE_TYPES = {
        "image/jpeg", "image/png", "image/gif", "image/bmp", "image/webp"
    };

    /** 允许的视频类型 */
    private static final String[] ALLOWED_VIDEO_TYPES = {
        "video/mp4", "video/avi", "video/quicktime", "video/x-ms-wmv",
        "video/x-flv", "video/webm", "video/x-matroska"
    };

    /** 最大文件大小: 10MB */
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    @Resource
    private SysFileMapper sysFileMapper;

    @Override
    public Long upload(MultipartFile file, Long uploadBy) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("文件大小不能超过10MB");
        }

        String contentType = file.getContentType();
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        // 验证文件类型（图片或视频或通用文档）
        boolean allowed = false;
        for (String type : ALLOWED_IMAGE_TYPES) {
            if (type.equals(contentType)) { allowed = true; break; }
        }
        if (!allowed) {
            for (String type : ALLOWED_VIDEO_TYPES) {
                if (type.equals(contentType)) { allowed = true; break; }
            }
        }
        if (!allowed) {
            // 也允许常见文档类型
            if (contentType.startsWith("application/pdf") ||
                contentType.startsWith("application/msword") ||
                contentType.startsWith("application/vnd.") ||
                contentType.startsWith("text/")) {
                allowed = true;
            }
        }
        if (!allowed) {
            throw new IllegalArgumentException("不支持的文件类型: " + contentType);
        }

        try {
            SysFile sysFile = new SysFile();
            sysFile.setOriginalName(file.getOriginalFilename());
            sysFile.setContentType(contentType);
            sysFile.setFileSize(file.getSize());
            sysFile.setFileData(file.getBytes());
            sysFile.setUploadBy(uploadBy);

            sysFileMapper.insert(sysFile);
            log.info("文件上传成功: id={}, name={}, size={}", sysFile.getId(), sysFile.getOriginalName(), sysFile.getFileSize());
            return sysFile.getId();
        } catch (IOException e) {
            log.error("文件上传失败", e);
            throw new RuntimeException("文件上传失败: " + e.getMessage(), e);
        }
    }

    @Override
    public SysFile findById(Long id) {
        if (id == null) return null;
        return sysFileMapper.findById(id);
    }

    @Override
    public boolean delete(Long id) {
        if (id == null) return false;
        return sysFileMapper.deleteById(id) > 0;
    }
}
