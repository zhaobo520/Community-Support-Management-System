package com.community.service;

import com.community.domain.SysFile;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件存储服务接口
 */
public interface SysFileService {

    /**
     * 上传文件到数据库，返回文件ID
     */
    Long upload(MultipartFile file, Long uploadBy);

    /**
     * 根据ID获取文件（含二进制数据）
     */
    SysFile findById(Long id);

    /**
     * 删除文件
     */
    boolean delete(Long id);
}
