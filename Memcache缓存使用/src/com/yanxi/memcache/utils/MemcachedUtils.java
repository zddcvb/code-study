package com.yanxi.memcache.utils;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import net.spy.memcached.CASResponse;
import net.spy.memcached.MemcachedClient;

public class MemcachedUtils {

	public MemcachedUtils() {
		super();
	}

	public MemcachedClient getClient() {
		MemcachedClient client = null;
		try {
			InetSocketAddress ia = new InetSocketAddress("192.168.119.128", 11211);
			client = new MemcachedClient(ia);

		} catch (IOException e) {
			e.printStackTrace();
		}
		return client;
	}

	@SuppressWarnings("rawtypes")
	public void set(String key, int exp, Object obj) {
		try {
			MemcachedClient client = getClient();
			Future future = client.set(key, exp, obj);
			System.out.println(future.get());
			client.shutdown();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("rawtypes")
	public void add(String key, int exp, Object obj) {
		try {
			MemcachedClient client = getClient();
			Future future = client.add(key, exp, obj);
			System.out.println(future.get());
			client.shutdown();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		}
	}

	public Object get(String key) {
		MemcachedClient client = getClient();
		Object object = (Object) client.get(key);
		System.out.println(object);
		client.shutdown();
		return object;
	}

	public void delete(String key) {
		MemcachedClient client = getClient();
		client.delete(key);
		client.shutdown();
	}

	public long incr(String key, int value) {
		MemcachedClient client = getClient();
		long incr = client.incr(key, value);
		client.shutdown();
		return incr;
	}

	public long decr(String key, int value) {
		MemcachedClient client = getClient();
		long decr = client.decr(key, value);
		client.shutdown();
		return decr;
	}

	public void prehend(String key, Object object) {
		MemcachedClient client = getClient();
		client.prepend(key, object);
		client.shutdown();
	}

	public void append(String key, Object object) {
		MemcachedClient client = getClient();
		client.append(key, object);
		System.out.println(client.get(key));
		client.shutdown();
	}

	public void replace(String key, int exp, Object obj) {
		MemcachedClient client = getClient();
		client.replace(key, exp, obj);
		client.shutdown();
	}

	public void flushAll() {
		MemcachedClient client = getClient();
		client.flush();
		client.shutdown();
	}

	public void cas(String key, long casId, int exp, Object value) {
		MemcachedClient client = getClient();
		CASResponse cas = client.cas(key, casId, exp, value);
		System.out.println(cas.name());
	}

}
