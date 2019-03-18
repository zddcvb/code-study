package com.yanxi.zookeeper.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;
import org.apache.zookeeper.ZooKeeper.States;
import org.apache.zookeeper.data.Stat;

public class ZookeeperUtils {
	private ZooKeeper zooKeeper;
	private String connectString = "192.168.145.128:2182,192.168.145.128:2183,192.168.145.128:2184";
	private int sessionTimeout = 2000;
	private String addr = "/";

	public ZookeeperUtils() {
		init();
	}
	/**
	 * 初始化zookeeper
	 * 
	 */
	private void init() {
		try {
			zooKeeper = new ZooKeeper(connectString, sessionTimeout, new Watcher() {
				@Override
				public void process(WatchedEvent event) {
					getData(addr);
					getChildren(addr);
				}
			});
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 创建节点
	 * @param path 节点路径名称
	 * @param data 节点数据
	 */
	public void createNode(String path, byte[] data) {
		try {
			if (zooKeeper.getState() == States.CONNECTED) {
				String result = zooKeeper.create(path, data, null, CreateMode.PERSISTENT_SEQUENTIAL);
				System.out.println("result:" + result);
			}
		} catch (KeeperException | InterruptedException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获得路径下的子节点
	 * @param path 需要查询的路径
	 * @return list集合
	 */
	public List<String> getChildren(String path) {
		List<String> children = new ArrayList<>();
		try {
			if (zooKeeper.getState() == States.CONNECTED) {
				children = zooKeeper.getChildren(path, true);
			}
		} catch (KeeperException | InterruptedException e) {
			e.printStackTrace();
		}
		return children;
	}
	/**
	 * 为节点设置数据
	 * @param path 节点路径名称
	 * @param data 节点新数据
	 * @param version 节点的版本
	 * @return Stat对象，保存了当前节点下所有的数据信息
	 */
	public Stat setData(String path, byte[] data, int version) {
		Stat stat = null;
		try {
			stat = zooKeeper.setData(path, data,version);
		} catch (KeeperException | InterruptedException e) {
			e.printStackTrace();
		}
		return stat;
	}
	/**
	 * 获得节点数据
	 * @param path 节点名称
	 * @return byte[]数组
	 */
	public byte[] getData(String path) {
		byte[] data = null;
		try {
			if (zooKeeper.getState() == States.CONNECTED) {
				data = zooKeeper.getData(path, true, new Stat());
			}
		} catch (KeeperException | InterruptedException e) {
			e.printStackTrace();
		}
		return data;
	}
}
