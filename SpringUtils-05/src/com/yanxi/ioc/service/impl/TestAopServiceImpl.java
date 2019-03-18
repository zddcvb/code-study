package com.yanxi.ioc.service.impl;

import com.yanxi.ioc.service.TestAopService;
public class TestAopServiceImpl implements TestAopService {
	
	@Override
	public void findAll() {
		System.out.println("================FindAll========");
	}

}
