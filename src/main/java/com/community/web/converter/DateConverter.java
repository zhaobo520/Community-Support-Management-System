package com.community.web.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 字符串转日期转换器
 */
@Component
public class DateConverter implements Converter<String, Date> {

    private static final String[] DATE_FORMATS = {
        "yyyy-MM-dd'T'HH:mm",     // datetime-local格式
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm",
        "yyyy-MM-dd",
        "yyyy/MM/dd HH:mm:ss",
        "yyyy/MM/dd"
    };

    @Override
    public Date convert(String source) {
        if (source == null || source.trim().isEmpty()) {
            return null;
        }

        source = source.trim();

        // 尝试所有可能的日期格式
        for (String format : DATE_FORMATS) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                sdf.setLenient(false);
                return sdf.parse(source);
            } catch (ParseException e) {
                // 继续尝试下一个格式
            }
        }

        // 如果所有格式都失败，返回null或抛出异常
        throw new IllegalArgumentException("Invalid date format: " + source);
    }
}
