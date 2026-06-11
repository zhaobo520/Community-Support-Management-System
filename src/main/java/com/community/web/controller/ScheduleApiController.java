package com.community.web.controller;

import com.community.service.VolunteerScheduleService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Read-only schedule API used by floating widgets for live polling.
 */
@Controller
public class ScheduleApiController {

    @Resource
    private VolunteerScheduleService scheduleService;

    @GetMapping("/api/schedule/summary")
    @ResponseBody
    public Map<String, Map<String, Object>> summary() {
        return scheduleService.getAvailableVolunteersSummary();
    }
}
