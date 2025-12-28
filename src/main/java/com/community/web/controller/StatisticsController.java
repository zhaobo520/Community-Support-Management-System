package com.community.web.controller;

import com.community.domain.User;
import com.community.dto.DateRangeDTO;
import com.community.dto.StatisticsDTO;
import com.community.service.ExportService;
import com.community.service.StatisticsService;
import com.community.util.DateRangeUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * 数据统计控制器
 */
@Controller
@RequestMapping("/admin/statistics")
public class StatisticsController {

    private static final Logger log = LoggerFactory.getLogger(StatisticsController.class);

    @Resource
    private StatisticsService statisticsService;

    @Resource
    private ExportService exportService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 统计看板首页
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        try {
            // 获取综合统计数据
            StatisticsDTO statistics = statisticsService.getOverallStatistics();
            model.addAttribute("statistics", statistics);
            
            // 将statistics转为JSON字符串传给前端
            String statisticsJson = objectMapper.writeValueAsString(statistics);
            model.addAttribute("statisticsJson", statisticsJson);
            model.addAttribute("currentUser", currentUser);

            return "statistics/dashboard";
        } catch (Exception e) {
            log.error("Failed to load statistics dashboard", e);
            model.addAttribute("error", "加载统计数据失败");
            // 传空对象避免JS错误
            model.addAttribute("statisticsJson", "{}");
            return "statistics/dashboard";
        }
    }

    /**
     * 获取综合统计数据（AJAX）
     */
    @GetMapping("/data/overall")
    @ResponseBody
    public Map<String, Object> getOverallData(HttpSession session, String rangeType) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            StatisticsDTO statistics;
            
            // 根据时间范围类型获取统计数据
            if (rangeType != null && !rangeType.isEmpty() && !"ALL".equals(rangeType)) {
                DateRangeDTO dateRange = DateRangeUtil.getDateRange(rangeType);
                statistics = statisticsService.getOverallStatistics(dateRange);
            } else {
                statistics = statisticsService.getOverallStatistics();
            }
            
            result.put("success", true);
            result.put("data", statistics);
            return result;
        } catch (Exception e) {
            log.error("Failed to get overall statistics", e);
            result.put("success", false);
            result.put("message", "获取统计数据失败");
            return result;
        }
    }

    /**
     * 获取需求统计数据（AJAX）
     */
    @GetMapping("/data/demand")
    @ResponseBody
    public Map<String, Object> getDemandData(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            StatisticsDTO statistics = statisticsService.getDemandStatistics();
            result.put("success", true);
            result.put("data", statistics);
            return result;
        } catch (Exception e) {
            log.error("Failed to get demand statistics", e);
            result.put("success", false);
            result.put("message", "获取需求统计失败");
            return result;
        }
    }

    /**
     * 获取任务统计数据（AJAX）
     */
    @GetMapping("/data/task")
    @ResponseBody
    public Map<String, Object> getTaskData(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            StatisticsDTO statistics = statisticsService.getTaskStatistics();
            result.put("success", true);
            result.put("data", statistics);
            return result;
        } catch (Exception e) {
            log.error("Failed to get task statistics", e);
            result.put("success", false);
            result.put("message", "获取任务统计失败");
            return result;
        }
    }

    /**
     * 获取志愿者统计数据（AJAX）
     */
    @GetMapping("/data/volunteer")
    @ResponseBody
    public Map<String, Object> getVolunteerData(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            StatisticsDTO statistics = statisticsService.getVolunteerStatistics();
            result.put("success", true);
            result.put("data", statistics);
            return result;
        } catch (Exception e) {
            log.error("Failed to get volunteer statistics", e);
            result.put("success", false);
            result.put("message", "获取志愿者统计失败");
            return result;
        }
    }

    /**
     * 获取关爱对象统计数据（AJAX）
     */
    @GetMapping("/data/elderly")
    @ResponseBody
    public Map<String, Object> getElderlyData(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User currentUser = (User) session.getAttribute("CURRENT_USER");

        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            result.put("success", false);
            result.put("message", "无权限");
            return result;
        }

        try {
            StatisticsDTO statistics = statisticsService.getElderlyStatistics();
            result.put("success", true);
            result.put("data", statistics);
            return result;
        } catch (Exception e) {
            log.error("Failed to get elderly statistics", e);
            result.put("success", false);
            result.put("message", "获取关爱对象统计失败");
            return result;
        }
    }

    /**
     * 导出Excel格式的统计报表
     */
    @GetMapping("/export/excel")
    public void exportExcel(HttpSession session, HttpServletResponse response) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            log.warn("Unauthorized access to export Excel");
            return;
        }

        try {
            StatisticsDTO statistics = statisticsService.getOverallStatistics();
            exportService.exportToExcel(statistics, response);
            log.info("Excel report exported successfully by user: {}", currentUser.getUsername());
        } catch (Exception e) {
            log.error("Failed to export Excel", e);
        }
    }

    /**
     * 导出PDF格式的统计报表
     */
    @GetMapping("/export/pdf")
    public void exportPdf(HttpSession session, HttpServletResponse response) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"STAFF".equals(currentUser.getRoleType())) {
            log.warn("Unauthorized access to export PDF");
            return;
        }

        try {
            StatisticsDTO statistics = statisticsService.getOverallStatistics();
            exportService.exportToPdf(statistics, response);
            log.info("PDF report exported successfully by user: {}", currentUser.getUsername());
        } catch (Exception e) {
            log.error("Failed to export PDF", e);
        }
    }
}
