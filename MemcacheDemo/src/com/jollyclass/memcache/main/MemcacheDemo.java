package com.jollyclass.memcache.main;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

import net.spy.memcached.MemcachedClient;

public class MemcacheDemo {
	public static void main(String[] args) throws IOException, InterruptedException, ExecutionException {
		MemcachedClient mc = new MemcachedClient(new InetSocketAddress("192.168.139.128", 11211));
		System.out.println("memcached start ");
		//@SuppressWarnings("rawtypes")
		Future future = mc.set("flag", 100, "zhangsan");
		//System.out.println("查看存储状态："+future.get());
		//System.out.println("获取存储的数据："+mc.get("name"));
		mc.shutdown();
		System.out.println("memcached shutdow");
	}
}
