package com.community.service;

import com.community.domain.Badge;
import com.community.domain.User;

import java.io.OutputStream;
import java.util.Date;

/**
 * 证书生成服务接口
 */
public interface CertificateService {
    
    /**
     * 生成勋章荣誉证书PDF
     * 
     * @param user 用户信息
     * @param badge 勋章信息
     * @param earnedAt 获得时间
     * @param outputStream 输出流
     * @throws Exception 生成异常
     */
    void generateBadgeCertificate(User user, Badge badge, Date earnedAt, OutputStream outputStream) throws Exception;
    
    /**
     * 生成证书编号
     * 
     * @param userId 用户ID
     * @param badgeId 勋章ID
     * @param earnedAt 获得时间
     * @return 证书编号
     */
    String generateCertificateNumber(Long userId, Long badgeId, Date earnedAt);
}
