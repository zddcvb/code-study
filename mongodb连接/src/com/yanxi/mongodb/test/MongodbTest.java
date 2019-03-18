package com.yanxi.mongodb.test;

import org.junit.Test;

import com.yanxi.mongodb.domain.User;
import com.yanxi.mongodb.utils.MongodbUtil;

public class MongodbTest {
	@SuppressWarnings("unused")
	@Test
	public void test_init() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
	}

	@Test
	public void test_createCol() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.createCol("myinfo");
	}

	@Test
	public void test_insert() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.insert("myinfo");
	}

	@Test
	public void test_findAll() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.findAll("myinfo");
	}

	@Test
	public void test_udpate() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		User user = new User(2, "lucy");
		util.update("myinfo", user);
	}

	@Test
	public void test_delete() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.delete("myinfo", 3);
	}

	@Test
	public void test_deleteAll() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.deleteAll("myinfo");
	}

	@Test
	public void test_findById() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		util.findById("myinfo", 2);
	}

	@Test
	public void test_findByIds() {
		MongodbUtil util = new MongodbUtil("localhost", 27017);
		int[] ids = { 1, 3, 5, 7, 2 };
		util.findByIds("myinfo", ids);
	}
}
