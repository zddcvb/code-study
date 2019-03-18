package com.jollyclass.struts.interceptor;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;
import org.omg.CORBA.ARG_OUT;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;

public class LoginInterceptor implements Interceptor {

	@Override
	public void destroy() {
		System.out.println("interceptor destory");
	}

	@Override
	public void init() {
		System.out.println("interceptor init");
	}

	@Override
	public String intercept(ActionInvocation arg0) throws Exception {
		HttpServletRequest request = ServletActionContext.getRequest();
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if (username.equals("admin")) {
			return arg0.invoke();
		}else{
			ActionContext.getContext().put("message", "用户名错误，无法登陆");
		}
		return "login";
	}

}
