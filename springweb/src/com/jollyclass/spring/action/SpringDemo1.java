package com.jollyclass.spring.action;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

import org.springframework.beans.factory.config.CustomEditorConfigurer;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.spring.bean.Student;
import com.jollyclass.spring.bean.User;
import com.jollyclass.spring.bean.UserInfo;
import com.jollyclass.spring.dao.UserDao;
import com.jollyclass.spring.service.UserService;
import com.jollyclass.spring.service.impl.UserServiceImpl;

public class SpringDemo1 {

	public void getName() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		UserAction action = (UserAction) context.getBean("userAction");
		action.printUser();
	}

	public void getUserDao() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		UserService userService = (UserService) context.getBean("userService");
		userService.findUser();
		userService.findAllUsers();
	}

	public void testExtends() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		UserAction userAction = (UserAction) context.getBean("userActionExtend");
		System.out.println(userAction);
	}

	public void testContext() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		ArrayList<User> lists = new ArrayList<User>();
		UserInfo userInfo = (UserInfo) context.getBean("userInfo");
		for (int i = 1; i < 10; i++) {
			User user = (User) context.getBean("user");

			user.setAge(50 + i + "");
			user.setId(10 + i + "");
			user.setName("hapy" + i);
			System.out.println(user);
			lists.add(user);
		}
		System.out.println(lists);
		userInfo.setUsers(lists);
		System.out.println(userInfo.getUsers());
	}
	
	public void testDate1(){
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		Student student = (Student) context.getBean("Student");			
		System.out.println(new SimpleDateFormat("yyyy-MM-dd").format(student.getDate()));		
	}
	public void testDate2(){
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		Student student = (Student) context.getBean("student");		
		System.out.println(new SimpleDateFormat("yyyy-MM-dd").format(student.getDate()));		
	}
}
