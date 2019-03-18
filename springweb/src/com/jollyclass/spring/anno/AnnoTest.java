package com.jollyclass.spring.anno;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import com.jollyclass.spring.bean.User;
import com.jollyclass.spring.bean.UserInfo;
import com.jollyclass.spring.dao.UserDao;

public class AnnoTest {
	@Test
	public void testAnno() {
		ApplicationContext context = new AnnotationConfigApplicationContext(AnnoSpring.class);
		UserDao userDao = (UserDao) context.getBean("UserDao");
		userDao.findUser();
	}
	@Test
	public void test2() {
		ApplicationContext context = new AnnotationConfigApplicationContext(AnnoSpring4.class);
		UserInfo userInfo = (UserInfo) context.getBean("UserInfo");
		userInfo.sayHello();

		User user = (User) context.getBean("User");
		user.sayHello();
	}
}
