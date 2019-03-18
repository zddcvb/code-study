package com.yanxi.dubbo.provider;

import java.io.IOException;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class DubboProvider {
	public static void main(String[] args) throws IOException {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application-dubbo-provider.xml");
		context.start();
		System.out.println("provider 发布成功");
		System.in.read();
	}
}
