package com.jollyclass.bean;

import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class AdviceTest {
	//通知之前测试
	@Test
	public void testBefore() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		User user = (User) context.getBean("userProxy");
		user.setAge(20);
		user.setName("jack");
		user.printAge();
		user.printName();
	}
	//通知之后测试
	@Test
	public void testAfter() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		User user = (User) context.getBean("userProxy1");
		user.setAge(20);
		user.setName("jack");
		user.printAge();
		user.printName();
	}
	//异常通知测试
	@Test
	public void testThrow() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		User user = (User) context.getBean("userProxy2");
		user.setAge(20);
		user.setName("jack");
		user.printAge();
		user.printName();
	}
	//环绕通知测试
	@Test
	public void testMutil() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		User user = (User) context.getBean("userProxy3");
		user.setAge(20);
		user.setName("jack");
		user.printAge();
		user.printName();
	}
}
