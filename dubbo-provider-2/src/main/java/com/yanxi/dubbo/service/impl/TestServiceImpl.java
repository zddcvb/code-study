package com.yanxi.dubbo.service.impl;

import com.yanxi.dubbo.pojo.User;
import com.yanxi.dubbo.service.TestService;

public class TestServiceImpl implements TestService{

	public String insert(User user) {
		System.out.println("TestServiceImpl");
		return user.toString();
	}

}
