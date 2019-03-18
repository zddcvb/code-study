package com.jollyclass.spring.anno;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.jollyclass.spring.bean.UserInfo;
import com.jollyclass.spring.dao.impl.UserDaoImpl;

@Configuration
public class AnnoSpring2 {
	@Bean(name = "UserInfo")
	public UserInfo getUserInfo() {
		return new UserInfo();
	}
}
