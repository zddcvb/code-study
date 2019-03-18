package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.web.servlet.DispatcherServlet;

@SpringBootApplication
@ServletComponentScan
public class DemoApplication {

	/* 不通过注解生成servlet
	 * public ServletRegistrationBean servletRegistrationBean() { return new
	 * ServletRegistrationBean(new MyServlet(),"/xs/*"); }
	 */

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	/**
	 * 修改url
	 * @param dispatcherServlet
	 * @return
	 */
	public ServletRegistrationBean dispatcherRegistration(DispatcherServlet dispatcherServlet) {
		ServletRegistrationBean registration = new ServletRegistrationBean(dispatcherServlet);
		registration.getUrlMappings().clear();
		registration.addUrlMappings("*.do");
		registration.addUrlMappings("*.json");
		return registration;
	}

}
