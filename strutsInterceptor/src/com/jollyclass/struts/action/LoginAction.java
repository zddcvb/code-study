package com.jollyclass.struts.action;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class LoginAction extends ActionSupport {
	private String username;
	private String password;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String login() {
		ActionContext.getContext().put("message", "登陆成功");
		return "login";
	}
	public String attri() {
		if ("admin".equals(username)) {
			ActionContext.getContext().getValueStack().push("用户名正确，请登陆");
		}else{
			ActionContext.getContext().getValueStack().push("用户名错误，请重新输入");
		}
		return "login";
	}
}
