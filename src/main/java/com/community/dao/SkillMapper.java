package com.community.dao;

import com.community.domain.Skill;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 技能Mapper接口
 */
public interface SkillMapper {
    
    /**
     * 查询所有启用的技能
     */
    List<Skill> findAllActive();
    
    /**
     * 按分类查询技能
     */
    List<Skill> findByCategory(@Param("category") String category);
    
    /**
     * 根据ID查询
     */
    Skill findById(@Param("id") Long id);
    
    /**
     * 插入技能
     */
    int insert(Skill skill);
    
    /**
     * 更新技能
     */
    int update(Skill skill);
    
    /**
     * 删除技能
     */
    int deleteById(@Param("id") Long id);
}
