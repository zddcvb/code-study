package com.yanxi.spring.util;

import org.omg.CORBA.ARG_OUT;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;

public class SpringBeanPost implements BeanPostProcessor {

	@Override
	public Object postProcessAfterInitialization(Object arg0, String arg1) throws BeansException {
		System.out.println("postProcessAfterInitialization:"+arg1);
		return arg0;
	}

	@Override
	public Object postProcessBeforeInitialization(Object arg0, String arg1) throws BeansException {
		System.out.println("postProcessBeforeInitialization:"+arg1);
		//SpringDemo springDemo=(SpringDemo) arg0;
		//springDemo.setMessage("process");
		return arg0;
	}

}
