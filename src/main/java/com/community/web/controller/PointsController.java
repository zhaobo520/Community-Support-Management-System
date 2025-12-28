package com.community.web.controller;

import com.community.domain.Badge;
import com.community.domain.PointsRecord;
import com.community.domain.User;
import com.community.service.BadgeService;
import com.community.service.CertificateService;
import com.community.service.PointsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 积分控制器
 */
@Controller
@RequestMapping("/points")
public class PointsController {

    private static final Logger log = LoggerFactory.getLogger(PointsController.class);

    @Resource
    private PointsService pointsService;

    @Resource
    private BadgeService badgeService;

    @Resource
    private CertificateService certificateService;

    /**
     * 积分排行榜页面
     */
    @GetMapping("/ranking")
    public String ranking(@RequestParam(required = false, defaultValue = "TOTAL") String type,
                         Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // 获取排行榜前50名
        List<Map<String, Object>> rankingList = pointsService.getRankingList(50, type);
        model.addAttribute("rankingList", rankingList);
        model.addAttribute("type", type);
        
        // 如果是志愿者，获取自己的排名和积分
        if ("VOLUNTEER".equals(currentUser.getRoleType())) {
            Integer myPoints = 0;
            Integer myRanking = 0;
            
            try {
                // 注意：这里获取的总是总积分和总排名，如果需要按时间筛选的个人数据，需要Service支持
                // 目前为了简单，仅展示总数据，或者可以根据type分别获取
                // 暂且展示总数据
                myPoints = pointsService.getUserTotalPoints(currentUser.getId());
                myRanking = pointsService.getUserRanking(currentUser.getId());
            } catch (Exception e) {
                log.warn("获取个人积分信息失败", e);
            }
            
            model.addAttribute("myPoints", myPoints);
            model.addAttribute("myRanking", myRanking);
        }
        
        model.addAttribute("currentUser", currentUser);

        return "points/ranking";
    }

    /**
     * 个人积分记录页面
     */
    @GetMapping("/my")
    public String myPoints(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        // 获取积分记录
        List<PointsRecord> records = pointsService.getUserPointsRecords(currentUser.getId());
        Integer totalPoints = pointsService.getUserTotalPoints(currentUser.getId());
        Integer ranking = pointsService.getUserRanking(currentUser.getId());

        // 获取勋章
        List<Badge> earnedBadges = badgeService.getUserBadges(currentUser.getId());
        List<Badge> lockedBadges = badgeService.getUserUnlockedBadges(currentUser.getId());

        model.addAttribute("records", records);
        model.addAttribute("totalPoints", totalPoints);
        model.addAttribute("ranking", ranking);
        model.addAttribute("earnedBadges", earnedBadges);
        model.addAttribute("lockedBadges", lockedBadges);
        model.addAttribute("currentUser", currentUser);
        
        return "points/my_points";
    }

    /**
     * 获取积分排行榜（AJAX）
     */
    @GetMapping("/api/ranking")
    @ResponseBody
    public Map<String, Object> getRanking(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        
        if (currentUser == null) {
            result.put("success", false);
            result.put("message", "未登录");
            return result;
        }

        List<Map<String, Object>> rankingList = pointsService.getRankingList(50);
        result.put("success", true);
        result.put("data", rankingList);
        
        return result;
    }

    /**
     * 下载勋章证书
     */
    @GetMapping("/certificate/{badgeId}")
    public void downloadCertificate(@PathVariable Long badgeId, 
                                      HttpSession session, 
                                      HttpServletResponse response) {
        try {
            User currentUser = (User) session.getAttribute("CURRENT_USER");
            if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
                return;
            }

            // 验证用户是否拥有该勋章
            List<Badge> earnedBadges = badgeService.getUserBadges(currentUser.getId());
            Badge targetBadge = null;
            Date earnedAt = null;
            
            for (Badge badge : earnedBadges) {
                if (badge.getId().equals(badgeId)) {
                    targetBadge = badge;
                    earnedAt = badge.getEarnedAt();
                    break;
                }
            }
            
            if (targetBadge == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "未获得该勋章");
                return;
            }

            // 设置响应头
            String fileName = currentUser.getFullName() + "_" + targetBadge.getBadgeName() + "_荣誉证书.pdf";
            fileName = URLEncoder.encode(fileName, "UTF-8");
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            
            // 生成证书PDF
            OutputStream outputStream = response.getOutputStream();
            certificateService.generateBadgeCertificate(currentUser, targetBadge, earnedAt, outputStream);
            
            outputStream.flush();
            outputStream.close();
            
            log.info("用户{}下载了勋章{}的证书", currentUser.getUsername(), targetBadge.getBadgeName());
            
        } catch (Exception e) {
            log.error("生成证书失败", e);
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "证书生成失败");
            } catch (Exception ex) {
                log.error("发送错误响应失败", ex);
            }
        }
    }
}
