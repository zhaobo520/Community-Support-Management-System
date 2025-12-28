package com.community.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * XSS Filter
 */
public class XssFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        XssHttpServletRequestWrapper wrappedRequest = new XssHttpServletRequestWrapper(httpRequest);
        chain.doFilter(wrappedRequest, response);
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
