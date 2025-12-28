package com.community.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

/**
 * XSS HTTP Servlet Request Wrapper
 */
public class XssHttpServletRequestWrapper extends HttpServletRequestWrapper {

    public XssHttpServletRequestWrapper(HttpServletRequest request) {
        super(request);
    }

    @Override
    public String[] getParameterValues(String parameter) {
        String[] values = super.getParameterValues(parameter);
        if (values == null) {
            return null;
        }
        
        String[] cleanValues = new String[values.length];
        for (int i = 0; i < values.length; i++) {
            cleanValues[i] = cleanXSS(values[i]);
        }
        return cleanValues;
    }

    @Override
    public String getParameter(String parameter) {
        String value = super.getParameter(parameter);
        return cleanXSS(value);
    }

    @Override
    public String getHeader(String name) {
        String value = super.getHeader(name);
        return cleanXSS(value);
    }

    /**
     * Clean XSS from string
     */
    private String cleanXSS(String value) {
        if (value == null) {
            return null;
        }

        // Remove script tags
        value = value.replaceAll("<script>(.*?)</script>", "");
        
        // Remove src attribute with javascript
        value = value.replaceAll("src[\\r\\n]*=[\\r\\n]*\\'(.*?)\\'", "");
        value = value.replaceAll("src[\\r\\n]*=[\\r\\n]*\\\"(.*?)\\\"", "");
        
        // Remove </script>
        value = value.replaceAll("</script>", "");
        
        // Remove <script ...>
        value = value.replaceAll("<script(.*?)>", "");
        
        // Remove eval()
        value = value.replaceAll("eval\\((.*?)\\)", "");
        
        // Remove expression()
        value = value.replaceAll("expression\\((.*?)\\)", "");
        
        // Remove javascript:
        value = value.replaceAll("javascript:", "");
        
        // Remove vbscript:
        value = value.replaceAll("vbscript:", "");
        
        // Remove onload=
        value = value.replaceAll("onload(.*?)=", "");

        return value;
    }
}
