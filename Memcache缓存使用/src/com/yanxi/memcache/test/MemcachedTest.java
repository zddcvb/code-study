package com.yanxi.memcache.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.yanxi.memcache.utils.MemcachedUtils;

public class MemcachedTest {
	@Test
	public void test_set() {
		MemcachedUtils utils = new MemcachedUtils();
		Map<String, Integer> map = new HashMap<>();
		map.put("age", 20);
		map.put("data", 1950);
		utils.set("map", 0, map);
	}

	@Test
	public void test_add() {
		MemcachedUtils utils = new MemcachedUtils();
		utils.add("name_02", 0, "lucy02");
	}

	@Test
	public void test_get() {
		MemcachedUtils utils = new MemcachedUtils();
		utils.get("map");
	}

	@Test
	public void test_append() {
		MemcachedUtils utils = new MemcachedUtils();
		utils.append("name_02", "lucy");
	}
}
