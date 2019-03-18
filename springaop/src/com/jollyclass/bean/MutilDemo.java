package com.jollyclass.bean;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

import com.sun.xml.internal.bind.v2.runtime.unmarshaller.XsiNilLoader.Array;

import edu.emory.mathcs.backport.java.util.Arrays;

public class MutilDemo implements MethodInterceptor {
	/**
	 * invocation:可以获取当前的实例以及他们的方法和参数
	 * 它综合了通知之前和通知之后以及异常通知等模块，是一个综合体。
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
