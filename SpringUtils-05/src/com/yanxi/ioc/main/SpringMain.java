package com.yanxi.ioc.main;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yanxi.ioc.service.TestAopService;

public class SpringMain {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("bean2.xml");
		TestAopService service = (TestAopService) context.getBean("jdbcService");
		service.findAll();
	}
}
