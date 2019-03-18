package com.jollyclass.bean;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;

import edu.emory.mathcs.backport.java.util.Arrays;

public class AfterDemo implements AfterReturningAdvice {
	/**
	 * arg3:����ǰ��ȡ��ʵ��
	 * method������ʵ���ķ���
	 * object[]:����ʵ����ֵ
	 */
	@Override
	public void afterReturning(Object obj, Method method, Object[] arg2, Object arg3) throws Throwable {
		System.out.println("object:" + arg3 + ":method:" + method + ":object[]:" + Arrays.toString(arg2));
		System.out.println("------afterReturning------");
	}
}
