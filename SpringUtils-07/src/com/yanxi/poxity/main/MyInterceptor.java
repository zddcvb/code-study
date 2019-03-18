package com.yanxi.poxity.main;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import org.aopalliance.intercept.MethodInvocation;
import org.springframework.cglib.proxy.MethodInterceptor;
import org.springframework.cglib.proxy.MethodProxy;

public class MyInterceptor implements MethodInterceptor {

	@Override
	public Object intercept(Object proxy, Method method, Object[] args, MethodProxy arg3) {
		Object invoke = null;
		try {
			if (method.getName().equals("run")) {
				System.out.println("=====run 被拦截=========");
				invoke = method.invoke(proxy, args);
				System.out.println("=====run 被拦截后=========");
				return invoke;
			}
			invoke = method.invoke(proxy, args);
		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException e) {
			e.printStackTrace();
		}
		return invoke;
	}

}
