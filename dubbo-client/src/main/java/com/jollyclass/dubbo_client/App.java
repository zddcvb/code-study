package com.jollyclass.dubbo_client;

import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.jollyclass.dubbo_client.service.DubboService;

/**
 * Hello world!
 *
 */
public class App {
	public static void main(String[] args) {
		System.out.println("Hello World!");
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application-client-context.xml");
		DubboService service = (DubboService) context.getBean("dubboService");
		String say = service.say("zhoudan");
		System.out.println(say);

	}
}
