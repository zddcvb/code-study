package com.example.demo.configuration;

import org.springframework.boot.bind.RelaxedPropertyResolver;
import org.springframework.context.EnvironmentAware;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;

@Configuration
public class MyWebAppConfigurer implements EnvironmentAware {

	@Override
	public void setEnvironment(Environment environment) {
		String java_home = environment.getProperty("JAVA_HOME");
		System.out.println("java-home:" + java_home);
		String url = environment.getProperty("spring.datasource.url");
		System.out.println("environment :" + url);
		RelaxedPropertyResolver propertyResolver = new RelaxedPropertyResolver(environment, "spring.datasource.");
		String urlPro = propertyResolver.getProperty("url");
		System.out.println("RelaxedPropertyResolver:" + urlPro);
	}

}
