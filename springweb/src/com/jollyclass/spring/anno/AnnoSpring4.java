package com.jollyclass.spring.anno;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

import com.jollyclass.spring.dao.impl.UserDaoImpl;

@Configuration
@Import({AnnoSpring2.class,AnnoSpring3.class})
public class AnnoSpring4 {
	
}
