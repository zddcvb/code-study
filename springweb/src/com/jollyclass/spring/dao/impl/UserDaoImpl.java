package com.jollyclass.spring.dao.impl;

import com.jollyclass.spring.dao.UserDao;

public class UserDaoImpl implements UserDao {

	@Override
	public void findUser() {
		System.out.println("userDao findUser");
	}
}
