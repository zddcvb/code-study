package com.yanxi.hibernate.pojo;

import java.util.List;

public class Demo {
	private int id;
	private String name;
	private String length;
	//一对多
	private List<TestBean> testBeans;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLength() {
		return length;
	}
	public void setLength(String length) {
		this.length = length;
	}
	public List<TestBean> getTestBeans() {
		return testBeans;
	}
	public void setTestBeans(List<TestBean> testBeans) {
		this.testBeans = testBeans;
	}
	
}
