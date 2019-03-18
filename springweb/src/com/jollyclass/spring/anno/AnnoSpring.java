package com.jollyclass.spring.anno;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.jollyclass.spring.dao.impl.UserDaoImpl;

@Configuration
public class AnnoSpring {
	@Bean(name="UserDao")
	public UserDaoImpl getUserDaoImpl() {
		return new UserDaoImpl();
	}
}
