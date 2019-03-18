package com.jollyclass.bean;

import java.lang.reflect.Method;

import org.springframework.aop.MethodBeforeAdvice;

import edu.emory.mathcs.backport.java.util.Arrays;

public class BeforeDemo implements MethodBeforeAdvice {

	/**
	 * method:需要执行的方法
	 * object：代表 获取的实例
	 * object[]:代表获取实例的值
	 */
	@Override
	public void before(Method method, Object[] arg1, Object obj) throws Throwable {
		System.out.println("object:" + obj + ":method:" + method);
		System.out.println("object[]:"+Arrays.toString(arg1));
		if (method.getName().equals("setAge")) {
			System.out.println("setAge");
		}
		System.out.println("------before------");
	}

}
