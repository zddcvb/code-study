package com.jollyclass.jmeter.main;

import org.apache.jmeter.config.Arguments;
import org.apache.jmeter.protocol.java.sampler.JavaSamplerContext;

public class JmeterMain {
	public static void main(String[] args) {
		Arguments params = new Arguments();
		params.addArgument("a", "0");// 设置参数，并赋予默认值0
		params.addArgument("b", "0");// 设置参数，并赋予默认值0
		JavaSamplerContext context = new JavaSamplerContext(params);
		JmeterTest test = new JmeterTest();
		test.setupTest(context);
		test.runTest(context);
		test.teardownTest(context);
	}
}
