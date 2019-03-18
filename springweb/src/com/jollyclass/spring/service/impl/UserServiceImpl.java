package com.jollyclass.spring.service.impl;

import com.jollyclass.spring.dao.UserDao;
import com.jollyclass.spring.service.UserService;

public class UserServiceImpl implements UserService {
	private UserDao userDao;

	@Override
	public void findUser() {
		userDao.findUser();
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	@Override
	public void findAllUsers() {
		System.out.println("userService findAllUsers");
	}
}
