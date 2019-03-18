package com.jollyclass.spring.anno;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.jollyclass.spring.bean.User;
import com.jollyclass.spring.bean.UserInfo;
import com.jollyclass.spring.dao.impl.UserDaoImpl;

@Configuration
public class AnnoSpring3 {
	@Bean(name = "User")
	public User getUser() {
		return new User();
	}
}
