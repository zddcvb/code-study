package com.yanxi.tingpng.thread;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class ImageCompressThreadPool {
	private static int corePoolSize = 2;
	private static int maximumPoolSize = 4;
	private static long keepAliveTime = 3;
	private static ThreadPoolExecutor executor;

	private ImageCompressThreadPool() {
	}

	public static ThreadPoolExecutor getThreadPoolExecutor() {
		if (null == executor) {
			executor = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveTime, TimeUnit.SECONDS,
					new ArrayBlockingQueue<>(4));
		}
		return executor;
	}

	public static Boolean isEmpty() {
		while (true) {
			if (executor.getActiveCount() == 0) {
				return true;
			}
		}
	}

}
