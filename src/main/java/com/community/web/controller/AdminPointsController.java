package com.community.web.controller;

import com.community.domain.PointsRecord;
import com.community.domain.User;
import com.community.service.PointsService;
import com.community.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员积分管理控制器
 */
@Controller
@RequestMapping("/admin/points")
public class AdminPointsController {

    private static final Logger log = LoggerFactory.getLogger(AdminPointsController.class);

    @Resource
    private PointsService pointsService;

    @Resource
    private UserService userService;

    /**
     * 积分管理页面
     */
    @GetMapping("/manage")
    public String managePage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        // 获取所有积分记录
        List<PointsRecord> records = pointsService.getUserPointsRecords(null); // 可以扩展为获取所有记录
        model.addAttribute("records", records);
        model.addAttribute("currentUser", currentUser);

        return "admin/points_manage";
    }

    /**
     * 手动调整积分（AJAX）
     */
    @PostMapping("/adjust")
    @ResponseBody
    public Map<String, Object> adjustPoints(@RequestParam Long userId,
                                             @RequestParam Integer points,
                                             @RequestParam String reason,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            // 验证用户是否存在
            User targetUser = userService.findById(userId);
            if (targetUser == null) {
                result.put("success", false);
                result.put("message", "用户不存在");
                return result;
            }

            if (!"VOLUNTEER".equals(targetUser.getRoleType())) {
                result.put("success", false);
                result.put("message", "只能为志愿者调整积分");
                return result;
            }

            // 调整积分
            String sourceType = points > 0 ? "MANUAL_ADD" : "MANUAL_DEDUCT";
            String fullReason = "管理员操作：" + reason + "（操作人：" + currentUser.getFullName() + "）";
            
            boolean success = pointsService.addPoints(userId, points, sourceType, null, fullReason);

            if (success) {
                result.put("success", true);
                result.put("message", "积分调整成功");
                
                // 返回更新后的积分
                Integer newTotal = pointsService.getUserTotalPoints(userId);
                result.put("newTotal", newTotal);
            } else {
                result.put("success", false);
                result.put("message", "积分调整失败");
            }

        } catch (Exception e) {
            log.error("调整积分失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }

        return result;
    }

    /**
     * 查询用户积分（AJAX）
     */
    @GetMapping("/api/user/{userId}")
    @ResponseBody
    public Map<String, Object> getUserPoints(@PathVariable Long userId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            Integer totalPoints = pointsService.getUserTotalPoints(userId);
            Integer ranking = pointsService.getUserRanking(userId);
            List<PointsRecord> records = pointsService.getUserPointsRecords(userId);

            result.put("success", true);
            result.put("totalPoints", totalPoints);
            result.put("ranking", ranking);
            result.put("records", records);

        } catch (Exception e) {
            log.error("查询用户积分失败", e);
            result.put("success", false);
            result.put("message", "查询失败");
        }

        return result;
    }

    /**
     * 批量调整积分（AJAX）
     */
    @PostMapping("/batch-adjust")
    @ResponseBody
    public Map<String, Object> batchAdjustPoints(@RequestParam String userIds,
                                                   @RequestParam Integer points,
                                                   @RequestParam String reason,
                                                   HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            String[] idArray = userIds.split(",");
            int successCount = 0;
            int failCount = 0;

            for (String idStr : idArray) {
                try {
                    Long userId = Long.parseLong(idStr.trim());
                    String sourceType = points > 0 ? "MANUAL_ADD" : "MANUAL_DEDUCT";
                    String fullReason = "批量操作：" + reason + "（操作人：" + currentUser.getFullName() + "）";
                    
                    if (pointsService.addPoints(userId, points, sourceType, null, fullReason)) {
                        successCount++;
                    } else {
                        failCount++;
                    }
                } catch (Exception e) {
                    failCount++;
                    log.warn("调整用户积分失败：{}", idStr, e);
                }
            }

            result.put("success", true);
            result.put("message", String.format("成功：%d，失败：%d", successCount, failCount));
            result.put("successCount", successCount);
            result.put("failCount", failCount);

        } catch (Exception e) {
            log.error("批量调整积分失败", e);
            result.put("success", false);
            result.put("message", "系统错误：" + e.getMessage());
        }

        return result;
    }
}
