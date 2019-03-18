package com.yanxi.dubbo.consumer;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yanxi.dubbo.pojo.User;
import com.yanxi.dubbo.service.TestService;

public class DubboConsumer1 {
	public static void main(String[] args) {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application-dubbo-consumer.xml");
		context.start();
		System.out.println("consumer success");
		TestService testService = (TestService) context.getBean("testService");
		User user=new User();
		user.setAge(20);;
		user.setName("jack");
		user.setSex("man");
		String result = testService.insert(user);
		System.out.println(result);
	}
}
