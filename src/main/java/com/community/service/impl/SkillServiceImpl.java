package com.community.service.impl;

import com.community.dao.SkillMapper;
import com.community.dao.VolunteerSkillMapper;
import com.community.domain.Skill;
import com.community.domain.VolunteerSkill;
import com.community.service.SkillService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 技能服务实现
 */
@Service
public class SkillServiceImpl implements SkillService {
    
    private static final Logger log = LoggerFactory.getLogger(SkillServiceImpl.class);
    
    @Resource
    private SkillMapper skillMapper;
    
    @Resource
    private VolunteerSkillMapper volunteerSkillMapper;
    
    @Override
    public List<Skill> getAllActiveSkills() {
        return skillMapper.findAllActive();
    }
    
    @Override
    public Map<String, List<Skill>> getSkillsGroupedByCategory() {
        List<Skill> allSkills = skillMapper.findAllActive();
        return allSkills.stream()
                .collect(Collectors.groupingBy(
                    Skill::getCategory,
                    LinkedHashMap::new,
                    Collectors.toList()
                ));
    }
    
    @Override
    public List<VolunteerSkill> getVolunteerSkills(Long userId) {
        return volunteerSkillMapper.findByUserId(userId);
    }
    
    @Override
    @Transactional
    public boolean addVolunteerSkill(Long userId, Long skillId, String proficiencyLevel) {
        try {
            VolunteerSkill vs = new VolunteerSkill();
            vs.setUserId(userId);
            vs.setSkillId(skillId);
            vs.setProficiencyLevel(proficiencyLevel != null ? proficiencyLevel : "BEGINNER");
            vs.setYearsExperience(0);
            
            int rows = volunteerSkillMapper.insert(vs);
            log.info("志愿者{}添加技能{}，熟练度{}", userId, skillId, proficiencyLevel);
            return rows > 0;
        } catch (Exception e) {
            log.error("添加技能失败", e);
            return false;
        }
    }
    
    @Override
    @Transactional
    public boolean removeVolunteerSkill(Long userId, Long skillId) {
        try {
            int rows = volunteerSkillMapper.delete(userId, skillId);
            log.info("志愿者{}删除技能{}", userId, skillId);
            return rows > 0;
        } catch (Exception e) {
            log.error("删除技能失败", e);
            return false;
        }
    }
    
    @Override
    @Transactional
    public boolean updateVolunteerSkills(Long userId, List<Long> skillIds) {
        try {
            // 先删除所有技能
            volunteerSkillMapper.deleteByUserId(userId);
            
            // 批量添加新技能
            if (skillIds != null && !skillIds.isEmpty()) {
                List<VolunteerSkill> skills = new ArrayList<>();
                for (Long skillId : skillIds) {
                    VolunteerSkill vs = new VolunteerSkill();
                    vs.setUserId(userId);
                    vs.setSkillId(skillId);
                    vs.setProficiencyLevel("BEGINNER");
                    vs.setYearsExperience(0);
                    skills.add(vs);
                }
                volunteerSkillMapper.batchInsert(skills);
            }
            
            log.info("志愿者{}更新技能，共{}项", userId, skillIds != null ? skillIds.size() : 0);
            return true;
        } catch (Exception e) {
            log.error("更新技能失败", e);
            return false;
        }
    }
    
    @Override
    public List<VolunteerSkill> getVolunteersBySkill(Long skillId) {
        return volunteerSkillMapper.findBySkillId(skillId);
    }
}
