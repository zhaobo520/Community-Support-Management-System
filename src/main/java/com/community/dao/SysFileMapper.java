package com.community.dao;

import com.community.domain.SysFile;
import org.apache.ibatis.annotations.*;

/**
 * 文件存储Mapper
 */
@Mapper
public interface SysFileMapper {

    @Insert("INSERT INTO sys_file (original_name, content_type, file_size, file_data, upload_by) " +
            "VALUES (#{originalName}, #{contentType}, #{fileSize}, #{fileData}, #{uploadBy})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(SysFile sysFile);

    @Select("SELECT id, original_name, content_type, file_size, file_data, upload_by, created_at FROM sys_file WHERE id = #{id}")
    @Results({
        @Result(property = "id", column = "id"),
        @Result(property = "originalName", column = "original_name"),
        @Result(property = "contentType", column = "content_type"),
        @Result(property = "fileSize", column = "file_size"),
        @Result(property = "fileData", column = "file_data"),
        @Result(property = "uploadBy", column = "upload_by"),
        @Result(property = "createdAt", column = "created_at")
    })
    SysFile findById(@Param("id") Long id);

    @Delete("DELETE FROM sys_file WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
}
