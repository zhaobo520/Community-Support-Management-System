package com.community.common;

import com.community.dao.VolunteerScheduleMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * Weekly schedule rollover.
 * Every Monday 00:00, delete VOLUNTEER-owned rows so the new week starts fresh.
 * ADMIN-assigned rows are kept as a recurring template; volunteers re-confirm them.
 */
@Component
public class WeeklyScheduleRolloverJob {

    private static final Logger log = LoggerFactory.getLogger(WeeklyScheduleRolloverJob.class);

    @Resource
    private VolunteerScheduleMapper scheduleMapper;

    @Scheduled(cron = "0 0 0 ? * MON")
    public void rollover() {
        int deleted = scheduleMapper.deleteVolunteerOwnedSchedules();
        log.info("Weekly rollover: deleted {} VOLUNTEER-owned schedule rows", deleted);
    }
}
