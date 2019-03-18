package com.yanxi.spring.main;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.yanxi.spring.util.SpringDemo;
import com.yanxi.spring.util.SpringDemo2;

public class SpringMain {
	@SuppressWarnings("resource")
	public static void main(String[] args) {
		extracted();
	}

	private static void extracted() {
		/*
		 * XmlBeanFactory factory=new XmlBeanFactory(new
		 * ClassPathResource("bean.xml")); SpringDemo springDemo=(SpringDemo)
		 * factory.getBean("springDemo"); 这种方式已经过时
		 */
		ApplicationContext context = new ClassPathXmlApplicationContext("bean.xml");
		SpringDemo springDemo = (SpringDemo) context.getBean("springDemo");
		// springDemo.setMessage("spring");
		String message = springDemo.getMessage();
		System.out.println(message);
		SpringDemo2 springDemo2 = (SpringDemo2) context.getBean("springDemo2");
		springDemo2.setMessage2("springDemo2");
		System.out.println(springDemo2.getMessage2());
		((AbstractApplicationContext) context).registerShutdownHook();
	}
}
