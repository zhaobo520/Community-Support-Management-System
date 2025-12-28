package com.community.dao;

import com.community.domain.VolunteerSkill;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 志愿者技能Mapper接口
 */
public interface VolunteerSkillMapper {
    
    /**
     * 查询志愿者的所有技能
     */
    List<VolunteerSkill> findByUserId(@Param("userId") Long userId);
    
    /**
     * 查询拥有某技能的志愿者
     */
    List<VolunteerSkill> findBySkillId(@Param("skillId") Long skillId);
    
    /**
     * 添加技能
     */
    int insert(VolunteerSkill volunteerSkill);
    
    /**
     * 删除技能
     */
    int delete(@Param("userId") Long userId, @Param("skillId") Long skillId);
    
    /**
     * 更新熟练度
     */
    int updateProficiency(VolunteerSkill volunteerSkill);
    
    /**
     * 批量添加技能
     */
    int batchInsert(@Param("skills") List<VolunteerSkill> skills);
    
    /**
     * 删除用户所有技能
     */
    int deleteByUserId(@Param("userId") Long userId);
}
