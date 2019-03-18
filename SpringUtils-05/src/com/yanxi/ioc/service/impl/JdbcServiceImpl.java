package com.yanxi.ioc.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.yanxi.ioc.service.JdbcService;
import com.yanxi.ioc.service.TestAopService;

public class JdbcServiceImpl implements JdbcService {
	@Autowired
	private TestAopService service;

	@Override
	public void findAll() {
		service.findAll();
	}

}
