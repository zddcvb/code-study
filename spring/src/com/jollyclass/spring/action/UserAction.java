package com.jollyclass.spring.action;

public class UserAction {
	private String name;

	public void setName(String name) {
		this.name = name;
	}

	public void printUser() {
		System.out.println("printUser:" + name);
	}

}
