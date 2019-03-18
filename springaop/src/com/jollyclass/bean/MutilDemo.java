package com.jollyclass.bean;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

import edu.emory.mathcs.backport.java.util.Arrays;

public class MutilDemo implements MethodInterceptor {
	/**
	 * invocation:���Ի�ȡ��ǰ��ʵ���Լ����ǵķ����Ͳ���
	 * ���ۺ���֪֮ͨǰ��֪֮ͨ���Լ��쳣֪ͨ��ģ�飬��һ���ۺ��塣
	 */
	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		System.out.println("invocation:" + Arrays.toString(invocation.getArguments()));
		System.out.println("invocation:" + invocation.getMethod().getName());
		System.out.println("before : Before method !");
		try {
			Object proceed = invocation.proceed();
			//System.out.println(proceed.toString());
			System.out.println("after : after method !");
			return proceed;
		} catch (Exception exception) {
			exception.printStackTrace();
		}
		return null;
	}

}
