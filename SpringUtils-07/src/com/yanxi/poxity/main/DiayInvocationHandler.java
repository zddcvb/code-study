package com.yanxi.poxity.main;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public class DiayInvocationHandler implements InvocationHandler {
	private Object object;

	public DiayInvocationHandler(Object object) {
		this.object = object;
	}

	@Override
	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
		System.out.println("======invoke before============");
		Object result = method.invoke(object, args);
		System.out.println("======invoke after=============");
		return result;
	}
}
