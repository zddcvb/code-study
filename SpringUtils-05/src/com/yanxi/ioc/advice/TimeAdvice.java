package com.yanxi.ioc.advice;

public class TimeAdvice {
	 public void timeBefore(){
	        System.out.println("beforeTime = " + System.currentTimeMillis());
	    }

	    public void timeAfter(){
	        System.out.println("afterTime = " + System.currentTimeMillis());
	    }
}
