package com.yanxi.poxity.main;

import org.junit.Test;
import org.springframework.cglib.proxy.Enhancer;

public class TestUtil {
	@Test
	public void test() {
		Cat cat = new Cat();
		Enhancer enhancer = new Enhancer();
		enhancer.setSuperclass(cat.getClass());
		enhancer.setCallback(new MyInterceptor());
		Cat proxy = (Cat) enhancer.create();
		proxy.run();

	}
}
