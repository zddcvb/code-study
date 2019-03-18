package com.yanxi.spring.util;

public class SpringDemo {
	private String message;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void init() {
		System.out.println("init");
	}

	public void destory() {
		System.out.println("destory");
	}
}
