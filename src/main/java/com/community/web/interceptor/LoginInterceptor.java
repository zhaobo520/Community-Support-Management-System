package com.community.web.interceptor;

import com.community.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    HttpSession session = request.getSession(false);
    if (session != null) {
      User current = (User) session.getAttribute("CURRENT_USER");
      if (current != null) {
        return true;
      }
    }

    String contextPath = request.getContextPath();
    String requestUri = request.getRequestURI();

    // 根据请求的URL决定重定向到哪个登录页面
    String loginUrl = "/user/admin/login"; // 默认管理员登录

    if (requestUri.contains("/volunteer/") || requestUri.contains("/task/volunteer")) {
      loginUrl = "/user/volunteer/login";
    } else if (requestUri.contains("/family/") || requestUri.contains("/demand/family")) {
      loginUrl = "/user/family/login";
    } else if (requestUri.contains("/admin/") || requestUri.contains("/statistics/")) {
      loginUrl = "/user/admin/login";
    }

    response.sendRedirect(contextPath + loginUrl);
    return false;
  }

  @Override
  public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
                         ModelAndView modelAndView) {
  }

  @Override
  public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
  }
}
