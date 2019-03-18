package com.yanxi.linux.utils;

import java.util.Map;
import java.util.Set;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisUtils {
	private String redisUrl;
	private int port;

	public RedisUtils() {
	}

	public RedisUtils(String redisUrl, int port) {
		this.redisUrl = redisUrl;
		this.port = port;
	}

	public String getRedisUrl() {
		return redisUrl;
	}

	public void setRedisUrl(String redisUrl) {
		this.redisUrl = redisUrl;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	/**
	 * 单机版redis，从连接池中获取
	 * 
	 * @param redisUrl
	 * @param port
	 * @return
	 */
	@SuppressWarnings("resource")
	private Jedis getJedisFromPool() {
		JedisPoolConfig config = new JedisPoolConfig();
		JedisPool pool = new JedisPool(config, redisUrl, port);
		Jedis jedis = pool.getResource();
		System.out.println(jedis.isConnected());
		return jedis;
	}

	/**
	 * 单机版，直接获取jedis
	 * 
	 * @param redisUrl
	 * @param port
	 * @return
	 */
	private Jedis getJedis() {
		Jedis jedis = new Jedis(redisUrl, port);
		if (jedis.isConnected()) {
			return jedis;
		}
		return null;
	}

	/**
	 * redis集群版
	 * 
	 * @param nodes
	 * @return
	 */
	private JedisCluster getJedisCluster(Set<HostAndPort> nodes) {
		JedisCluster cluster = new JedisCluster(nodes);
		return cluster;
	}

	public String set(String key, String value) {
		String set = getJedis().set(key, value);
		return set;
	}

	public String get(String key) {
		String data = getJedis().get(key);
		return data;
	}
	public Long delete(String key){
		Long del = getJedis().del(key);
		return del;
	}
	public Long incr(String key) {
		Long incr = getJedis().incr(key);
		return incr;
	}

	public Long decr(String key) {
		Long decr = getJedis().decr(key);
		return decr;
	}

	public Long hset(String key, String field, String value) {
		Long hset = getJedis().hset(key, field, value);
		return hset;
	}
	public String hmset(String key,Map<String , String> map){
		String hmset = getJedis().hmset(key, map);
		return hmset;
	}

	public String getSet(String key, String field) {
		String hget = getJedis().hget(key, field);
		return hget;
	}
	public Map<String, String> getSet(String key){
		Map<String, String> map = getJedis().hgetAll(key);
		return map;
	}
	//根据字段删除数据，可以是多个
	public Long delSet(String key,String... fields){
		Long hdel = getJedis().hdel(key, fields);
		return hdel;
	}
	//删除所有
	public Long delSet(String key){
		Long del = getJedis().del(key);
		return del;
	}
}
