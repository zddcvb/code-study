package com.jollyclass.struts.action;

import java.util.ArrayList;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class ListAction extends ActionSupport {
	public String list() {
		ArrayList<String> lists = new ArrayList<String>();
		lists.add("java");
		lists.add("c#");
		lists.add("c++");
		lists.add("php");
		ActionContext.getContext().put("lists", lists);
		return "list_form";
	}
}
