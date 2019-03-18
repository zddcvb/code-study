package com.jollyclass.bean;

import org.springframework.aop.ThrowsAdvice;

public class ThrowDemo implements ThrowsAdvice {
	public void afterThrowing(IllegalArgumentException e) throws Throwable {
		System.out.println("HijackThrowException : Throw exception hijacked!");
	}
}
