package com.yanxi.ioc.advice;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;

public class LogAdvice {
	 public void myBeforeAdivice(JoinPoint joinPoint){
		 System.out.println("======myBeforeAdivice===================");
	       /* String classname = joinPoint.getTarget().getClass().getSimpleName();
	        String methodname = joinPoint.getSignature().getName();
	        System.out.println(classname + " ——前置通知——" + methodname);*/
	    }

	    public void myAfterAdivice(JoinPoint joinPoint){
	    	System.out.println("======myAfterAdivice===================");
	       /* String classname = joinPoint.getTarget().getClass().getSimpleName();
	        String methodname = joinPoint.getSignature().getName();
	        System.out.println(classname + " ——后置通知——" + methodname);*/
	    }

	    /**
	     * 环绕通知将决定要不要执行连接点
	     * @throws Throwable 
	     */
	    public void myAroundAdivice(ProceedingJoinPoint point) throws Throwable{
	    	System.out.println("======myAroundAdivice===================");
	        System.out.println("环绕通知，执行代码前");
	        //选择执行
	        point.proceed();
	        System.out.println("环绕通知，执行代码后");
	    }
}
