package com.yanxi.kafka.main;

public class KafkaConfiguration {
	/**
	 * zookeeper集群
	 */
	public final static String ZK = "127.0.0.1:2181";
	/**
	 * kafka组
	 */
	public final static String GROUP_ID = "test_group1";
	/**
	 * topic
	 */
	public final static String TOPIC = "test2";
	/**
	 * broker地址
	 */
	public final static String BROKER_LIST = "10.211.55.15:9092,10.211.55.17:9092,10.211.55.18:9092";
	/**
	 * 缓存大小
	 */
	public final static int BUFFER_SIZE = 64 * 1024;
	/**
	 * 超时时间
	 */
	public final static int TIMEOUT = 20000;
	/**
	 * 间隔时间
	 */
	public final static int INTERVAL = 10000;
}
