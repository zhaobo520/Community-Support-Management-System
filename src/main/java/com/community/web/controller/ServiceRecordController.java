package com.community.web.controller;

import com.community.domain.TaskInfo;
import com.community.domain.User;
import com.community.service.TaskService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 服务历史记录控制器
 */
@Controller
@RequestMapping("/volunteer/history")
public class ServiceRecordController {

    @Resource
    private TaskService taskService;

    /**
     * 服务历史列表页面
     */
    @GetMapping("/list")
    public String list(@RequestParam(required = false) String month,
                       Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("CURRENT_USER");
        if (currentUser == null || !"VOLUNTEER".equals(currentUser.getRoleType())) {
            return "redirect:/user/login";
        }

        String startDate = null;
        String endDate = null;

        // 处理月份筛选
        if (month != null && !month.isEmpty()) {
            startDate = month + "-01 00:00:00";
            
            // 计算月底
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date date = sdf.parse(month + "-01");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(date);
                calendar.add(Calendar.MONTH, 1);
                calendar.add(Calendar.DATE, -1);
                endDate = sdf.format(calendar.getTime()) + " 23:59:59";
            } catch (Exception e) {
                // 忽略日期解析错误
            }
        }

        // 获取历史任务列表
        List<TaskInfo> historyTasks = taskService.findHistoryTasks(currentUser.getId(), startDate, endDate);
        
        // 统计数据
        int totalServiceCount = taskService.countServiceTimes(currentUser.getId(), startDate, endDate);
        double averageRating = taskService.getAverageRatingByVolunteer(currentUser.getId(), startDate, endDate);

        model.addAttribute("historyTasks", historyTasks);
        model.addAttribute("totalServiceCount", totalServiceCount);
        model.addAttribute("averageRating", String.format("%.1f", averageRating));
        model.addAttribute("currentMonth", month);
        model.addAttribute("currentUser", currentUser);

        return "volunteer/service_history";
    }
}
