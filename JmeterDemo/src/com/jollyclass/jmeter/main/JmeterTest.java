package com.jollyclass.jmeter.main;

import org.apache.jmeter.config.Arguments;
import org.apache.jmeter.protocol.java.sampler.JavaSamplerClient;
import org.apache.jmeter.protocol.java.sampler.JavaSamplerContext;
import org.apache.jmeter.samplers.SampleResult;

public class JmeterTest implements JavaSamplerClient {

	private SampleResult result;
	private String filename;
	private String b;
	private String a;

	// 设置传入的参数，可以设置多个，已设置的参数会显示到Jmeter的参数列表中
	@Override
	public Arguments getDefaultParameters() {
		Arguments arguments = new Arguments();
		arguments.addArgument("filename", "0");// 设置参数，并赋予默认值0
		arguments.addArgument("a", "0");// 设置参数，并赋予默认值0
		arguments.addArgument("b", "0");// 设置参数，并赋予默认值0
		return arguments;
	}

	// 测试执行的循环体，根据线程数和循环次数的不同可执行多次
	@Override
	public SampleResult runTest(JavaSamplerContext arg0) {
		a = arg0.getParameter("a");
		b = arg0.getParameter("b");
		filename = arg0.getParameter("filename");
		// jmeter 开始统计响应时间标记
		result.sampleStart();
		try {
			OutputService.output(filename, Integer.parseInt(a), Integer.parseInt(b));
			result.setSuccessful(true);
		} catch (Exception e) {
			result.samplePause();
			e.printStackTrace();
		} finally {
			result.sampleEnd();
		}
		return result;
	}

	// 初始化方法，实际运行时每个线程仅执行一次，在测试方法运行前执行
	@Override
	public void setupTest(JavaSamplerContext arg0) {
		result = new SampleResult();
	}

	// 结束方法，实际运行时每个线程仅执行一次，在测试方法运行结束后执行
	@Override
	public void teardownTest(JavaSamplerContext arg0) {

	}

}
