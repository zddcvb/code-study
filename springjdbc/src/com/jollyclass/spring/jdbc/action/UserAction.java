package com.jollyclass.spring.jdbc.action;

import java.util.List;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.spring.jdbc.bean.User;
import com.jollyclass.spring.jdbc.dao.UserDao;

public class UserAction {
	public UserDao getUserDao() {
		ApplicationContext context = new ClassPathXmlApplicationContext("spring-module.xml");
		UserDao userDao = (UserDao) context.getBean("UserDao");
		return userDao;
	}

	public void testFindAllUsers() {
		List<User> users = getUserDao().findAllUsers();
		for (User user : users) {
			System.out.println(user.toString());
		}
	}

	public void testFindUserById() {
		User user = getUserDao().findUser(40);
		System.out.println(user.toString());
	}

	public void testinsertUser() {
		User user = new User();
		user.setId(3);
		user.setName("lucy");
		user.setAge(15);
		getUserDao().insertUser(user);
	}

	public void testupdateUser() {
		User user = new User();
		user.setId(35);
		user.setName("jack");
		user.setAge(100);
		getUserDao().updateUser(user);
	}

	public void testDeleteUser() {
		getUserDao().deleteUser(31);
	}
}
