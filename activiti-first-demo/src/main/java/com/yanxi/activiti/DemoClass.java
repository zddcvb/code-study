package com.yanxi.activiti;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;

public class DemoClass implements JavaDelegate {
	public DemoClass() {
		System.out.println("===============DemoClass==============");
	}

	public void execute(DelegateExecution execution) throws Exception {
		System.out.println(execution.getId());

	}
}
