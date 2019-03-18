package com.example.demo;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class MyWebMvcConfigura extends WebMvcConfigurerAdapter {
	@Value("${spring.mvc.static-path-patten}")
	private String patten;
	@Value("${spring.resources.static-locations}")
	private String locations;
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		//將自定义的目录制定到classpath目录下
		registry.addResourceHandler(patten).addResourceLocations(locations);
		//registry.addResourceHandler("/myFile/**").addResourceLocations("file:D:/");
		super.addResourceHandlers(registry);
	}

	

}
