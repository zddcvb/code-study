package com.jollyclass.springhibernate.test;

import java.util.List;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.springhibernate.bean.User;
import com.jollyclass.springhibernate.dao.UserDao;

public class SHTest {
	public UserDao getUserDao() {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring-module.xml");
		;
		UserDao userDao = (UserDao) context.getBean("userDao");
		return userDao;
	}

	@Test
	public void testFindUser() {
		User user = getUserDao().findUser(20);
		System.out.println(user);
	}

	@Test
	public void testFindAll() {
		List<User> users = getUserDao().findAllUsers();
		for (User user : users) {
			System.out.println(user);
		}
	}

	@Test
	public void testInsert() {
		User user = new User();
		user.setId(111);
		user.setName("basaka");
		user.setAge(20);
		getUserDao().insertUser(user);
	}

	@Test
	public void testupdate() {
		getUserDao().updateUser(28);
	}

	@Test
	public void testdelete() {
		getUserDao().deleteUser(35);
	}
}
