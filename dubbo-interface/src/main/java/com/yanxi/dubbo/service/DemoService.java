package com.yanxi.dubbo.service;

import java.util.List;

import com.yanxi.dubbo.pojo.User;

public interface DemoService {
	public String sayHello(String name);

	public List<User> getUsers();
}
