package com.jollyclass.spring.action;

import org.junit.Test;

public class SpringDemoTest {
	@Test
	public void testGetName() {
		SpringDemo1 demo1 = new SpringDemo1();
		demo1.getName();
		//demo1.getUserDao();
	}
	@Test
	public void testExtend(){
		SpringDemo1 demo1 = new SpringDemo1();
		demo1.testExtends();
	}
	
	@Test
	public void testUserInfo(){
		SpringDemo1 demo1 = new SpringDemo1();
		demo1.testContext();
	}
	@Test
	public void testDate(){
		SpringDemo1 demo1 = new SpringDemo1();
		demo1.testDate1();
	}
	
	@Test
	public void testDate2(){
		SpringDemo1 demo1 = new SpringDemo1();
		demo1.testDate2();
	}
	
}
