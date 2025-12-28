package com.community.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

/**
 * Global Exception Handler
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handle general exceptions
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(HttpServletRequest request, Exception e) {
        log.error("Global exception caught at {}: ", request.getRequestURL(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", e);
        mav.addObject("url", request.getRequestURL());
        mav.addObject("message", e.getMessage());
        mav.setViewName("error/500");
        
        return mav;
    }

    /**
     * Handle IllegalArgumentException
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ModelAndView handleIllegalArgumentException(HttpServletRequest request, IllegalArgumentException e) {
        log.warn("Illegal argument at {}: {}", request.getRequestURL(), e.getMessage());
        
        ModelAndView mav = new ModelAndView();
        mav.addObject("message", e.getMessage());
        mav.addObject("url", request.getRequestURL());
        mav.setViewName("error/400");
        
        return mav;
    }

    /**
     * Handle NullPointerException
     */
    @ExceptionHandler(NullPointerException.class)
    public ModelAndView handleNullPointerException(HttpServletRequest request, NullPointerException e) {
        log.error("Null pointer exception at: {}", request.getRequestURL(), e);
        
        ModelAndView mav = new ModelAndView();
        mav.addObject("message", "System error, please contact administrator");
        mav.addObject("url", request.getRequestURL());
        mav.setViewName("error/500");
        
        return mav;
    }
}
