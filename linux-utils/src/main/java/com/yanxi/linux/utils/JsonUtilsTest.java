package com.yanxi.linux.utils;

import java.util.ArrayList;
import java.util.List;
import org.junit.Test;

public class JsonUtilsTest {

	@Test
	public void test() {
		List<User> list=new ArrayList<User>();
		list.add(new User(1, "jack"));
		list.add(new User(2,"mary"));
		String listToJson = JsonUtils.listToJson(list);
		System.out.println(listToJson);
	}
	@Test
	public void test_01(){
		String json="[{\"id\":1,\"name\":\"jack\"},{\"id\":2,\"name\":\"mary\"}]";
		List<User> jsonToList = JsonUtils.jsonToList(json, User.class);
		System.out.println(jsonToList);
	}

}
