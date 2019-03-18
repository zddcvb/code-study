package com.yanxi.dubbo.consumer;

import java.util.List;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yanxi.dubbo.pojo.User;
import com.yanxi.dubbo.service.DemoService;

public class DubboConsumer {
	public static void main(String[] args) {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application-dubbo-consumer.xml");
		context.start();
		System.out.println("consumer success");
		DemoService demoService = (DemoService) context.getBean("demoService");
		
		String content = demoService.sayHello("name");
		System.out.println(content);
		List<User> users = demoService.getUsers();
		System.out.println(users);
	}
}
