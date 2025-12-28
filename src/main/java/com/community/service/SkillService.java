package com.community.service;

import com.community.domain.Skill;
import com.community.domain.VolunteerSkill;

import java.util.List;
import java.util.Map;

/**
 * 技能服务接口
 */
public interface SkillService {
    
    /**
     * 获取所有启用的技能
     */
    List<Skill> getAllActiveSkills();
    
    /**
     * 获取技能（按分类分组）
     */
    Map<String, List<Skill>> getSkillsGroupedByCategory();
    
    /**
     * 获取志愿者的技能列表
     */
    List<VolunteerSkill> getVolunteerSkills(Long userId);
    
    /**
     * 添加志愿者技能
     */
    boolean addVolunteerSkill(Long userId, Long skillId, String proficiencyLevel);
    
    /**
     * 删除志愿者技能
     */
    boolean removeVolunteerSkill(Long userId, Long skillId);
    
    /**
     * 批量更新志愿者技能
     */
    boolean updateVolunteerSkills(Long userId, List<Long> skillIds);
    
    /**
     * 获取拥有指定技能的志愿者
     */
    List<VolunteerSkill> getVolunteersBySkill(Long skillId);
}
