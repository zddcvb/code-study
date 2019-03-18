package com.jollyclass.struts.action;

import java.util.ArrayList;

import com.jollyclass.bean.User;
import com.opensymphony.xwork2.ActionSupport;

public class ConvertAction extends ActionSupport {
	private User user;
	private ArrayList<String> lists;

	public ArrayList<String> getLists() {
		return lists;
	}

	public void setLists(ArrayList<String> lists) {
		this.lists = lists;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getConvertUser() {
		System.out.println(user.getName());
		System.out.println(user.getPassword());
		return "convert";
	}

	public String getConvertList() {
		System.out.println(user.getName());
		System.out.println(user.getPassword());
		for (String string : lists) {
			System.out.println(string);
		}
		return "convert";
	}
}
