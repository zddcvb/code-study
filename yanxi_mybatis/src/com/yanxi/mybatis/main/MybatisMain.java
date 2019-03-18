package com.yanxi.mybatis.main;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.yanxi.mybatis.service.EmployeeService;
import com.yanxi.mybatis.service.impl.EmployeeServiceImpl;

public class MybatisMain {
	private static Logger logger=LoggerFactory.getLogger(MybatisMain.class);
	public static void main(String[] args) {
		EmployeeService service = new EmployeeServiceImpl();
		service.selectAll();
		logger.info("info");
	}
}
