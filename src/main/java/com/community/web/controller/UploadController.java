package com.community.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 兼容旧的 /uploads 路径入口。
 * 当前项目已经统一改为数据库存储 + /file/view/{id} 访问，
 * 该控制器保留仅用于避免旧链接映射类缺失导致启动失败。
 */
@Controller
@RequestMapping("/uploads")
public class UploadController {
}
