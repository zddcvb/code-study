package com.fileload.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fileload.utils.MyRequest;

/**
 * Servlet Filter implementation class UploadFilter
 */
@WebFilter("/UploadFilter")
public class UploadFilter implements Filter {

	/**
	 * Default constructor.
	 */
	public UploadFilter() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest mRequest = (HttpServletRequest) request;
		HttpServletResponse mResponse = (HttpServletResponse) response;
		mRequest.setCharacterEncoding("utf-8");
		mResponse.setContentType("text/html;charset=utf-8");
		//MyRequest myRequest = (MyRequest) mRequest;
		chain.doFilter(mRequest, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
