package com.yanxi.poxity.main;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.aopalliance.intercept.MethodInvocation;
import org.springframework.cglib.proxy.Enhancer;
import org.springframework.cglib.proxy.MethodInterceptor;
import org.springframework.cglib.proxy.MethodProxy;

public class SpringMain {
	public static void main(String[] args) {
		Cat cat = new Cat();
		Enhancer enhancer = new Enhancer();
		enhancer.setSuperclass(cat.getClass());
		enhancer.setCallback(new MethodInterceptor() {

			@Override
			public Object intercept(Object arg0, Method arg1, Object[] arg2, MethodProxy arg3) throws Throwable {
				if (arg1.getName().equals("run")) {
					System.out.println("=====run 被拦截=========");
					Object invoke = arg1.invoke(arg0, arg2);
					System.out.println("=====run 被拦截后=========");
					return invoke;
				}
				return arg1.invoke(arg0, arg2);
			}
		});
		Cat	 proxy = (Cat) enhancer.create();
		proxy.run();
	}

	private void method_1(){
		Sell sell=new Factory();
		 sell = (Sell) Proxy.newProxyInstance(sell.getClass().getClassLoader(), sell.getClass().getInterfaces(),
				new InvocationHandler() {
					
					@Override
					public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
						String name = method.getName();
						if (name.equals("sell")) {
							System.out.println("此方法被拦截了");
							return null;
						}
						return method.invoke(proxy, args);
					}
				});
		
		sell.sell();
	}
}
