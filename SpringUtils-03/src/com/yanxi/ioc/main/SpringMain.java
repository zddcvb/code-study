package com.yanxi.ioc.main;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yanxi.ioc.bean.Person2;

public class SpringMain {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("bean2.xml");
		Person2 person = (Person2) context.getBean("person2");
		person.say();
	}
}
