package com.jollyclass.bean;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;

import edu.emory.mathcs.backport.java.util.Arrays;

public class AfterDemo implements AfterReturningAdvice {
	/**
	 * arg3:代表当前获取的实例
	 * method：代表实例的方法
	 * object[]:代表实例的值
	 */
	@Override
	public void afterReturning(Object obj, Method method, Object[] arg2, Object arg3) throws Throwable {
		System.out.println("object:" + arg3 + ":method:" + method + ":object[]:" + Arrays.toString(arg2));
		System.out.println("------afterReturning------");
	}
}
