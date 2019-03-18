package com.yanxi.h2.test;

import org.junit.Test;

import com.yanxi.h2.utils.H2Utils;

public class H2Test {
	@Test
	public void test_1(){
		H2Utils utils=new H2Utils("h2.properties");
		utils.findAll();
	}
}
