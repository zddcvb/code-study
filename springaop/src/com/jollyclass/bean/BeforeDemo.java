package com.jollyclass.bean;

import java.lang.reflect.Method;

import org.springframework.aop.MethodBeforeAdvice;

import edu.emory.mathcs.backport.java.util.Arrays;

public class BeforeDemo implements MethodBeforeAdvice {

	/**
	 * method:��Ҫִ�еķ���
	 * object������ ��ȡ��ʵ��
	 * object[]:�����ȡʵ����ֵ
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
